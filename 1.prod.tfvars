env_name            = "prod"
custom_webpage_text = "Deployed via Terraform - Prod Environment"

#for production Environment

terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
