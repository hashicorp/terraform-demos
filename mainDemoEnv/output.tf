# Copyright IBM Corp. 2018

output "public_ip" {
  value = "${aws_instance.server.public_ip}"
}

output "url" {
  value = "${aws_route53_record.www.name}"
}
