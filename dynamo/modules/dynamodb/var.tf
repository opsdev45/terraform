variable "table_name" {}
variable "billing_mode" {}
variable "read_capacity" {}
variable "write_capacity" {}
variable "hash_key" {}
variable "hash_key_type" {}
variable "range_key" {}
variable "range_key_type" {}

variable "kms_key_arn" {
    type        = string
    sensitive = true
}

variable "gsi_name" {}
variable "gsi_hash_key" {}
variable "gsi_range_key" {}
variable "gsi_write_capacity" {}
variable "gsi_read_capacity" {}
variable "gsi_projection_type" {}
variable "gsi_non_key_attributes" {}


variable "read_max_capacity" {}
variable "read_min_capacity" {}
variable "read_target_value" {}
variable "read_scale_in_cooldown" {}
variable "read_scale_out_cooldown" {}

variable "write_max_capacity" {}
variable "write_min_capacity" {}
variable "write_target_value" {}
variable "write_scale_in_cooldown" {}
variable "write_scale_out_cooldown" {}

variable "tags" {
    type = map(string)
}
