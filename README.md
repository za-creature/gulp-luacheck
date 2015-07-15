# gulp-luacheck

A [Gulp](http://gulpjs.com/) plugin for [luacheck](
https://github.com/mpeterv/luacheck).

## Dependencies

You must have [luacheck](https://github.com/mpeterv/luacheck) installed and in
your `PATH`.

## Installation

```bash
npm install gulp-luacheck
```

## Usage

```javascript
var gulp = require("gulp");
var luacheck = require("luacheck");
var options = {};


gulp.task("lint", function() {
    return gulp
        .src("**/*.lua")
        .pipe(luacheck(options))
        .pipe(luacheck.reporter())
});
```

For a list of options, see [node-luacheck](
https://github.com/za-creature/node-luacheck)

## Reporters

A [jshint-stylish](https://github.com/sindresorhus/jshint-stylish)-like
reporter is also bundled:


```javascript
    gulp.src("**/*.lua")
        .pipe(luacheck())
        .pipe(luacheck.reporter("stylish"))
});
```

By default errors are not fatal (so as to not break the stream when using
`gulp.watch`). If you want gulp to crash when there's a linting error (for
example if you're using `gulp` as part of CI), you'll want to use the `fail`
reporter (also bundled):

```javascript
    gulp.src("**/*.lua")
        .pipe(luacheck())
        .pipe(luacheck.reporter())
        .pipe(luacheck.reporter("fail"))
});
```

## License

gulp-luacheck is licensed under the MIT license.
