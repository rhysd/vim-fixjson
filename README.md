Vim integration of [fixjson][]
==============================

This is a plugin for [fixjson][]. fixjson is a JSON fixer using (relaxed) JSON5.

This plugin automatically fixes JSON file on saving the file while editing.

- Pretty-prints JSON input
- Fixes varios failures while humans writing JSON
  - Fixes trailing commas objects or arrays
  - Fixes missing commas of elements of objects or arrays
  - Adds quotes to keys in objects
  - Newlines in strings
  - Hex numbers
  - Fixes single quotes to double quotes

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

## Usage

Auto fix on saving a JSON file is enabled by default. And you can also run a `fixjson` formatter by
`:FixJson` command.

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
