variable "amis" {
    type = map
    default = {
        "us-east-1" = "ami-020cba7c55df1f615"
        "us-east-2" = "ami-0d1b5a8c13042c939"
    }
}

variable "cidr_blocks_remote_access" {
    type = list
    # cidr_blocks = ["170.247.10.21/32"] # PMS 2025-07-14
    default = ["0.0.0.0/32"]
}

variable "key_name" {
    default = "Openshift-Key used everywhere"
}
