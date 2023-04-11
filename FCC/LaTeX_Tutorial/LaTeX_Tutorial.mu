# LaTeX Tutorial



## Common Mathematical Notation

One thing to keep in mind is the "\\displaystyle" command, which can help 
us change a specific command into a more helpful display style.

Another helpful thing when doing a newline with "\\\\" is we can add a \[ some number plus "pt" \] around it.

Using \\left\(bracket, curly, langle, pipe\) or \\right\(bracket, curly, rangle, pipe\) makes them automatically grow to the size they should be. This is specifically helpful in math mode.

There is also a special case for the above where you may want just one, either left or right. In that case, have the other one that you do not want display be a "." period.

## Brackets, Tables, and Arrays

### Tables

For tables, when specifying the columns after tabular, the key-letters "l", "c", "r" correspond to left, center, right alignment for that column! 
Along with this, we can specify the direct size of the table column via curly brackets after the column key-letter.

We can wrap a tabular in begin table, which will make the heights of elements within the tabular auto size. One thing to beware of is table will be auto placed on the page.
This feature can be overridden if you use the "float" package and set a table option of brackets "H" to make it appear where the text for the table is.

With tables, we can setup captions, centering for the table, merging of table cells, and stretching of cells.


### Arrays
Arrays are the way that we can have the nice equation labeling for each equation as we move down in rows of equations.

The specific way to create these arrays are via the begin "align" environment.

One thing to always consider is that the equation numbering is also preserved throughout the document. So, each new array will pick up the numbering from before.

We can align our equations within our arrays via adding a &, which will attempt to align all &'s within the "align" environment.



## Text and Document Formatting

`\today` is a helpful tool that will take todays date and add it as a string.

When using sections or subsections, you can add a \* after the section or subsection command to suppress the numbering.

Consider using the `\tableofcontents` and `\maketitle` commands to helpfully add features based upon the rest of the document without having to manually create them.


## Packages, Macros, Graphics

You can use the "geometry" package to help control the margins. Set each value custom with brackets, top = 1 in, bottom = ... right during the geometry package usepackage.

Use the `\def` command so that we can create Macros. Do `\def\< macroName>{< value to replace>}`.

It is similar to `\newcommand`, but more direct sometimes.



