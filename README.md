# cisco-router-mode for EMACS
Major mode for editing network device configuration files.

I'm going to see if I can create color coding for router/switch configuraiton files as I'm learning to use EMACS.

# 10/25/25 - I just updated to emacs 30 and this doesn't seem to work correctly.

# 01/18/26 - Ran the code through Perplexity AI with the prompt, "update for EMACS 30", it came back with the below and following recommendations: "For Emacs 30, the main things to update are: use define-derived-mode, make the faces real defface symbols, and set font-lock-defaults with setq-local (or as a defvar-local). The regexps and faces themselves still work." Looking to see what the differences are and understand them.

# My Goals
 - learn more about using EMACS and eLISP
 - Router, Switch and Firewall configuration highlighting (multi-vendor)

I've used previous work by *Noufal Ibrahim* and his [cisco-router-mode](https://www.emacswiki.org/emacs/cisco-router-mode.el) as a starting point and mainly updated some regex for color highlighting for modern interfaces and some other keywords I like to have highlighted.

I also found [comware-router-mode](https://github.com/daviderestivo/comware-router-mode/blob/master/comware-router-mode.el) that started from the same place but adapted to Comware with some interesting ideas of how to do things that I'm looking at as well. All just trying to learn.

# License
 This file is NOT part of GNU Emacs.

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 3
 of the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
