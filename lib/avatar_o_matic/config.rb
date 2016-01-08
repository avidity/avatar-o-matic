require 'find'

module AvatarOMatic
  class Config
    class << self

      attr_accessor :image_lib

      def image_lib
        @image_lib ||= File.expand_path( File.join( '..', '..', '..', 'data', 'images'), __FILE__ )
      end

      def properties
        [:background, :face, :clothes, :head, :eye, :mouth]
      end

      def types
        [:male, :female]
      end

      def options_for(type, prop)
        image_data[type.to_sym][prop.to_sym]
      end

      def image_data
        return @_data if @_data

        @_data  = {}
        re_file = /
          \/
            (#{self.types.join('|')})
          \/
            (#{self.properties.join('|')})
            \d+
            \.png
        \Z/xo

        Find.find(image_lib) do |path|
          m = re_file.match(path) or next

          type = m[1].to_sym
          prop = m[2].to_sym

          @_data[type] ||= {}
          @_data[type][prop] ||= []
          @_data[type][prop] << path
        end

        @_data
      end
    end
  end
end
