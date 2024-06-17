# 키 예시
#ssh-keygen -t rsa -b 4096 -C "" -f "/root/terraform/multi-tier-architecture-using-terraform/3tier-key" -N ""

data "aws_key_pair" "existing_keypair" {
  key_name = "3tier key"  # 기존 키페어의 이름을 설정합니다.
}