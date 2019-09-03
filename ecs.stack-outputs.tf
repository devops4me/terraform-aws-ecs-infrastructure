
/*
 | --
 | -- Push out a list of the front-end load balancer urls.
 | --
*/
output out_load_balancer_dns_names {

    value = module.load-balancers.out_load_balancer_urls
}


/*
 | --
 | -- The ID of the security group that constrains traffic
 | -- to and from this infrastructure stack.
 | --
*/
output out_security_group_id {

    value = module.security-group.out_security_group_id
}


/*
 | --
 | -- The list of private subnet ( aggregation ) identifiers
 | -- that span the availability zones thus providing resilience
 | -- reliability and redundancy to the infrastructure stack.
 | --
*/
output out_private_subnet_ids {

    value = var.in_private_subnet_ids
}


/*
 | --
 | -- The list of public subnet ( aggregation ) identifiers
 | -- that span the availability zones thus providing resilience
 | -- reliability and redundancy to the infrastructure stack.
 | --
*/
output out_public_subnet_ids {

    value = var.in_public_subnet_ids
}
