var express = require('express')
var bodyParser = require('body-parser')

var router = express.Router()

const connectionString = process.env.DATABASE_URL || 'postgres://localhost:5432/gazeanalysisdb';

const { Client } = require('pg')
const client = new Client({
    user: 'gaze',
    host: 'localhost',
    database: 'gazeanalysisdb',
    password: 'password',
    port: 5432,
  })
async function test() {
    try {
        await client.connect()
        const res = await client.query(`INSERT INTO gazedb.sessions
(id, "phoneModel", "isAnalysisComplete")
        VALUES(nextval('gazedb."Session_id_seq"'::regclass), '', false);
        `)
        console.log(res) /// Hello world!
        await client.end()
    }
    catch(e){
        console.log(e)
    }
   
}


test()


var app = express()

router.post('/session', async (req, res) => {
    try{
        // let result = await model.Session.create(req.body);
        // res.json(result)
    }
    catch(e){
        res.json(e).status
    }
    
})

app.use(bodyParser.json())
app.use(router)



router.post('')



app.listen(3000, () => {
    console.log("EZY")
})