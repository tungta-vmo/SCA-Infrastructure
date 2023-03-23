data "template_file" "bastion_startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}

module "bastion_host" {
  source                             = "../../modules/iap_bastion_host"
  name                               = var.bastion_host_name
  name_prefix                        = var.bastion_host_name_prefix
  project                            = var.project_id
  host_project                       = var.shared_vpc_host_project_id
  zone                               = var.zone
  region                             = var.region
  network                            = data.google_compute_network.shared_vpc.self_link
  subnet                             = data.google_compute_subnetwork.subnet_shared_vpc.self_link
  fw_name_allow_ssh_from_iap         = var.bastion_host_firewall_rule_name
  members                            = var.bastion_host_members
  image                              = var.bastion_host_image
  image_family                       = var.bastion_host_image_family
  image_project                      = var.bastion_host_image_project
  machine_type                       = var.bastion_host_machine_type
  disk_size_gb                       = var.bastion_host_disk_size_gb
  disk_type                          = var.bastion_host_disk_type
  ssh_user                           = var.bastion_host_ssh_user
  ssh_public_key                     = var.bastion_host_ssh_public_key
  service_account_name               = var.bastion_host_service_account_name
  startup_script                     = data.template_file.bastion_startup_script.rendered
  service_account_roles_supplemental = [
    "roles/container.admin",
    "roles/compute.instanceAdmin",
    "roles/iam.serviceAccountUser",
    "roles/iap.tunnelResourceAccessor"
  ]
}