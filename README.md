# Merge_Cambridge_books
A script for merging the splitted pdf files of Cambridge E-book in Mac OS.

When you download some academic e-books from the [Cambridge Core website](https://www.cambridge.org/core/). The website only provides the archived zip which contains the splitted pdf of every chapter and no cover image. Boring!

This script help you create a single pdf file with cover.

## Requirement: 
Automator (need in Mac OS), img2pdf (pip install with python)

## Usage:
* Please save the cover image with the same name as zip file from the cambridge website or somewhere else, and convert other format e.g, to jpg first.
* Put all the cover image(jpg/gif/png), zip and this script in the same folder. The name of image file must be the same as the archieve except the filename extension. The name is supposed to be like cambridge_core_book_name_dd_mm_yyyy.
* In the terminal, just `source ./merge_cambridge.sh`

## Issue:
Not work in linux, will be a updated version later.
