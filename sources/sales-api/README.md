<!--
title: 'Serverless Framework Node Express API on AWS'
description: 'This template demonstrates how to develop and deploy a simple Node Express API running on AWS Lambda using the traditional Serverless Framework.'
layout: Doc
framework: v3
platform: AWS
language: nodeJS
priority: 1
authorLink: 'https://github.com/serverless'
authorName: 'Serverless, inc.'
authorAvatar: 'https://avatars1.githubusercontent.com/u/13742415?s=200&v=4'
-->

# Getting Started

## Integration

### 데이터베이스 연결 (STEP 1)

- 로컬 테스트 환경
    - `.env` 파일을 이용해서 데이터베이스 연결을 설정합니다. 데이터베이스 연결과 관련된 코드는 `database.js` 에서 찾을 수 있습니다.

- 배포 환경
    - AWS 람다 콘솔에서 환경 변수를 직접 입력합니다.

### 메시징 시스템 (STEP 2)

재고 부족 메시지를 전달하기 위해 메시징 시스템인 SNS를 사용할 수 있습니다. 환경 설정에 `TOPIC_ARN`을 추가하면, SNS를 통해 subscriber에게 메시지가 전달됩니다.

## 사용 가능한 명령

### 로컬 실행
```
npm start
```

### 배포
```
serverless deploy
```

# Serverless Framework Node Express API on AWS

This template demonstrates how to develop and deploy a simple Node Express API service running on AWS Lambda using the traditional Serverless Framework.

## Anatomy of the template

This template configures a single function, `api`, which is responsible for handling all incoming requests thanks to the `httpApi` event. To learn more about `httpApi` event configuration options, please refer to [httpApi event docs](https://www.serverless.com/framework/docs/providers/aws/events/http-api/). As the event is configured in a way to accept all incoming requests, `express` framework is responsible for routing and handling requests internally. Implementation takes advantage of `serverless-http` package, which allows you to wrap existing `express` applications. To learn more about `serverless-http`, please refer to corresponding [GitHub repository](https://github.com/dougmoscrop/serverless-http).
