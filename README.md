Vim integration of [fixjson][]
==============================

This is a Vim plugin for [fixjson][]. fixjson is a JSON fixer/formatter using
[(relaxed) JSON5](https://github.com/rhysd/json5).

This plugin automatically fixes a JSON file asynchronously on saving the file while editing.

- Pretty-printing JSON5 input
  - ES5 syntax is available to write up
- Fixes various failures while humans writing JSON
  - Fixes trailing commas objects or arrays
  - Fixes missing commas for elements of objects or arrays
  - Adds quotes to keys in objects
  - Newlines in strings
  - Hex numbers
  - Fixes single quotes to double quotes
- Fixing/Formatting is done asynchronously. So it does not block user input (e.g. moving cursor)

## Screenshots

When moving a line to another line, you no longer need to care about a trailing comma:

![modify keys](https://github.com/rhysd/ss/raw/master/fixjson/modifykeys.gif)

And you also don't need to care about a trailing comma of previous line when adding a new element
to an object or an array:

![add key](https://github.com/rhysd/ss/raw/master/fixjson/addkey.gif)

When adding a new key-value to an object, quotes of the key are fixed. And single quotes for strings
are also fixed to double quotes:

![key quotes](https://github.com/rhysd/ss/raw/master/fixjson/keyquotes.gif)

JSON string does not allow multi-line string. `\n` is required to embed multi-line string to JSON.
fixjson automatically fixes newlines in strings. This is useful when copy&paste some string to JSON
file:

![newlines in string](https://github.com/rhysd/ss/raw/master/fixjson/newlines.gif)

JSON only accepts decimal digits for numbers. fixjson automatically converts `0x` hex numbers to
decimal numbers. You no longer need to convert hex numbers manually:

![hex numbebr](https://github.com/rhysd/ss/raw/master/fixjson/number.gif)

And of course it pretty-prints the JSON code, with automatic indent detection:

![pretty printing](https://github.com/rhysd/ss/raw/master/fixjson/prettyprint.gif)

## Installation

Please use your favorite plugin manager or Vim standard `:packopt` to install.

For example (neobundle.vim):

```vim
call neobundle#add('rhysd/vim-fixjson', {
            \ 'lazy' : 1,
            \ 'autoload' : {
            \     'filetypes' : 'json'
            \   }
            \ })
```

If [fixjson](https://www.npmjs.com/package/fixjson) is not installed globally, vim-fixjson installs
it locally to `/path/to/vim-fixjson/node_modules` using npm pacakge manager. So you don't need to
install fixjson command manually.

## Usage

Auto-fix on saving a JSON file is enabled by default. And you can also run a `fixjson` formatter by
`:FixJson` command.

If you want to update local `fixjson` command, run `:FixJsonUpdateLocalCommand`.

Asynchronous formatting is implemented with [Vital.Async.Promise][] and [Vital.System.Job][].
It requires modern Vim or Neovim (Vim 8.0.27+ or Neovim 0.2.0+). If the requirements are not met,
it falls back to synchronous formatting.

If you want to format JSON only manually with `:FixJson`, please set `g:fixjson_fix_on_save` to `0`.

## License

```
Copyright (c) 2018 rhysd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

[fixjson]: https://github.com/rhysd/fixjson
[Vital.Async.Promise]: https://github.com/vim-jp/vital.vim/blob/master/autoload/vital/__vital__/Async/Promise.vim
[Vital.System.Job]: https://github.com/lambdalisue/vital-System-Job
