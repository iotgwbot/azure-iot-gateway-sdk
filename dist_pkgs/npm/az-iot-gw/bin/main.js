#!/usr/bin/env node

'use strict'

function gw_init() {
  var gw = null;
    if (process.platform === 'win32') {
    gw = require('az-iot-gw-win');
  } else if (process.platform === 'linux') {
    gw = require('az-iot-gw-lin');
  }

  return gw;
}

(function() {
  var gw_inst = gw_init();
  gw_inst.run();
})();