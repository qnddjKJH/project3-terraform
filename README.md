# 자동 재고 확보 시스템을 위한 MSA 아키텍처
자동 재고 확보 시스템을 위한 MSA 아키텍처 설계 및 Terraform 을 사용하여 IaC 작업

## 💡 아키텍처 다이어그램
![image](https://github.com/qnddjKJH/project3-terraform/assets/53363080/8a2b7c1f-eead-4c5e-bfc0-b8d6b694fff2)

## 작업
최종 완성된 다이어그램 하단 Ads Stop Send Lambda 의 경우에는 SQS 는 자체적으로 Consume 되어 SES 에 보내진다고 다이어그램을 짰었으나 SQS 는 자체적으로 Consume 이 되지 않는 점을 알게되어 Lambda 를 더해 주어 최종 완성 하였다.

또한 RDS 에서 트리거 되어 Ads Stop Lambda 로 이벤트가 발생하도록 짜였는데 RDS 에서는 트리거를 발생하지 못하기 때문에 큰 어려움이 없다면 트리거 지원이 되는 DynamoDB 를 생각해 볼 수 있다.
