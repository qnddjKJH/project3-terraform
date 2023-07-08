## 목표
- 메시지 큐의 Pub/Sub 패턴과 Producer/Consumer 패턴의 차이를 이해한다
- DB와 서버와의 통신이 가능하도록 연결한다
- 특정 상황에서 SNS, SQS로 메세지가 전달되도록 시스템을 구성한다
- SQS에 들어온 메세지를 레거시 시스템(Factory API)으로 전달하는 시스템을 구성한다
- 레거시 시스템(Factory API)의 콜백 대상이되는 리소스를 생성해 데이터베이스에 접근 할 수 있게 한다

## Step 1 : Lambda 서버(Sales API) - DB 연결

![step1](https://contents-img-jeonghun.s3.ap-northeast-2.amazonaws.com/project3/project3-project-step1.png)

> **✅ 확인 포인트: 요청시 재고 감소 로그 / 재고 0 도달 → 재고없음 로그**

## Step 2 : “재고없음” 메세지 전달 시스템 구성
![step2](https://contents-img-jeonghun.s3.ap-northeast-2.amazonaws.com/project3/project3-project-step2.png)

> **✅ 확인 포인트 : 재고가 없는 경우 stock_queue에 메세지가 들어온 것을 확인**

## Step 3 : 메세지를 레거시 시스템(Factory API)로 보내줄 Lambda 구성 및 DLQ 추가
![step3](https://contents-img-jeonghun.s3.ap-northeast-2.amazonaws.com/project3/project3-project-step3.png)

> **✅ 확인 포인트 : stock_queue에서 메세지 사라짐, stock_lambda에서 생성된 로그 확인**

## Step 4 : 데이터베이스의 재고를 증가시키는 Lambda 함수 생성

> **✅ 확인 포인트 : 재고 없음 메세지 전송 → 일정 시간 이후 다시 요청시 재고감소 작동**
