terraform {
  backend "s3" {
    bucket       = "pulseops-terraform-state-366428725717"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}