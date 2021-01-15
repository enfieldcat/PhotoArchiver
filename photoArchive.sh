$ cat photo.sh
#!/bin/bash
#
# PhotoArchive.sh
#
# Searches for photo files and trans fers them to a USB stick, the script below should work in cygwin environments on Windows
# Check for date using exif data if present, otherwise use the file date as the date taken
#
# Note you should have bash, exif, awk and rsync installed, for this to work.
#

# If there are multiple sources which need searching define them one per line here
# Remember to enclose the sources within quotes around the list
sources="/cygdrive/c/users
/cygdrive/c/projects"
# Or for a single source, define it like this
sources="/cygdrive/c/users"

# Define where the photos should be stored, on my system /cygdrive/g is my USB drive/
dest="/cygdrive/g"

# Exit if destination directory does not exist
if [ ! -d "${dest}" ] ; then
  echo "${dest} is missing. Insert USB drive and create directory"
  exit 1
fi

# Work through all sources listed
echo "${sources}" | while read SRC ; do
  if [ -d "${SRC}" ] ; then
    echo "Searching ${SRC}"
    # These are the file types we will include in our archive.
    # Additional file suffixes can be added to this list
    for filetype in jpg JPG JPEG jpeg ; do
      echo " - ${filetype} files"
      # Process through a list of candidate files, but exclude trash and application data
      find "${SRC}" -name "*.${filetype}" -type f -print 2>/dev/null | egrep -v ".Trash|AppData" | while read FILE ; do
        # echo "   + ${FILE}"
        # First check exif data in the file header as the authoritative date taken information
        ds=`exif "${FILE}" 2>/dev/null | grep "^Date" | head -1 | awk -F '|' ' { print $2 } ' | awk -F ':' ' { print $1 "/" $2 }'`
        if [ "${ds}" = "" ] ; then
          # If not found then use the file date as the date reference
          ds=`ls --full-time "${FILE}" | awk ' { split ($6, part, "-"); print part[1] "/" part[2] } '`
        fi
      # Create the destination directory if it is missing
        if [ ! -d "${dest}/${ds}" ] ; then
          mkdir -p "${dest}/${ds}"
        fi
        # Copy the file over to the destination
        rsync -p -t "${FILE}" "${dest}/${ds}"
      done
    done
  else
    echo "Skipping ${SRC} - not a directory"
  fi
done
exit 0
