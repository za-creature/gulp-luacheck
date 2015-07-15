# exports all importable sub-modules under a key equal to their file name
# modulo the extension
fs = require "fs"
path = require "path"

for filename in fs.readdirSync(__dirname)
    stat = fs.statSync(path.join(__dirname, filename))

    if stat.isDirectory()
        # assume folders are always importable
        module.exports[file] = require("./#{filename}")
    else
        # subfile; only load .coffee, .js and .es6 files to avoid
        # non-importable files like .gitkeep, coffeelint.json, etc.
        [file, extension] = filename.split(".", 2)
        if file isnt "index" and extension in ["coffee", "js", "es6"]
            module.exports[file] = require("./#{file}")
