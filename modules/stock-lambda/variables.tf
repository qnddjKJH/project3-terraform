variable "role_name" {
  description = "역할 이름"
  type = string
  default = "testRole"
}

# lambda 환경변수
variable "callback_Url" {
  description = "콜백 주소"
  type = string
}

variable "sales_api_queue_arn" {
  description = "out of stock queue arn"
  type = string
}