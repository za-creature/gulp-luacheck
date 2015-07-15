chalk = require "chalk"
path = require "path"
table = require "text-table"
through = require "through2"


module.exports = (options) ->
    count = 0
    through.obj(
        (file, encoding, next) ->
            if file.luacheck and file.luacheck.length
                count += file.luacheck.length
                console.log()
                console.log(path.relative(file.base or ".", file.path))
                console.log(table(([
                   chalk.gray("  line #{error.line}")
                   chalk.gray("col #{error.character}")
                   chalk.blue("#{error.reason}.")
                ] for error in file.luacheck)))

            next(null, file)
        ,
        (next) ->
            if count
                console.log()
                end = if count > 1 then "s" else ""
                console.log("  #{chalk.yellow("‼")}  #{count} error#{end}")
                console.log()
            next()
    )
