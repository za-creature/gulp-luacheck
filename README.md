# gulp-luacheck

A [Gulp](http://gulpjs.com/) plugin for [luacheck](https://github.com/mpeterv/luacheck).

## Dependencies

You must have [luacheck](https://github.com/mpeterv/luacheck) installed and in your `PATH`.

## Installation

### Manual

Clone this repo and drop it in the `node_modules/` folder for your project.

## Options

### luacheck(options)

#### options.config

Type: `String`
Default: `''`

Path to the luacheck [config file](http://luacheck.readthedocs.org/config.html).

#### options.noConfig

Type: `Boolean`
Default: `false`

Flag indicating whether config loading should be disabled or not. Pass in `true` to disable config loading.

## License

gulp-luacheck is licensed under the MIT license.
