# PhotoArchiver
Search for photos on a PC and copy files to USB stick in year/month subdirectory structure according to photo date.

This is a bash shell script, initially tested using cygwin on Windows-10. It should be easily transferred/adapted to other Linux type ssytems too.

Initially this was inspired by a "photostick" product. But that only had options to place files into a single directory or to retain the file structure. I wanted something which could look at the date of a file and use it to create a photo diary. I've take the approach that groupiong by month is good enough, but it could be tweaked to group by day. If run on multiple machines using the same memory stick, the files are placed into the same directory structure.
