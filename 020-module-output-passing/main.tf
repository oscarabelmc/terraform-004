terraform {
  required_version = ">= 1.5"
}

module "database" {
  source = "./modules/database"
  name   = "prod-db"
}

module "webapp" {
  source            = "./modules/webapp"
  db_connection_str = module.database.connection_string
}

output "db_connection" {
  value = module.database.connection_string
}

output "webapp_config" {
  value = module.webapp.config_file
}
