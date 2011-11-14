module Jekyll
  #puts 'fucking fuck'
  require 'haml'
  class HamlConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /haml/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      excerpt = content[0..16].gsub(/\n/," ")
      engine = Haml::Engine.new(content, :format => :html5)
      engine.render
    end
  end

  require 'sass'
  class SassConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /scss/i
    end

    def output_ext(ext)
      ".css"
    end

    def convert(content)
      begin
        excerpt = content[0..16].gsub(/\n/," ")
        engine = Sass::Engine.new(content, :syntax => :scss)
        engine.render
      rescue StandardError => e
        puts "!!! SCSS Error: " + e.message
      end
    end
  end
end

