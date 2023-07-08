const { app } = require('./handler');
app.listen(8081, () => {
  console.log('stock-increase-lambda api is running on local machine, 8081 port')
})