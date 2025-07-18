output "ips" {
    value = ["${aws_instance.dev5.public_ip}", "${aws_instance.dev5.private_ip}"]
}

output "dev4" {
    value = "${aws_instance.dev4.public_ip}"
}
