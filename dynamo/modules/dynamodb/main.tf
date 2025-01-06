resource "aws_dynamodb_table" "dynamodb_table" {
    name           = var.table_name
    billing_mode   = var.billing_mode
    read_capacity  = var.read_capacity
    write_capacity = var.write_capacity
    hash_key       = var.hash_key
    range_key      = var.range_key

    attribute {
        name = var.hash_key
        type = var.hash_key_type
    }

    attribute {
        name = var.range_key
        type = var.range_key_type
    }

    dynamic "attribute" {
        for_each = var.gsis != null ? var.gsis : []
        content {
            name = attribute.value.gsi_range_key
            type = attribute.value.gsi_range_key_type
        }
    }
    dynamic "attribute" {
        for_each = var.gsis != null ? var.gsis : []
        content {
            name = attribute.value.gsi_hash_key
            type = attribute.value.gsi_hash_key_type
        }
    }

    server_side_encryption {
        enabled     = true
        kms_key_arn = var.kms_key_arn
        
    }
    lifecycle {
        ignore_changes = [read_capacity,write_capacity]
    }

    point_in_time_recovery {
        enabled = true
    }
    
    stream_enabled = true
    stream_view_type = var.stream_type

    dynamic "global_secondary_index" {
        for_each = var.gsis != null ? var.gsis : []
        content {
            name               = global_secondary_index.value.gsi_name
            hash_key           = global_secondary_index.value.gsi_hash_key
            range_key          = global_secondary_index.value.gsi_range_key
            write_capacity     = global_secondary_index.value.gsi_write_capacity
            read_capacity      = global_secondary_index.value.gsi_read_capacity
            projection_type    = global_secondary_index.value.gsi_projection_type
            non_key_attributes = global_secondary_index.value.gsi_non_key_attributes
        }
    }


    tags = var.tags
}
resource "aws_dynamodb_replica_tables" "replica" {
    # We use depends_on and reference back to the original table ARN to ensure
    # that this resource will be created only after the original table, plus its
    # auto-scaling rules, have already been created
    depends_on = [
        aws_appautoscaling_target.write_target,
        aws_appautoscaling_policy.write_policy,
    ]

    original_table_arn = aws_dynamodb_table.dynamodb_table.arn

    dynamic "region" {
        for_each = var.replicas != null ? var.replicas : []
        content {
        region_name = region.value.region_name
        }
    }
}


resource "aws_appautoscaling_target" "read_target" {
    max_capacity       = var.read_max_capacity
    min_capacity       = var.read_min_capacity
    resource_id        = "table/${aws_dynamodb_table.dynamodb_table.name}"
    scalable_dimension = "dynamodb:table:ReadCapacityUnits"
    service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_policy" {
    name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target.resource_id}"
    policy_type        = "TargetTrackingScaling"
    resource_id        = aws_appautoscaling_target.read_target.resource_id
    scalable_dimension = aws_appautoscaling_target.read_target.scalable_dimension
    service_namespace  = aws_appautoscaling_target.read_target.service_namespace

    target_tracking_scaling_policy_configuration {
        predefined_metric_specification {
            predefined_metric_type = "DynamoDBReadCapacityUtilization"
        }

    target_value       = var.read_target_value
    scale_in_cooldown  = var.read_scale_in_cooldown
    scale_out_cooldown = var.read_scale_out_cooldown
    }
}

resource "aws_appautoscaling_target" "write_target" {
    max_capacity       = var.write_max_capacity
    min_capacity       = var.write_min_capacity
    resource_id        = "table/${aws_dynamodb_table.dynamodb_table.name}"
    scalable_dimension = "dynamodb:table:WriteCapacityUnits"
    service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_policy" {
    name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target.resource_id}"
    policy_type        = "TargetTrackingScaling"
    resource_id        = aws_appautoscaling_target.write_target.resource_id
    scalable_dimension = aws_appautoscaling_target.write_target.scalable_dimension
    service_namespace  = aws_appautoscaling_target.write_target.service_namespace

    target_tracking_scaling_policy_configuration {
        predefined_metric_specification {
            predefined_metric_type = "DynamoDBWriteCapacityUtilization"
        }

    target_value       = var.write_target_value
    scale_in_cooldown  = var.write_scale_in_cooldown
    scale_out_cooldown = var.write_scale_out_cooldown
    }
}
