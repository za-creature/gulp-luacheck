{PluginError} = require "gulp-util"
path = require "path"
through = require "through2"


PLUGIN_NAME = "gulp-luacheck"


module.exports = (options) ->
    files = []
    through.obj(
        (file, encoding, next) ->
            if file.luacheck and file.luacheck.length
                files.push(path.relative(file.base or ".", file.path))
            next(null, file)
        ,
        (next) ->
            if not files.length
                return next()

            next(new PluginError(PLUGIN_NAME,
                "Luacheck failed for: " + files.join(", ")))
    )
