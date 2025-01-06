provider "aws" {
    region = "eu-west-2"
}

module "dynamodb" {
    source                      = "./modules/dynamodb"
    table_name                  = "GameScores"
    billing_mode                = "PROVISIONED"
    read_capacity               = 20
    write_capacity              = 20
    hash_key                    = "UserId"
    hash_key_type               = "S"
    range_key                   = "GameTitle"
    range_key_type              = "S"
    kms_key_arn                 = ""

    gsi_type                    = "N"
    gsi_name                    = "GameTitleIndex"
    gsi_hash_key                = "GameTitle"
    gsi_range_key               = "TopScore"
    gsi_write_capacity          = 10
    gsi_read_capacity           = 10
    gsi_projection_type         = "INCLUDE"
    gsi_non_key_attributes      = ["UserId"]

    read_max_capacity           = 20
    read_min_capacity           = 5
    read_target_value           = 70.0
    read_scale_in_cooldown      = 60
    read_scale_out_cooldown     = 60

    write_max_capacity          = 10
    write_min_capacity          = 5
    write_target_value          = 70.0
    write_scale_in_cooldown     = 60
    write_scale_out_cooldown    = 60

    tags = {
        Name        = "dynamodb-table-1"
        Environment = "production"
    }
}
