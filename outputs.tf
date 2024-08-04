#  output "subnet" {
#    value=aws_subnet.ownsubnet.id
# }

output "aws_ami_id"{
    value=module.myserver.ec2.ami
}