#!/usr/bin/env node

var express = require('express'),
         fs = require('fs');

var app = express.createServer(express.logger());

app.get('/', function(request, response) {
    var data;
    try {
        data = fs.readFileSync('index.html');
        response.send(data.toString());
    } catch (e) {
      if (e.code === 'ENOENT') {
        response.send('No such file!');
      }
    }
});

var port = process.env.PORT || 5000;
app.listen(port, function() {
  console.log("Listening on " + port);
});
