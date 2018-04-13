require 'mysqlcnfparse/document'
module MysqlCnfParse
  class Generator < IniParse::Generator

    def initialize(opts = {}) # :nodoc:
      super(opts)
      @document   = MysqlCnfParse::Document.new
      @context    = @document
    end

    def section(name, opts = {})
      if @in_section
        # Nesting sections is bad, mmmkay?
        raise LineNotAllowed, "You can't nest sections in INI files."
      end

      # Add to a section if it already exists
      if @document.has_section?(name.to_s())
        @context = @document[name.to_s()]
      else
        @context = MysqlCnfParse::Lines::Section.new(name, line_options(opts))
        @document.lines << @context
      end

      if block_given?
        begin
          @in_section = true
          with_options(opts) { yield self }
          @context = @document
          blank()
        ensure
          @in_section = false
        end
      end
    end

    # Adds a new include line to the document.
    def include(path, opts={})
      @context = @document
      @context.lines << Lines::Include.new(path,opts)
    end

    # Adds a new includedir line to the document.
    def includedir(path, opts={})
      @context = @document
      @context.lines << Lines::IncludeDir.new(path,opts)
    end

  end
end
