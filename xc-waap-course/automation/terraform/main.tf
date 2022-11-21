module "health_check" {
  source            = "./modules/health_check"
  health_check_name = format("%s-class-health-check-tf", var.name)
  namespace         = var.namespace
  health_check_path = var.health_check_path
}

module "ip_origin_pool" {
  source                   = "./modules/origin_pool"
  origin_pool_name         = format("%s-class-app-1", var.name)
  ip_origin_pool_name_port = var.ip_origin_pool_name_port
  health_check_name        = module.health_check.health_check_name
  namespace                = var.namespace
  site_name                = var.site_name
  service_name             = var.service_name
}

module "load_balancer" {
  source             = "./modules/load_balancer"
  load_balancer_name = format("%s-class-tf", var.name)
  origin_pool        = module.ip_origin_pool.name
  domains            = var.domains
  namespace          = var.namespace
  http_port          = var.http_port
  depends_on         = [module.ip_origin_pool]
}
