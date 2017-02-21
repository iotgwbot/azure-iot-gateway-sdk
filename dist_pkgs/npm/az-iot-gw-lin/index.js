'use strict'

var fs = require('fs');
var path = require('path');
var spawn = require('child_process').spawn;

exports.run = function() {
  var exe_file_path = null;
  var exe_args = [];

  if (process.platform !== 'linux') {
    return console.error('az-iot-gw-win can only run on linux.');
  }

  exe_file_path = path.resolve(__dirname, './bin/gw');

  if (process.argv.length >= 3) {
    var exe_config_path = process.argv[2];
    exe_args.push(exe_config_path);
  }

  const options = { 
    stdio: 'inherit'
  };

  var child = spawn(exe_file_path, exe_args, options);

  child.on('close', (code) => {
    if (code) {
      console.error('Gateway child process exited with code = ' + code);
    }
  });
};