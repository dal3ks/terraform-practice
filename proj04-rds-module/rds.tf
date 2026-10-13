module "database" {
  source       = "./modules/rds"
  project_name = "proj04-rds-module"

  credentials = {
    username = "db-admin"
    password = "abc1+?_"
  }
}