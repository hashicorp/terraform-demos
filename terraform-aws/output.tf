# Copyright IBM Corp. 2018

output "app_subnet" {
  value = "${aws_subnet.sub.*.id}"
}

output "cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

output "ip_address" {
    value = "${aws_instance.server.*.private_ip}"
}