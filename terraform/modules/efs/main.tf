resource "aws_efs_file_system" "this" {
  # Using AWS defaults: generalPurpose + bursting
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-efs"
  })
}

resource "aws_efs_mount_target" "this" {
  # use static keys (indexes) so Terraform is happy at plan time
  for_each = {
    for idx, subnet_id in var.private_subnet_ids :
    idx => subnet_id
  }

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [var.efs_sg_id]
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/"

    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-efs-ap"
  })
}
