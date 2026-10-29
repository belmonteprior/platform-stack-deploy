terraform {
  required_version = ">= 1.0.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

resource "null_resource" "hyperv_vms" {
  provisioner "local-exec" {
    command = "powershell.exe -ExecutionPolicy Bypass -File ./create-vms.ps1"
  }
}
