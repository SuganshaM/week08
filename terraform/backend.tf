# Remote state backend.
#
# Left intentionally empty (a "partial configuration") so that no account-
# specific values are committed to the repository. Values are supplied:
#   - locally, via `terraform init -backend-config=backend.hcl` (gitignored)
#   - in CI, via `-backend-config=` flags built from GitHub Actions
#     variables/secrets (see .github/workflows/00-terraform.yml)
#
# Using a remote backend (the storage account already provisioned by this
# configuration) means the pipeline and your local machine share the same
# state file, so `terraform plan` in GitHub Actions reflects the real,
# already-provisioned infrastructure instead of starting from a blank slate.
terraform {
  backend "azurerm" {}
}
