const serverless = require("serverless-http");
const express = require("express");
const {v4: uuidv4} = require("uuid")
const app = express();
app.use(express.json())

const AWS = require("aws-sdk") // STEP 2
const sns = new AWS.SNS({ region: "ap-northeast-2" }) // STEP 2

const {
  connectDb,
  queries: { getProduct, setStock }
} = require('./database')

app.get("/product/donut", connectDb, async (req, res, next) => {
  const [ result ] = await req.conn.query(
    getProduct('CP-502101')
  )

  await req.conn.end()
  if (result.length > 0) {
    return res.status(200).json(result[0]);
  } else {
    return res.status(400).json({ message: "상품 없음" });
  }
});

app.post("/checkout", connectDb, async (req, res, next) => {
  const [ result ] = await req.conn.query(
    getProduct('CP-502101')
  )
  if (result.length > 0) {
    const product = result[0]
    if (product.stock > 0) {
      await req.conn.query(setStock(product.product_id, product.stock - 1))
      return res.status(200).json({ message: `구매 완료! 남은 재고: ${product.stock - 1}`});
    }
    else {
      await req.conn.end()

      const now = new Date().toString()
      const message = `도너츠 재고가 없습니다. 제품을 생산해주세요! \n메시지 작성 시각: ${now}`
      const params = {
        Message: message,
        Subject: '도너츠 재고 부족',
        MessageAttributes: {
          MessageAttributeProductId: {
            StringValue: product.product_id,
            DataType: "String",
          },
          MessageAttributeFactoryId: {
            // StringValue: req.body.MessageAttributeFactoryId,
            StringValue: product.factory_id,
            DataType: "String",
          },
        },
        TopicArn: process.env.TOPIC_ARN,
        // MessageGroupId: uuidv4(),
      }
      console.log(params)
      const result = await sns.publish(params).promise()
      console.log(result)

      return res.status(200).json({ message: `구매 실패! 남은 재고: ${product.stock}`});
    }
  } else {
    await req.conn.end()
    return res.status(400).json({ message: "상품 없음" });
  }
});

app.use((req, res, next) => {
  return res.status(404).json({
    error: "Not Found",
  });
});

module.exports.handler = serverless(app);
module.exports.app = app;
