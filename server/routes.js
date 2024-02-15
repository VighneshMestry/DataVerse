const express = require("express");
const router = express.Router();
const {spawn} = require('child_process');

// router.post("/demo", async (req, res) => {
//   try {
//       const link = "C:/Users/Vighnesh/Flutter/Projects/ml_project/assets/demo.pdf"
//       // if (!req.body || !req.body.link) {
//       //   return res.status(400).json({ error: 'Missing or invalid link property in request body' });
//       // }
//       console.log(req.body);
//       const { uLink } = req.body
//       console.log(uLink)
      
//       // const data = req.body;
//       // const att = data.link;
//       const childPython = spawn('python', ['pdf_text_extraction.py', link]);
//       childPython.stdout.on('data', (data) => {
//           // console.log(`${data}`)
//           res.json({msg: data})
//       });
      
//       childPython.stderr.on('data', (data) => {
//           console.log(`error ${data}`)
//       });
      
//       childPython.on('close', (code) => {
//           console.log(`child ptocess exited with code ${code}`);
//       });
//       // res.json({msg: resultText})
      
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

  router.get("/request", (req, res) => {
    res.json({hi : "Done"});
  });

  router.post('/api/data', (req, res) => {
    try {
        // Access data from the request body
        const { name, age, email } = req.body;
  
        // Perform any processing with the data
        // For example, log the received data
        console.log('Received data:');
        console.log('Name:', name);
        console.log('Age:', age);
        console.log('Email:', email);
  
        // Send a response indicating success
        res.status(200).json({ message: 'Data received successfully' });
    } catch (error) {
        // Handle errors
        console.error('Error:', error.message);
        res.status(500).json({ error: 'An error occurred' });
    }
  });

  module.exports = router;