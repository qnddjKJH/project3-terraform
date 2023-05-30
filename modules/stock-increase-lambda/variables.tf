variable "role_name" {
  description = "역할 이름"
  type = string
  default = "testRole"
}

# lambda 환경변수
variable "db_host_name" {
  description = "디비 주소"
  type = string
}

variable "db_user_name" {
  description = "디비 사용자"
  type = string
}

variable "db_password" {
  description = "디비 사용자 암호"
  type = string
}

variable "db_database" {
  description = "사용 디비"
  type = string
}