const express = require('express');
const app = express();
const os = require('os');
const myosname = os.platform();
const myosrelease = os.release();
const myostype = os.type();
const myhttp = require('http');

const mywebserver = myhttp.createServer((req, res) => {
    if(req.url === '/'){
        res.writeHead(200,'OK',{'Content-Type': 'text/html'});
        res.write('<html>');
        res.write('<head>');
        res.write('</head>');
        res.write('<body>');
        res.write('<br> </br>');
        res.write('<h2>F5 Training Application Home Page</h2>');
        res.write('<br> </br>');
        res.write('<h3>Platform:</h3');
        res.write('<br> </br>');
        res.write(`${myosname}`);
        res.write('<br> </br>');
        res.write(`${myosrelease}`);
        res.write('<br> </br>');
        res.write(`${myostype}`);
        res.write('</body>');
        res.write('</html>');
        res.end();
    } else if(req.url === '/about'){
        res.writeHead(200,'OK',{'Content-Type': 'text/html'});
        res.write('<html>');
        res.write('<h3>About Page</h3');
        res.write('</html>');
        res.end();
    } else {
        res.writeHead(200,'OK',{'Content-Type': 'text/html'});
        res.write('<html>');
        res.write('<h3>Resource not found</h3');
        res.write('</html>');
        res.end();
    }
})

mywebserver.listen(3000, () => {
        console.log('F5 Training Application listening on port 3000');
})
