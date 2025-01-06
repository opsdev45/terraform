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

variable "gsis" {
    description = "List of GSIs to create"
    type = list(object({
        gsi_name             = string
        gsi_hash_key         = string
        gsi_hash_key_type    = string
        gsi_range_key        = string
        gsi_range_key_type   = string
        gsi_write_capacity   = number
        gsi_read_capacity    = number
        gsi_projection_type  = string
        gsi_non_key_attributes = list(string)
    }))
    default = []
}

# variable "replicas" {
#     description = "List of replicas to create"
#     type = list(object({
#         region_name      = string
#     }))
#     default = []
# }
variable "stream_type" {
    type = string
    default = "NEW_AND_OLD_IMAGES"

}
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
