# Discover Consul settings
module "mail" {
  source       = "../mail"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
}

# Configure our Consul provider, module can't do it for us
provider "consul" {
  address    = "${module.consul.address}"
  scheme     = "${module.consul.scheme}"
  datacenter = "${module.consul.datacenter}"
}

# Publish our outputs into Consul for our application to consume
resource "consul_keys" "config" {
  key {
    name   = "smtp_user"
    path   = "${module.consul.config_prefix}/SMTP/SESUser"
    value  = "${aws_iam_access_key.email.id}"
    delete = true
  }

  key {
    name   = "smtp_password"
    path   = "${module.consul.config_prefix}/SMTP/SESPassword"
    value  = "${aws_iam_access_key.email.ses_smtp_password}"
    delete = true
  }

  key {
    name   = "smtp_host"
    path   = "${module.consul.config_prefix}/SMTP/SESServer"
    value  = "email-smtp.${var.region}.amazonaws.com"
    delete = true
  }
}
