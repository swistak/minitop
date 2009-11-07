" */ /* SCC has been trained to know about strings /* */ */"!
"\"Double quotes embedded in strings, \\\" too\'!"
"And \
newlines in them"

"And escaped double quotes at the end of a string\""

aa '\\
n' OK
aa "\""
aa "\
\n"

This is followed by C++/C99 comment number 1.
// C++/C99 comment with \
continuation character \
on three source lines (this should not be seen with the -C fla
The C++/C99 comment number 1 has finished.

This is followed by C++/C99 comment number 2.
/\
/\
C++/C99 comment (this should not be seen with the -C flag)
The C++/C99 comment number 2 has finished.

This is followed by regular C comment number 1.
/\
*\
Regular
comment
*\
/
The regular C comment number 1 has finished.

/\
\/ This is not a C++/C99 comment!

This is followed by C++/C99 comment number 3.
/\
\
\
/ But this is a C++/C99 comment!
The C++/C99 comment number 3 has finished.

/\
\* This is not a C or C++  comment!

This is followed by regular C comment number 2.
/\
*/ This is a regular C comment *\
but this is just a routine continuation *\
and that was not the end either - but this is *\
\
/
The regular C comment number 2 has finished.

This is followed by regular C comment number 3.
/\
\
\
\
* C comment */
