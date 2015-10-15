#!/bin/sh

changed_files() {
  git diff --cached --name-status | grep '^[AM]' | cut -f2-
}

file_is_text() {
  file --brief "$1" | egrep -q '\btext\b'
}

file_does_not_have_newline_at_eof() {
  tail -c1 "$1" | grep -q .
}

rc=0

for changed_file in $(changed_files); do
  file_is_text $changed_file || continue
  file_does_not_have_newline_at_eof $changed_file || continue
  echo "${changed_file}: no newline at end of file"
  rc=111
done

exit $rc
