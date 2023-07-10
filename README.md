# 자동 재고 확보 시스템을 위한 MSA 아키텍처
자동 재고 확보 시스템을 위한 MSA 아키텍처 설계 및 Terraform 을 사용하여 IaC 작업

## 💡 아키텍처 다이어그램
![image](https://github.com/qnddjKJH/project3-terraform/assets/53363080/ca6023be-eb6e-4f05-9d69-b02cf0c501ee)


## 요구사항
 1. 재고부족으로 인한 구매실패에 대한 조치
    - Sales API 를 통해 요청을 받은 서버가 데이터베이스에서 재고를 확인한다.
    - 재고 있음 : 재고를 감소하고 판매완료 메시지를 응답한다
    - 재고 없음 : 공장 주문, 재고 없음 메시지 페이로드가 주제로 생성된다.
    - 메시지가 느슨하게 연결된 시스템을 통해 처리되도록 따로 보관
 3. 메시지 누락 상황에 대한 조치
    - 빈번한 요청으로 메시지 누락 발생
    - 메시지가 처리되지 않은 경우 처리되지 않은 메시지를 관리할 공간 생성
    - 메시지 처리 보관 리소스와 처리되지 않은 메시지 처리 리소스가 연결
 5. Legacy 시스템(Factory → Warehouse) 성능문제에 대한 조치
    - 안정적으로 이벤트가 전달될 수 있는 시스템을 구축해야 합니다.
    - 메시지를 소비하는 리소스를 통해 Factory API가 호출됩니다.
    - Factory의 생산 완료 메시지를 수신한 컴퓨팅 리소스가 상품 재고를 증가시킵니다.

## 작업
- 요구사항 분석을 통한 초기 다이어그램
![image](https://github.com/qnddjKJH/project3-terraform/assets/53363080/1dfe2d2d-4c55-4f96-9a2c-944a668625fe)
이후 필요한 API(Sales, stock-increase, stock)들은 Serverless Framework 를 통해 Lambda 를 생성하였다.

- ***Serverless Framework***
  - Serverless Framework 는 AWS Cloudformation 을 관리 배포하는 기술 서버리스 프레임워크를 사용하여 API, 예약된 작업, 워크플로 및 이벤트 기반 앱을 AWS Lambda에 쉽게 배포가 가능하다.
  - Lambda 의 경우 AWS Resource 중에서도 구축하기 쉬운편에 속하는데 Serverless Framework 와 만나면서 엄청나게 편해진다. 다만, Policy 의 경우는 추가적으로 작업을 해 둬야 한다.

### Trouble shooting
Serverless 프레임워크에서 AWS 의 다양한 Resource 의 ARN 또는 사용자 이름과 비밀번호를 사용하게 되는데, 이러한 민감 데이터를 보이지 않도록 작업하였다.

Serverless 는 환경변수를 통해 조작이 가능한데 Node 환경에서 환경변수를 설정하는 것과 비슷했다. process.env 를 파일로 컨트롤 하기위한 npm 인 dotenv 패키지 처럼 serverless 에서도 .env 파일로 환경변수를 조작하는 패키지를 찾을 수 있었다.

```yaml
npm install -D serverless-dotenv-plugin
```

패키지를 다운 받고 

Serverless.yml 에 다음을 작성하여 활성화 한다.

```yaml
service: sales-api
frameworkVersion: '3'

plugins:
  - serverless-dotenv-plugin

useDotenv: true
...
```

사용은 다음과 같다

```yaml
functions:
  api:
    handler: handler.handler
    events:
      - httpApi: '*'
    environment:
      HOSTNAME: ${env:HOSTNAME}
      USERNAME: ${env:USERNAME}
      PASSWORD: ${env:PASSWORD}
      DATABASE: ${env:DATABASE}
      TOPIC_ARN: ${env:TOPIC_ARN}
```

### Serverless-ignore

Serverless 로 배포를 하게 되면 프로젝트 루트 경로부터 모든 파일이 업로드된다.

이때 .env 같은 민감 정보를 포함한 파일은 업로드 하지 않는게 좋다. 우리는 .gitignore 를 알고 있으며 똑같은 기능을 하는 .slsignore 파일이 필요하다.

.slsignore 파일로 업로드 하지 않을 파일을 제외할려면 우선 플러그인이 필요하다.

```yaml
npm install -D serverless-ignore
```

마찬가지로 serverless.yml 에 설정해준다.

```yaml
service: sales-api
frameworkVersion: '3'

plugins:
  - serverless-dotenv-plugin
  - serverless-ignore
```

이제 .slsignore 에 제외할 파일을 작성해주면 된다.

### Lambda 기본 권한정책

문제가 있었는데 Lambda 의 실행 로그를 볼 수 있는 로그 스트림이 CloudWatch 를 통해 볼 수가 없었다. 로그 스트림이 생성조차 되지 않아 잘 동작하는지 알 수가 없었던 것

Serverless 를 통해 lambda 를 만들때 SQS 의 메세지를 끌고와 작업을 하는 Lambda 였는데 실제 SQS 에서 메세지는 잘 없어지나 로그가 없어 당황하고 있었다.

동작은 잘 되고 있으나 로그 스트림이 생성안되는 문제는 Serverless.yml 에서 Lambda 에 설정한 역할에 권한이 없었던것

Lambda 에서 로그를 생성하는 권한은 기본 정책으로 이미 만들어져 있다.

`AWSLambdaBasicExecutionRole` 다음 권한을 사용하는 IAM 역할에 추가 후 정상적으로 동작하였다.

SQS 작업한다고 역할에 SQS 관련 권한만 넣었던 것이 화근이 되었다.
최종 완성된 다이어그램 하단 Ads Stop Send Lambda 의 경우에는 SQS 는 자체적으로 Consume 되어 SES 에 보내진다고 다이어그램을 짰었으나 SQS 는 자체적으로 Consume 이 되지 않는 점을 알게되어 Lambda 를 더해 주어 최종 완성 하였다.

또한 RDS 에서 트리거 되어 Ads Stop Lambda 로 이벤트가 발생하도록 짜였는데 RDS 에서는 트리거를 발생하지 못하기 때문에 큰 어려움이 없다면 트리거 지원이 되는 DynamoDB 를 생각해 볼 수 있다.

## 마무리
최종 완성된 다이어그램 하단 Ads Stop Send Lambda 의 경우에는 SQS 는 자체적으로 Consume 되어 SES 에 보내진다고 다이어그램을 짰었으나 SQS 는 자체적으로 Consume 이 되지 않는 점을 알게되어 Lambda 를 더해 주어 최종 완성 하였다.

또한 RDS 에서 트리거 되지 않을까 해서 Ads Stop Lambda 로 이벤트가 발생하도록 설계하였는데 알고보니 RDS 에서는 트리거를 발생하지 못하기 때문에 큰 어려움이 없다면 트리거 지원이 되는 DynamoDB 를 생각해 볼 수 있다. 아니면 RDS 를 계속 바라보는 Lambda 를 추가해주는 것도 하나의 방법이라고 생각한다.
