
/*
 | --
 | -- The ECS cluster resource declarations are handled by this module
 | -- and include kingpins like the task definitions, ECS services and
 | -- the cluster itself.
 | --
*/
module ecs-cluster {

    source = "github.com/devops4me/terraform-aws-ecs-cluster"

    in_workload_names = var.in_workload_names
    in_workload_ports = var.in_workload_ports

    in_ecs_task_role_arn     = module.ecs-role-profile.out_ecs_task_role_arn
    in_container_definitions = var.in_container_definitions
    in_target_group_ids      = module.load-balancers.out_target_group_ids

    in_http_listener  = module.load-balancers.out_http_listener
    in_https_listener = module.load-balancers.out_https_listener

    in_host_managed_volumes   = var.in_host_managed_volumes
    in_docker_managed_volumes = var.in_docker_managed_volumes

    in_mandated_tags = var.in_mandated_tags
    in_ecosystem     = var.in_ecosystem
    in_timestamp     = var.in_timestamp
    in_description   = var.in_description
}


/*
 | --
 | -- This module manages the transfer of ECS task access policies from
 | -- an incoming JSON statement format to an outgoing ARN of the AWS IAM
 | -- role that wraps the access policies.
 | --
*/
module ecs-role-profile {

    source = "github.com/devops4me/terraform-aws-ecs-role-profile"

    in_ecs_policy_stmts = var.in_ecs_policy_stmts
    in_ecosystem_name   = var.in_ecosystem
    in_tag_timestamp    = var.in_timestamp
}



/*
 | --
 | -- This module manages the transfer of ec2 access policies from an
 | -- incoming JSON statement format to an outgoing ID of the instance
 | -- profile that wraps the access policies.
 | --
 | -- The output ID can go into the input iam_instance_profile of either
 | -- an EC2 instance (aws_instance) or a launch configuration resoure
 | -- (see aws_launch_configuration).
 | --
*/
module ec2-role-profile {

    source = "github.com/devops4me/terraform-aws-ec2-role-profile"

    in_ec2_policy_stmts = var.in_ec2_policy_stmts
    in_ecosystem_name   = var.in_ecosystem
    in_tag_timestamp    = var.in_timestamp
}



/*
 | --
 | -- When the clustered ec2 instances are reaching the end of their
 | -- tether this auto scaling group (and launch configuration) sees
 | -- to it that more are automatically provisioned.
 | --
*/
module auto-scaling {

    source = "github.com/devops4me/terraform-aws-ec2-auto-scaling"

    in_ami_id         = var.in_ami_id
    in_ssh_public_key = var.in_ssh_public_key
    in_instance_type  = "t2.xlarge"

    in_instance_profile_id = module.ec2-role-profile.out_instance_profile_id
    in_security_group_id   = module.security-group.out_security_group_id
    in_subnet_ids          = var.in_private_subnet_ids
    in_user_data_script    = module.ecs-cluster.out_user_data_script

    in_ecosystem_name  = var.in_ecosystem
    in_tag_timestamp   = var.in_timestamp
    in_tag_description = var.in_description
    in_mandated_tags  = var.in_mandated_tags

}



/*
 | --
 | -- At its architectural heart the application load balancer is designed
 | -- to separate interface from implementation.
 | --
 | -- The interface listens for web traffic on both port 80 and 443 (tls).
 | -- The implementation at the back end is handled by the target group.
 | --
*/
module load-balancers {

    source = "github.com/devops4me/terraform-aws-web-load-balancers"

    in_service_protocols  = var.in_service_protocols
    in_health_check_uris  = var.in_health_check_uris
    in_dns_names          = var.in_dns_names
    in_vpc_id             = var.in_vpc_id
    in_security_group_ids = [ module.security-group.out_security_group_id ]
    in_subnet_ids         = var.in_public_subnet_ids

    in_mandated_tags = var.in_mandated_tags
    in_ecosystem      = var.in_ecosystem
    in_timestamp      = var.in_timestamp
    in_description    = var.in_description

}



/*
 | --
 | -- Unite the human memorable DNS names with the front-end load balancer
 | -- names in a kind of marriage so that visiting one service effectively
 | -- routes to the load balancer that is sitting in front of it.
 | --
 | -- The list of route53 hosted zone names must contain trailing periods.
 | --
*/
module dns-mapping {

    source        = "github.com/devops4me/terraform-aws-dns-mapping"
    in_zone_names = var.in_zone_names
    in_dns_names  = var.in_dns_names
    in_dns_urls   = module.load-balancers.out_load_balancer_urls
}



/*
 | --
 | -- You can do away with long repeating and hard to read security group
 | -- declarations in favour of a succinct one word security group rule
 | -- definition. This module understands the common traffic protocols like
 | -- ssh (22), https (443), sonarqube (9000), jenkins (8080) and so on.
 | --
*/
module security-group {

    source     = "github.com/devops4me/terraform-aws-security-group"
    in_ingress = var.in_security_rules
    in_vpc_id  = var.in_vpc_id

    in_ecosystem_name  = var.in_ecosystem
    in_tag_timestamp   = var.in_timestamp
    in_tag_description = var.in_description
    in_mandated_tags  = var.in_mandated_tags
}


module ec2-instance {

    source                  = "github.com/devops4me/terraform-aws-ec2-instance-cluster"

    in_node_count           = 1
    in_iam_instance_profile = module.ec2-role-profile.out_instance_profile_id
    in_ssh_public_key       = var.in_ssh_public_key

    in_ami_id               = data.aws_ami.ubuntu-1804.id
    in_subnet_ids           = var.in_public_subnet_ids
    in_security_group_ids   = [ module.security-group.out_security_group_id ]

    in_ecosystem_name       = var.in_ecosystem
    in_tag_timestamp        = var.in_timestamp
    in_tag_description      = var.in_description
    in_mandated_tags        = var.in_mandated_tags
}

/*
 | --
 | -- Use the AMI data filter to find the ID of the Ubuntu 18.04 image
 | -- within the region that we are currently in.
 | --
*/
data aws_ami ubuntu-1804 {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = [ "hvm" ]
    }

    owners = [ "099720109477" ]
}


