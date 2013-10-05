#!/usr/bin/env ruby
#
# This hook automatically sets up local git config overrides based on the
# directory where the repository lives.
#
# Let's say I have two git 'identities': one for work, and one for personal projects.
# My personal identity is my primary one, so my global `.gitconfig` has `user.email`
# set to my personal email account.
#
# I also work on work projects on this same computer under a directory called
# ~/TK
#
# My global git config has `user.email` set to `personal@example.org`. When I clone
# a work project, I want to use my work address, but I don't always remember to do
# this. This hook, properly configured, will take care of it automatically.
#
# Here's an example to set user.email to something@example.net under directories
# matching /dirpattern/i:
#
#   git config --add --global override.user.email dirpattern:something@example.net

def cloning?
  ARGV[0].match(/^0{40}$/)
end

def override_conf_lines
  `git config --get-regexp 'override.*'`.split(/[\r\n]+/).map { |line| line.chomp }
end

def conf_line_to_array(line)
  k,v = line.split(nil, 2)
  key = k.sub(/^override\./, "")
  dirmatch, value = v.split(/:/, 2)
  [ Regexp.new(dirmatch, Regexp::IGNORECASE), key, value ]
end

def overrides
  override_conf_lines.map { |line| conf_line_to_array(line) }.reduce({}) do |a,b|
    a[b[0]] ||= {}
    a[b[0]][b[1]] = b[2]
    a
  end
end

def in_dir?(pattern)
  pattern.match(Dir.getwd)
end

def apply_config(override)
  override.each_pair do |key, val|
    warn "Setting config local override #{key} = #{val}\n"
    Kernel.system("git", "config", "--local", key, val)
  end
end

exit 0 unless cloning?

overrides.each_pair do |pattern, override|
  apply_config(override) if in_dir?(pattern)
end
