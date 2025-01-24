env_name            = "dev"
custom_webpage_text = "Deployed via Terraform - Dev Environment"

#Plan and Apply for dev Environment

terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
