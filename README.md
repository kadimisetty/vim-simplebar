# simplebar

[Sri Kadimisetty](http://sri.io)


A simple non-attention-seeking Vim status line.


(Relies on fonts with unicode support, which it
being 2013 and all, most good fonts computer have
anyway. But do keep that in mind.)


Setup: iTerm w/ Solarized + Vim w/ solarized +
simplebar


## Screenshots
Solarized Theme
![Dark Background Screenshot](https://raw.github.com/kadimisetty/vim-simplebar/master/doc/source/dark3.png)

With a light background
![Light Background Screenshot](https://raw.github.com/kadimisetty/vim-simplebar/master/doc/source/light3.png)


## Elements
To the left
* Filename 
* git branch
* filetype.encoding.format
* Buffer #

To the right
* Line Count & Position %
* Columns & Row 
* Mode


##Requirements
Tested on Vim 7.3, iTerm & OS X Mountain Lion


## Installation
Use your favorite installation method. I suggest
Vundle or Pathogen.

To do it manually, place `./plugin/simplebar.vim`
in your `~/.vim/plugins` directory.


## Notes
Alternatives & Inspiration:
* Powerline
* NeatStatus etc.


## License
The MIT License (MIT)

Copyright (c) 2013 Sri Kadimisetty

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
