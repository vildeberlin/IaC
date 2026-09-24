# TerraNova – reusable OpenStack foundation (Terraform / OpenTofu)

A reusable Terraform/OpenTofu project that provisions a 3-tier network, frontend and database VMs
(cloud-init), an optional Octavia load balancer, persistent block storage and Swift containers on OpenStack.
The root module (`terranova-poc`) is a proof-of-concept that wires the modules together.

## Architecture

```
            Internet / external network
                     |
                  [router]
                     |
   frontend subnet 10.10.1.0/24  -- LB VIP (optional) -- web VM(s) (nginx)
   backend  subnet 10.10.2.0/24  -- reserved for the application tier
   database subnet 10.10.3.0/24  -- DB VM (PostgreSQL) + Cinder volume
```

## Modules

| Module | Purpose |
|---|---|
| `modules/network` | Network, 3 subnets, router + interfaces, security groups and rules (driven by a map variable) |
| `modules/virtual-machine` | Ports, instances (cloud-init `user_data`), optional floating IPs, attaches volumes at creation |
| `modules/persistent-storage` | Cinder volumes (`for_each` over a map) |
| `modules/storage-container` | Swift object-storage containers |
| `modules/load-balancer` | Octavia LB, one listener/pool/health monitor per service, members, optional floating IP |

The root module holds the key pair, wires modules together, and contains `cloud-init/*.tftpl` templates.
Templates are replaceable through `frontend_cloud_init_template` / `db_cloud_init_template`.

## Prerequisites

- Terraform >= 1.5 **or** OpenTofu >= 1.6
- OpenStack project with Neutron, Nova, Cinder, Octavia and Swift; credentials in `~/.config/openstack/clouds.yaml`
  (set `os_cloud`) or the `OS_*` environment variables (leave `os_cloud = null`)
- An existing external network, an Ubuntu image and a flavor (names go in `poc.tfvars`)
- An SSH public key (`ssh_public_key_path`)
- Outbound internet from the VMs (via the router) so cloud-init can install nginx/PostgreSQL

## Remote state

1. Create a bucket/container for state (S3-compatible endpoint in the OpenStack installation).
2. `cp backend.tf.example backend.tf` and edit endpoint/bucket, export `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`.
3. Split state according to best practice through the `key`: `<customer>/<environment>/<layer>/terraform.tfstate`.
   Separate environments (poc/prod) never share state; for larger customers, split layers
   (network+storage / compute / load balancer) into separate root modules and read each other with
   `terraform_remote_state`. In this PoC everything sits in one `core` layer to stay simple.

Without `backend.tf`, state is kept locally.

## Usage

```bash
cd ntnu-username/assignment1/terranova-poc

terraform init                       # download providers/modules, configure backend
terraform validate                   # syntax check
terraform plan  -var-file=poc.tfvars # show what will change, changes nothing
terraform apply -var-file=poc.tfvars # create/update the infrastructure (asks for confirmation)
terraform output                     # show outputs again
terraform destroy -var-file=poc.tfvars # remove everything in the state
```

(OpenTofu: replace `terraform` with `tofu`.)

`plan` compares configuration, state and reality and prints a diff. `apply` executes that plan.
`destroy` deletes all resources tracked in the state, in reverse dependency order.

### Verify

```bash
LB=$(terraform output -json lb_endpoints | jq -r .http)
curl $LB/                      # repeat: alternates between web-1 and web-2
$(terraform output -raw ssh_hint)   # SSH to DB VM via a frontend VM (jump host)
```

On the DB VM: `sudo -u postgres psql -c '\l'`. Check cloud-init with `cloud-init status --long`.

## Important inputs (see `variables.tf`, sample in `poc.tfvars`)

| Variable | Description |
|---|---|
| `network_name`, `router_name`, `subnets` | Naming and CIDRs of the three tiers |
| `security_groups`, `admin_cidr` | Add/override security groups; SSH source range |
| `frontend_*`, `db_*` | Name, count, image, flavor, cloud-init template, volumes |
| `volumes`, `frontend_volume_keys`, `db_volume_keys` | Create volumes and choose which VMs get them (i-th key -> i-th VM) |
| `containers` | Swift containers |
| `enable_load_balancer`, `lb_name`, `lb_services` | LB flag and per-service listen/member ports, method, health check |

Example: load balance HTTP and HTTPS passthrough:

```hcl
lb_services = {
  http  = { protocol = "HTTP", listen_port = 80,  member_port = 80,  monitor_url_path = "/health" }
  https = { protocol = "TCP",  listen_port = 443, member_port = 443, monitor_type = "TCP" }
}
```

## Outputs

`network_id`, `subnet_ids`, `frontend_vm_ids`, `frontend_private_ips`, `frontend_floating_ips`, `db_vm_ids`,
`db_private_ips`, `lb_endpoints`, `volume_ids`, `volume_names`, `container_names`, `ssh_hint`.

## Notes / limitations

- The DB password ends up in `user_data` and in state – acceptable for a PoC, use a secret manager otherwise.
- Attached volumes are not formatted/mounted by cloud-init; extend the template if needed.
- No SSL is configured (out of scope).
- Reusing for a new customer: copy the root module, change `poc.tfvars`, `name_prefix`, and the backend `key`.

## Screenshots

- `screenshots/apply.png` – successful `terraform apply`
- `screenshots/destroy.png` – successful `terraform destroy`

(Add these after running against the real OpenStack environment.)
