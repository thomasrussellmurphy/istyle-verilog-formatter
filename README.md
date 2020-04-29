# iStyle v1 #
## Fast and Free Automatic Formatter for Verilog Source Code ##
```
    Created by haimag
    Thanks to Tal Davidson & Astyle
    Report bugs https://github.com/thomasrussellmurphy/istyle-verilog-formatter/issues
```

> Originally hosted at http://code.google.com/p/istyle-verilog-formatter before Google Code EOL

```
Usage:
    iStyle [options] Foo.v  B*r.v  [...]
    OR, use stdin/stdout
    iStyle [options] <Foo.v >Foo_formatted.v

When indenting a specific file, the resulting indented file RETAINS the
original file-name. The original pre-indented file is renamed, with a
suffix of ".orig" added to the original filename.

By default, iStyle is set up to indent Verilog files, with 4 spaces per
indent, a maximal indentation of 40 spaces inside continuous statements,
and NO formatting.
```
## Option's Format: ##

---

```
    Long options (starting with '--') must be written one at a time.
    Short options (starting with '-') may be appended together.
    Thus, -bps4 is the same as -b -p -s4.
```
## Predefined Styling options: ##

---

```
    --style=ansi
    ANSI style formatting/indenting.

    --style=kr
    Kernighan&Ritchie style formatting/indenting.

    --style=gnu
    GNU style formatting/indenting.
```
## Indentation options: ##

---

```
    -s   OR   -s#   OR   --indent=spaces=#
    Indent using # spaces per indent. Not specifying #
    will result in a default of 4 spaces per indent.

    -t   OR   -t#   OR   --indent=tab=#
    Indent using tab characters, assuming that each
    tab is # spaces long. Not specifying # will result
    in a default assumption of 4 spaces per tab.

    -T#   OR   --force-indent=tab=#
    Indent using tab characters, assuming that each
    tab is # spaces long. Force tabs to be used in areas
    iStyle would prefer to use spaces.

    -B   OR   --indent-brackets
    Add extra indentation to 'begin' and 'end' block brackets.

    -G   OR   --indent-blocks
    Add extra indentation entire blocks (including brackets).

    -m#  OR  --min-conditional-indent=#
    Indent a minimal # spaces in a continuous conditional
    belonging to a conditional header.

    -M#  OR  --max-instatement-indent=#
    Indent a maximal # spaces in a continuous statement,
    relatively to the previous line.

    -E  OR  --fill-empty-lines
    Fill empty lines with the white space of their
    previous lines.

    --indent-preprocessor
    Indent multi-line #define statements
```
## Formatting options: ##

---

```
    -b  OR  --brackets=break
    Break brackets from pre-block code (i.e. ANSI C/C++ style).

    -a  OR  --brackets=attach
    Attach brackets to pre-block code (i.e. Java/K&R style).

    -o   OR  --one-line=keep-statements
    Don't break lines containing multiple statements into
    multiple single-statement lines.

    -O   OR  --one-line=keep-blocks
    Don't break blocks residing completely on one line

    -p   OR  --pad=oper
    Insert space paddings around operators only.

    --pad=paren
    Insert space paddings around parenthesies only.
    -l OR --pad=block
    Enclose one statement in a begin-end only for keyword if/else/while/for.

    -P   OR  --pad=all
    Insert space paddings around operators AND parenthesies.

    --convert-tabs
    Convert tabs to spaces.

    --break-blocks
    Insert empty lines around unrelated blocks, labels, ...

    --break-blocks=all
    Like --break-blocks, except also insert empty lines
    around closing headers (e.g. 'else', ...).

    --break-elseifs
    Break 'else if()' statements into two different lines.
```
## Other options: ##

---

```
    --suffix=####
    Append the suffix #### instead of '.orig' to original filename.

    -n   OR  --suffix=none
    Tells Astyle not to keep backups of the original source files.
    WARNING: Use this option with care, as Astyle comes with NO WARRANTY...

    -X   OR  --errors-to-standard-output
    Print errors and help information to standard-output rather than
    to standard-error.

    -v   OR   --version
    Print version number

    -h   OR   -?   OR   --help
    Print this help message

    --options=####  OR --options=none
    Parse used the specified options file: ####, options=none, none
    parse options file, and not looks for parse options files
```
## Default options file: ##

---

```
    iStyle looks for a default options file in the following order:
    1. The contents of the ISTYLE_OPTIONS environment
       variable if it exists.
    2. The file called .iStylerc in the directory pointed to by the
       HOME environment variable ( i.e. $HOME/.iStylerc ).
    3. The file called .iStylerc in the directory pointed to by the
       HOMEPATH environment variable ( i.e. %HOMEPATH%\.iStylerc ).
    If a default options file is found, the options in this file
    will be parsed BEFORE the command-line options.
    Options within the default option file may be written without
    the preliminary '-' or '--'.
```
