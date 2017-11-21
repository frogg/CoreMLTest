var express = require('express')
var model = require('./models')

var router = express.Router()

var app = express()

router.post('/session', async (req, res) => {
    let aaa = await model.Session.create(req.body);
})


app.use(router)

app.listen(3000, () => {
    console.log("EZY")
})