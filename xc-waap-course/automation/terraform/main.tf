module "health_check" {
  source            = "./modules/health_check"
  name              = format("%s-class-health-check-tf", var.name)
  namespace         = var.namespace
  health_check_path = var.health_check_path
}

module "ip_origin_pool" {
  source            = "./modules/origin_pool"
  name              = format("%s-pool-tf", var.name)
  origin_pool_port  = "80"
  origin_pool_ip    = "1.1.1.1"
  health_check_name = module.health_check.health_check_name
  namespace         = var.namespace
}

module "load_balancer" {
  source      = "./modules/load_balancer"
  name        = format("%s-lb-tf", var.name)
  origin_pool = module.ip_origin_pool.name
  domains     = "yourfqdn.aws.f5learn.cloud"
  namespace   = var.namespace
  http_port   = var.http_port
  depends_on  = [module.ip_origin_pool]
}
