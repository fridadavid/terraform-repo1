output "vpc-id" {
  value = aws_vpc.myprac-vpc.id
}

output "vpc-arn" {
  value = aws_vpc.myprac-vpc.arn
}

output "pub_sub1-id" {
  value = aws_subnet.myprac-sub-pub1.id
}

output "pub_sub2-id" {
  value = aws_subnet.myprac-sub-pub2.id
}

output "pri_sub1-id" {
  value = aws_subnet.myprac-sub-pri1.id
}

output "pri_sub2-id" {
  value = aws_subnet.myprac-sub-pri2.id
}

output "pri_sub3-id" {
  value = aws_subnet.myprac-sub-pri3.id
}

output "pri_sub4-id" {
  value = aws_subnet.myprac-sub-pri4.id
}


