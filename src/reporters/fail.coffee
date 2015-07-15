through = require "through2"
{PluginError} = require "gulp-util"


PLUGIN_NAME = "gulp-luacheck"


module.exports = (options) ->
    count = files = 0
    through.obj(
        (file, encoding, next) ->
            if file.luacheck and file.luacheck.length
                count += file.luacheck.length
                files++
            next(null, file)
        ,
        (next) ->
            if not count
                return next()

            next(new PluginError(
                PLUGIN_NAME,
                "Luacheck failed: found #{count} warnings in #{files} files")
            )
    )
