# simplebar

[Sri Kadimisetty](http://sri.io)


A simple non-attention-seeking Vim status line.


(Relies on Unicode support, which it being 2013 and all, your computer has
anyway. But do keep that in mind.)


Setup: iTerm w/ Solarized + Vim w/ solarized + simplebar 


## Screenshots
Solarized Theme
![Dark Background Screenshot](https://raw.github.com/kadimisetty/vim-simplebar/master/docs/source/dark2.png)

Background set to light
![Light Background Screenshot](https://raw.github.com/kadimisetty/vim-simplebar/master/docs/source/light2.png)
The encoding is struck through because it hasn't been set here.

## Elements
To the left
* Filename 
* Buffer #
* filetype.encoding.format

To the right
* Line Count & Position %
* Columns & Row 
* Coloured Mode


##Requirements
Work on Vim 7.3, iTerm & OS X Mountain Lion


## Installation
Use your favorite installation method. I suggest Vundle or Pathogen.

To do it manually, place `./plugin/simplebar.vim` in your `~/.vim/plugins` directory.


## Notes
Alternatives & Inspiration:
* Vim Poweline
* NeatStatus etc.


## License
GNU LESSER GENERAL PUBLIC LICENSE
Version 3, 29 June 2007
