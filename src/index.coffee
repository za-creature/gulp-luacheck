reporters = require "./reporters"

{PluginError} = require "gulp-util"
luacheck = require "luacheck"
through = require "through2"


PLUGIN_NAME = "gulp-luacheck"


module.exports = (options) ->
    through.obj (file, encoding, next) ->
        if file.isNull()
            return next(null, file)

        if file.isStream()
            return next(new PluginError(PLUGIN_NAME, "Streaming not supported",
                                        "fileName": file.path))

        try
            file.luacheck = luacheck(file.path, options)
            next(null, file)
        catch err
            next(new PluginError(PLUGIN_NAME, err, "fileName": file.path))


module.exports.reporter = (name="default", options) ->
    if typeof reporters[name] isnt "undefined"
        # bundled
        ctor = reporters[name]
    else
        # third party
        ctor = require("luacheck-#{name}")

    ctor(options)
