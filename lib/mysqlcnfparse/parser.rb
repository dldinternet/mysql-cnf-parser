require 'mysqlcnfparse/lines'
require 'mysqlcnfparse/generator'

module MysqlCnfParse
  class Parser < IniParse::Parser

    self.parse_types = self.parse_types + [ MysqlCnfParse::Lines::Include, MysqlCnfParse::Lines::IncludeDir ]

    # Parses the source string and returns the resulting data structure.
    #
    # ==== Returns
    # IniParse::Document
    #
    def parse
      MysqlCnfParse::Generator.gen do |generator|
        @source.split("\n", -1).each do |line|
          generator.send(*Parser.parse_line(line))
        end
      end
    end

  end # Parser
end # MysqlCnfParse
