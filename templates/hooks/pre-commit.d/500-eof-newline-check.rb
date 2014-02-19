#!/usr/bin/env ruby

class File
  def self.is_text?(filename)
    IO.popen(["file", "--brief", filename]).any? do |line|
      line.match(/\btext\b/)
    end
  end

  def self.has_newline_at_eof?(filename)
    File.open(filename, "r") do |fh|
      fh.seek(-1, IO::SEEK_END)
      return fh.read == "\n"
    end
  end
end

def cached_changes
  IO.popen("git diff --cached --name-status").map do |line|
    line.chomp.split(/\t/, 2)
  end
end

def added_or_modified_changes
  cached_changes.find_all { |status, _| status != "D" }
end

def changed_files
  added_or_modified_changes.map { |_, filename| filename }
end

def changed_text_files
  changed_files.find_all { |filename| File.is_text?(filename) }
end

rc = 0

changed_text_files.each do |filename|
  next unless File.exist?(filename)
  next if File.has_newline_at_eof?(filename)
  rc = 111
  print "#{filename}: no newline at end of file\n"
end

exit rc
