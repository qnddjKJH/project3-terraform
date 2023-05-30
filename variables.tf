# lambda 환경변수
variable "db_host_name" {
  description = "디비 주소"
  type = string
  default = "project3db2.cpajpop7ewnt.ap-northeast-2.rds.amazonaws.com"
}

variable "db_user_name" {
  description = "디비 사용자"
  type = string
  default = "team8"
}

variable "db_password" {
  description = "디비 사용자 암호"
  type = string
  default = "team8"
}

variable "db_database" {
  description = "사용 디비"
  type = string
  default = "team8"
}
