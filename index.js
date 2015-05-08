'use strict';

var gutil       = require('gulp-util');
var path        = require('path');
var PluginError = require('gulp-util/lib/PluginError');
var through     = require('through2');

var PLUGIN_NAME = 'gulp-luacheck';

function logRed(msg) {

    gutil.log(gutil.colors.red(msg));

}

function logYellow(msg) {

    gutil.log(gutil.colors.yellow(msg));

}

function isResultOk(msg) {

    msg = msg.replace("\r", '');
    var len = msg.length;
    return msg.substring(len - 2).toLowerCase() === "ok";

}

function isResultFailure(msg) {

    msg = msg.replace("\r", '');
    var len = msg.length;
    return msg.substring(len - 7).toLowerCase() === "failure";

}

function isResultSyntaxError(msg) {

    msg = msg.replace("\r", '');
    var len = msg.length;
    return msg.substring(len - 12).toLowerCase() === "syntax error";

}


function processLines(lines, filePath) {

    var errLines = [];

    lines.forEach(function(line, index, arr) {

        if (line.indexOf(filePath) > -1) {

            errLines.push(
                line.replace("\r", '')
                    .replace(filePath, path.basename(filePath)));

        }

    });

    return errLines;
}

function check(file, opts, callback) {

    var exec = require('child_process').exec;
    var runs = 0;

    var filePath = file.path;

    var cmd = 'luacheck ';

    if (opts.noConfig === true) {

        cmd += '--no-config ';

    } else if (opts.config !== '') {

        cmd += '--config ' + opts.config + ' ';

    }

    cmd += filePath;

    exec('luacheck --help', function(err, stdout, stderr) {

        if (err) {
            logRed("[gulp-luacheck] YOU MUST INSTALL luacheck TO RUN THIS PLUGIN. See 'https://github.com/mpeterv/luacheck' for installation instructions.")
            callback(null);
            return;
        }

        exec(cmd, function(err, stdout, stderr) {

            // Grab the first line of stdout which ends
            // in either "OK" if everything is clean or
            // "Failure" if something is amiss.
            var lines = stdout.split("\n");
            var msg = lines[0];
            lines.shift();

            // Not okay and an error we know how to deal with
            if (!isResultOk(msg) && (isResultFailure(msg) || isResultSyntaxError(msg))) {

                logRed('[gulp-luacheck] Issue in "' + filePath + '"');

                var errLines = processLines(lines, filePath);

                errLines.forEach(function(line, index, arr) {

                    logYellow('  ' + line);

                });

                err = null;
            }

            // Something else went sideways
            if (err) {
                return callback(new PluginError(PLUGIN_NAME, err.message,
                {
                    fileName: filePath,
                    lineNumber: 0,
                    stack: err.stack
                }));
            }

            callback(null);

        });

    });


}

module.exports = function(opts) {

    opts = opts || {};
    opts.config = opts.config || '';
    opts.noConfig = opts.noConfig || false;

    function luacheck(file, encoding, callback) {

        if (file.isNull()) {
            return callback(null, file);
        }

        if (file.isStream()) {
            return callback(new PluginError(PLUGIN_NAME, 'Streaming is not supported',
            {
                fileName: file.path,
                showStack: false
            }));
        }

        check(file, opts, function(err) {

            if (err) {
                return callback(err);
            }

            callback(null, file);

        });

    }

    return through.obj(luacheck);

};
