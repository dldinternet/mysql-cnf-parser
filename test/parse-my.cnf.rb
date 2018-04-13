#!/usr/bin/env ruby
require 'rubygems'

path = File.dirname(__FILE__)
if File.exists?("#{path}/../.gitignore")
  %w(mysql-cnf-parser).each do |mod|
    add_path = File.expand_path(File.join(path, "../../#{mod}", "lib"))
    $:.unshift(add_path)
  end
else
  # Borrowing from "whiches" gem ...
  cmd  = File.basename(__FILE__, '.rb')
  exes = []
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |pth|
    exts.each { |ext|
      exe = File.join(pth, "#{cmd}#{ext}")
      exes << exe if File.executable? exe
    }
  end
  if exes.size > 0
    path = File.dirname(exes[0])
  end

end
add_path = File.expand_path(File.join(path, "..", "lib"))
$:.unshift(add_path)

require 'mysqlcnfparse'
require 'awesome_print'

my_cnf = <<EOF
#
# The MySQL database server configuration file.
#
# You can copy this to one of:
# - "/etc/mysql/my.cnf" to set global options,
# - "~/.my.cnf" to set user-specific options.
# 
# One can use all long options that the program supports.
# Run program with --help to get a list of available options and with
# --print-defaults to see which it would actually understand and use.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

#
# * IMPORTANT: Additional settings that can override those from this file!
#   The files must end with '.cnf', otherwise they'll be ignored.
#

[mysqld]
bind-address                   = 0.0.0.0
port                           = 3306
datadir                        = /var/mysql/data


!include /etc/mysql/mysqld.cnf
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/
EOF
mycnf = MysqlCnfParse.parse(my_cnf)
puts mycnf.to_hash.ai

