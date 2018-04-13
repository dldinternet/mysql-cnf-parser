require 'iniparse'
require 'mysqlcnfparse/parser'

module MysqlCnfParse
  # A base class for IniParse errors.
  class MysqlCnfParseError < IniParse::IniParseError; end

  module_function

  def parse(source)
    MysqlCnfParse::Parser.new(source.gsub(/(?<!\\)\\\n/, '')).parse
  end

  def open(path)
    document = parse(File.read(path))
    document.path = path
    document
  end

  def gen(&blk)
    IniParse::Generator.new.gen(&blk)
  end
end
