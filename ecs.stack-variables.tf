
################ ###################################################### ########
################ Module [[[infrastructure stack]]] Input Variables List ########
################ ###################################################### ########




variable in_vpc_id {
   description = "The ID of the existing VPC in which to create the subnet network."
}

variable in_private_subnet_ids {
    description = "The private subnet IDS in every availability zone of this VPC."
}


variable in_public_subnet_ids {
    description = "The public subnet IDS in every availability zone of this VPC."
}







### ################# ###
### in_workload_names ###
### ################# ###

variable in_workload_names {
    description = "The list of container workload names."
    type = list
}


### ################# ###
### in_workload_ports ###
### ################# ###

variable in_workload_ports {
    description = "The list of container workload ports."
    type = list
}


### ##############b######### ###
### in_container_definitions ###
### ##############b######### ###

variable in_container_definitions {
    description = "A list of the ubiquitous JSON formatted container workload definitions."
    type = list
}


### ################################# ###
### [[variable]] in_service_protocols ###
### ################################# ###

variable in_service_protocols {

    description = "The list of service protocols whose ports and descriptions are mapped in the traffic lookup."
    type        = list
}


### ################################# ###
### [[variable]] in_health_check_uris ###
### ################################# ###

variable in_health_check_uris {

    description = "The path without the leading forward slash used by the load balancer to assess service health."
    type        = list
}


### ########################## ###
### [[variable]] in_zone_names ###
### ########################## ###

variable in_zone_names {

    description = "A list of Route53 hosted zone names that match up to the DNS names list."
    type        = "list"
}


### ######################### ###
### [[variable]] in_dns_names ###
### ######################### ###

variable in_dns_names {

    description = "A list of DNS names that are positioned in Route53 with a lookable up zone ID."
    type        = "list"
}


### ############################## ###
### [[variable]] in_security_rules ###
### ############################## ###

variable in_security_rules {
    description = "The human friendly one word rule list of the traffic types that will gain ingress access."
    type = list
}


### #################################### ###
### [[variable]] in_host_managed_volumes ###
### #################################### ###

variable in_host_managed_volumes {

    description = "A map of the name and path on he host for drive mapping via host managed volumes."
    type        = map
    default     = { }
}


### ###################################### ###
### [[variable]] in_docker_managed_volumes ###
### ###################################### ###

variable in_docker_managed_volumes {

    description = "The list of names for the drive mapping of docker managed volumes."
    type        = list
    default     = [ ]
}


### ################### ###
### in_ecs_policy_stmts ###
### ################### ###

variable in_ecs_policy_stmts {

    description = "The Policy statements defining the AWS resource access the ec2 instances will enjoy."
}


### ###########]####### ###
### in_ec2_policy_stmts ###
### ################### ###

variable in_ec2_policy_stmts {

    description = "The Policy statements defining the AWS resource access the ec2 instances will enjoy."
}


### ###########]####### ###
### in_ami_id ###
### ################### ###

variable in_ami_id {
}


### ################# ###
### in_ssh_public_key ###
### ################# ###

variable in_ssh_public_key {
    description = "The public key that the EC2 cluster instances are plied with."
}


### ############################## ###
### [[variable]] in_mandated_tags ###
### ############################## ###

variable in_mandated_tags {

    description = "Optional tags unless your organization mandates that a set of given tags must be set."
    type        = map
    default     = { }
}


### ############ ###
### in_ecosystem ###
### ############ ###

variable in_ecosystem {
    description = "Creational stamp binding all infrastructure components created on behalf of this ecosystem instance."
}


### ############ ###
### in_timestamp ###
### ############ ###

variable in_timestamp {
    description = "A timestamp for resource tags in the format ymmdd-hhmm like 80911-1435"
}


### ############## ###
### in_description ###
### ############## ###

variable in_description {
    description = "Ubiquitous note detailing who, when, where and why for every infrastructure component."
}

