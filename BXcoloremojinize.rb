#!/bin/sh
exec ruby -x "$0" "$@"
#!ruby
# coding: utf-8

#
# latex-emojinize.rb
# Copyright 2022 (c) Koichi OKADA. All rights reserved.
# This script is distributed under the MIT license.
#

require 'unicode/blocks'

if ARGF.file == STDIN && !File.pipe?(STDIN)
  puts "Usage: ${File.basename $0} [<file.tex>]"
  puts "    Use bxcoloremoji for Miscellaneous Symbols"
  exit
end

# Replace "Miscellaneous Symbols" to \coloremoji{x}
hasemoji = false
s = ""
ARGF.read.chars.each{|c|
  if Unicode::Blocks.blocks(c)[0] =~ /Miscellaneous Symbols/
    s += '\coloremoji{%c}' % c.ord
    hasemoji = true
  else
    s += c
  end
}

# Insert bxcoloremoji style
s = s.split("\n").map{|line|
  line += "\n\\usepackage[dvipdfmx]{graphicx}\n\\usepackage{bxcoloremoji}" if line =~ /^\\documentclass/
  line
} if hasemoji

puts s
