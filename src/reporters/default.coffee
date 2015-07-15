through = require "through2"
path = require "path"


module.exports = (options) ->
    through.obj (file, encoding, next) ->
        if file.luacheck and file.luacheck.length
            for error in file.luacheck
                rel = path.relative(file.base or ".", file.path)
                console.log("#{rel}:
                             line #{error.line},
                             col #{error.character},
                             #{error.reason}")

        next(null, file)
