const AWS = require('aws-sdk');
const axios = require('axios').default

module.exports.handler = async (event) => {
  try {
    const sqs = new AWS.SQS();
    
    for (const record of event.Records) {
      console.log('record: ', record)
      
      const message = JSON.parse(record.body);
      const messageAttributes = message.MessageAttributes

      const messageId = record.attributes.MessageGroupId
      const messageAttProductId = messageAttributes.MessageAttributeProductId.Value
      const messageAttFactoryId = messageAttributes.MessageAttributeFactoryId.Value

      const payload = {
        MessageGroupId : messageId,
        MessageAttributeProductId : messageAttProductId,
        MessageAttributeProductCnt : 1,
        MessageAttributeFactoryId : messageAttFactoryId,
        MessageAttributeRequester : `김종훈`,
        CallbackUrl : `${process.env.CALLBACK_URL}/product/donut`
      }

      console.log('Create Payload: ', payload)
      
      await axios.post('http://project3-factory.coz-devops.click/api/manufactures', payload)
        .then(function (response) {
          console.log('Factory API Response: ', response)
        })
        .catch(function (error) {
          console.log(error)
        })
    }
    
    return {
      statusCode: 200,
      body: 'Messages processed successfully'
    };
  } catch (error) {
    console.error('Error processing messages:', error);
    return {
      statusCode: 500,
      body: 'Error processing messages'
    };
  }
};
