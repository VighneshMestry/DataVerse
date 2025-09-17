// "C:/Users/Vighnesh/Flutter/Projects/ml_project/assets/demo.pdf"
// IMPORTS FROM PACKAGES
const express = require("express");
const cors = require("cors");
// const bodyParser = require('body-parser');
const { spawn } = require("child_process");

// IMPORTS FROM OTHER FILES
const router = require("../routes");

//INIT
//If we initialize this express (which we did) then we also have to listen it
const app = express();
const PORT = process.env.PORT || 4000;

//middleware
// CLIENT -> middleware -> SERVER -> CLIENT
app.use(cors({
  origin: [
    "http://localhost:57253",              // for local dev
  ],
  methods: ["GET", "POST", "PUT", "DELETE"],
  allowedHeaders: ["Content-Type", "Authorization"]
}));
app.use(express.json());
app.use(router);
// app.use(bodyParser.json());
// app.use(authRouter);

// API's have following requests
// GET, PUT, POST, DELETE, UPDATE -> CRUD
// This app.listen binds itself to the host specified and listen for any other connections
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected server at ${PORT}`);
});

//CREATING AN API
// http://<youripaddress>/hello-world

// app.get("/hello-world", (req, res) => {
//   res.json({hi : "Hello World"});
// });

app.post("/demo", async (req, res) => {
  try {
    // const link = "C:/Users/Vighnesh/Flutter/Projects/ml_project/assets/demo.pdf"
    // if (!req.body || !req.body.link) {
    //   return res.status(400).json({ error: 'Missing or invalid link property in request body' });
    // }
    console.log("Happening");
    const { link } = req.body;
    // const pdfFile = req.files.pdf_file;
    // const filePath = `${__dirname}/uploads/${pdfFile.name}`;
    // await pdfFile.mv(link);

    console.log("link " + link);
    console.log("documentPath");

    let visited = false;

    const childPython = spawn("python3", ["scripts/pdf_text_extraction.py", link]);

    let responseData;

    childPython.stdout.on("data", (data) => {
      if (!visited) {
        visited = true
        console.log("Still not running");
        // console.log(`The data in index.js ${data}`)
        responseData = data;
      }
    });

    childPython.stderr.on("data", (data) => {
      console.log(`error ${data}`);
    });

    childPython.on("close", (code) => {
      console.log(`child process exited with code ${code}`);
      res.json({ msg: responseData });
    });
    // res.json({msg: resultText})
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});