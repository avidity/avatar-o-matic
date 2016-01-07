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

      def genders
        [:male, :female]
      end

      def options_for(gender, property)
        image_data[gender.to_sym][property.to_sym]
      end

      def image_data
        return @_data if @_data

        @_data  = {}
        re_file = /
          \/
            (#{self.genders.join('|')})
          \/
            (#{self.properties.join('|')})
            \d+
            \.png
        \Z/xo

        Find.find(image_lib) do |path|
          m = re_file.match(path) or next

          gender = m[1].to_sym
          property = m[2].to_sym

          @_data[gender] ||= {}
          @_data[gender][property] ||= []
          @_data[gender][property] << path
        end

        @_data
      end
    end
  end
end
