locals {
  common_tags = {
    "Managed by" = "Terraform"
  }
}

locals {
  ami = {
    "ubuntu" = "ami-01811d4912b4ccb26"
    "redhat" = "ami-0b748249d064044e8"
    "suse"   = "ami-0945845b39d75e25f"
  }
  ssh_user = {
    "ami-01811d4912b4ccb26" = "ubuntu"
    "ami-0b748249d064044e8" = "redhat" 
    "ami-0945845b39d75e25f" = "suse"   
  }
  selected_ami = lookup(local.ami, var.Operation_System)
  user_name = lookup(local.ssh_user,local.selected_ami,"no need")
}