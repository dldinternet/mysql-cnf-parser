require 'mysqlcnfparse/line_collection'
module MysqlCnfParse
  # Represents an INI document.
  class Document < IniParse::Document

    # Creates a new Document instance.
    def initialize(path = nil)
      @path  = path
      @lines = MysqlCnfParse::SectionCollection.new
    end
    # A human-readable version of the document, for debugging.
    def inspect
      sections = @lines.select { |l| l.is_a?(IniParse::Lines::Section) }
      "#<MysqlCnfParse::Document {#{ sections.map(&:key).join(', ') }}>"
    end

    # Saves a copy of this Document to disk.
    #
    # If a path was supplied when the Document was initialized then nothing
    # needs to be given to Document#save. If Document was not given a file
    # path, or you wish to save the document elsewhere, supply a path when
    # calling Document#save.
    #
    # ==== Parameters
    # path<String>:: A path to which this document will be saved.
    #
    # ==== Raises
    # IniParseError:: If your document couldn't be saved.
    #
    def save(path = nil)
      @path = path if path
      raise MysqlCnfParseError, 'No path given to Document#save' if @path !~ /\S/
      File.open(@path, 'w') { |f| f.write(self.to_ini) }
    end


    # Returns a has representation of the INI with multi-line options
    # as an array
    def to_hash
      result = {}
      @lines.entries.each do |section|
        result[section.key] ||= {}
        result[section.key].merge!(section.to_hash)
      end
      result
    end
  end
end
