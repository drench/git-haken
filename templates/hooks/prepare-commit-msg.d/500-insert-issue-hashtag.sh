#!/bin/sh

# If your branch name includes something that looks like a ticket number,
# this puts it into your commit message template.

# If $2 contains something (such as "message" or "merge") then don't bother:
test -n "$2" && exit 0

ticket=$(
  git symbolic-ref HEAD |
  ruby -pe'$_ = $_.split(%r{/})[-1].chomp.split(%r{[-_]}).grep(/^\d+$/).map { |n| "[\##{n}]" }.join(" ")'
)

test -z "$ticket" && exit 0 # no ticket number found

orig=$(echo "$ticket"; cat "$1")
echo "$orig" > "$1"
