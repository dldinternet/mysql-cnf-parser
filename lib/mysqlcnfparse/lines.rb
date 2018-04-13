require 'iniparse/lines'

module IniParse
  module Lines
    # A base class from which other line types should inherit.
    module Line
      def include?
        false
      end
    end
  end
end

module MysqlCnfParse
  module Lines

    class Include
      include IniParse::Lines::Line

      attr_accessor :path

      # !includedir /etc/mysql/conf.d/
      # noinspection RegExpRepeatedSpace
      @regex = /^!include     # Keyword
                 \s+          # whitespace
                 (\S+)
                 $
               /x

      # ==== Parameters
      # path<String>::   The option key.
      # opts<Hash>::    Extra options for the line.
      #
      def initialize(path, opts = {})
        super(opts)
        @path = path
      end

      def include?
        true
      end

      def key
        '!include'
      end

      def value
        @path
      end

      def self.parse(line, opts)
        if m = @regex.match(line)
          [:include, m[1].strip, opts]
        end
      end

      #######
      private
      #######

      def line_contents
        '!include %s' % path
      end

    end # Include

    class IncludeDir < Include
      # noinspection RegExpRepeatedSpace
      @regex = /^!includedir # Keyword
                 \s+          # whitespace
                 (\S+)
                 $
               /x

      def key
        '!includedir'
      end

      def self.parse(line, opts)
        if m = @regex.match(line)
          [:includedir, m[1].strip, opts]
        end
      end

      #######
      private
      #######

      def line_contents
        '!includedir %s' % path
      end

    end # IncludeDir

    class Section < IniParse::Lines::Section
      def initialize(key, opts = {})
        super(opts)
        @key   = key.to_s
        @lines = MysqlCnfParse::OptionCollection.new
      end

      # Returns a has representation of the INI with multi-line options
      # as an array
      def to_hash
        result = {}
        @lines.entries.each do |option|
          opts = Array(option)
          val = opts.map { |o| o.respond_to?(:value) ? o.value : o }
          val = val.size > 1 ? val : val.first
          result[opts.first.key] = val
        end
        result
      end
    end # Section

    class AnonymousSection < MysqlCnfParse::Lines::Section
      def initialize
        super('__anonymous__')
      end

      def to_ini
        coll = lines.to_a

        if coll.any?
          strs = [coll.to_a.map do |line|
            if line.kind_of?(Array)
              line.map { |dup_line| dup_line.to_ini }.join($/)
            else
              line.to_ini
            end
          end]
          strs.flatten.join($/)
        else
          super
        end
      end

      # Returns a has representation of the INI with multi-line options
      # as an array
      def to_hash
        result = {}
        @lines.entries.each do |option|
          opts = Array(option)
          val = opts.map { |o| o.respond_to?(:value) ? o.value : o }
          val = val.size > 1 ? val : val.first
          result[opts.first.key] ||= []
          result[opts.first.key] << val
        end
        unique = Hash[result.map {|key,val|
          val = val.size > 1 ? val : val.first
          [key,val]
        }]
        unique
      end

      #######
      private
      #######

      def line_contents
        # '[%s]' % key
        nil
      end

    end # AnonymousSection

  end # Lines

end # MysqlCnfParse
