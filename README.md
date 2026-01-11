# Terraform_AWS
AWS 공부 및 Terraform 공부

### Replica_EC2
aws_ebs_snapshot의 경우 이미 생성된 리소스에 대해 volume_id 인수를 검사하지 않는 것 같음
원본 ebs가 삭제되어도 따로 에러가 발생되지 않음
즉, 이 코드에서는 ignore는 아무런 기능이 없음# Terraform_AWS