
data aws_ami ami {
  //  AWS is owner
  owners      = ["137112412989"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource tls_private_key key_pair_key {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource aws_key_pair key_pair {
  key_name   = local.ssh_name
  public_key = tls_private_key.key_pair_key.public_key_openssh
  tags = local.tags
}

resource local_file key_pair {
  filename = "${path.cwd}/${local.ssh_name}.pem"
  sensitive_content = tls_private_key.key_pair_key.private_key_pem
  file_permission = "0600"
}

resource aws_launch_template ssh_template {
  count = local.enable_ssh_proxy_count

  name          = local.ssh_name
  image_id      = data.aws_ami.ami.id
  instance_type = "t1.micro"
  key_name = aws_key_pair.key_pair.key_name

  vpc_security_group_ids = [aws_default_security_group.default.id, aws_security_group.ssh_ingress.id]

  tags = local.ssh_tags
  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.ssh_tags, map("SSHUSER", "ec2-user"))
  }
}

resource aws_autoscaling_group ssh {
  count = local.enable_ssh_proxy_count

  name     = local.ssh_name
  min_size = 1
  max_size = 1

  dynamic "tag" {
    for_each = local.ssh_tags

    content {
      key   = tag.key
      value = tag.value
      //      Don't need to propagate since they are set in the launch template
      propagate_at_launch = false
    }
  }

  vpc_zone_identifier = aws_subnet.public.*.id

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "capacity-optimized"
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ssh_template[0].id
        version            = "$Latest"
      }
      override {
        instance_type = "t2.nano"
      }
      override {
        instance_type = "t3.nano"
      }
      override {
        instance_type = "t3a.nano"
      }
    }
  }
}