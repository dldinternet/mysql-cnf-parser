module MysqlCnfParse
  # A implementation of LineCollection used for storing (mostly) Option
  # instances contained within a Section.
  #
  # Since it is assumed that an INI document will only represent a section
  # once, if SectionCollection encounters a Section key already held in the
  # collection, the existing section is merged with the new one (see
  # IniParse::Lines::Section#merge!).
  class SectionCollection < IniParse::SectionCollection

    def <<(line)
      if line.kind_of?(MysqlCnfParse::Lines::Include) || line.kind_of?(MysqlCnfParse::Lines::IncludeDir)
        option = line
        line   = MysqlCnfParse::Lines::AnonymousSection.new

        line.lines << option if option
      end
      super(line)
    end
  end

  class OptionCollection < IniParse::OptionCollection
    def <<(line)
      if line.include?
        @lines << line
        self
      else
        super(line)
      end
    end
  end
end
