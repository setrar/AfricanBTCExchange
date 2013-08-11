#!/usr/bin/env node
// Example of using market-research.js as a module
var OANDA = require('./oanda'); 
//OANDA.rate.quote(['EUR_USD'], function(response) {
    //var bid = response.prices[0].bid;
    //var ask = response.prices[0].ask;
    //// Do something with prices
    // ...
//});
OANDA.rate;
console.log(OANDA.rate);

