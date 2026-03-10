# Copyright IBM Corp. 2018

data "aws_route53_zone" "selected" {
  name = "${var.domain_root}."
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.app_name}.${var.domain_root}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.server.public_ip}"]
}
