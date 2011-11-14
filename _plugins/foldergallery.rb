require 'titleize'

module Jekyll

  class FolderGalleryTag < Liquid::Block
    include Convertible
    attr_accessor :content, :data

    def initialize(tag_name, markup, tokens)
      attributes = {}

      # Parse parameters
      markup.scan(Liquid::TagAttributes) do |key, value|
        attributes[key] = value
      end

      @name = attributes['name']   || '.'
      @thumbdir = attributes['thumbnails'] || false
      @rev  = attributes['reverse'].nil?

      # Prevent template data from doing evil.
      [@name].each do |s|
        s.delete! '/[]{}*?'
        s.squeeze! '.'
      end

      super
    end

    def render(context)
      context.registers[:gallery] ||= Hash.new(0)

      files = Dir[File.join(@name, "*.{jpg,png,gif}")]
      files.sort! {|x,y| @rev ? y <=> x : x <=> y }
      length = files.length
      result = []

      context.stack do
        files.each_with_index do |filename, index|
          basename = File.basename(filename)

          url  = ['', @name, basename] - ['.']
          path = url[-2..-1].join '/'
          url  = url.join '/'


          _, title, ext = *basename.match(/(.*)(\.(jpg|png|gif))$/)

          title = title.gsub('_', ' ')

          thumbnail = url
          thumbnail = File.join('/', @thumbdir, basename) unless @thumbdir.nil?

          context['file'] = {
            'title' => title.titleize,
            'name' => basename,
            'path' => path,
            'url' => url,
            'thumb' => thumbnail
          }

          # Obviously images don't contain YAML but this bit is included
          # on the off chance that somebody is using this tag for other files
          # that do have YAML Front Matter. This is a harmless nop on images.
          self.read_yaml(@name, basename)
          context['file'].merge! self.data

          context['forloop'] = {
            'name' => 'foldergallery',
            'length' => length,
            'index' => index + 1,
            'index0' => index,
            'rindex' => length - index,
            'rindex0' => length - index - 1,
            'first' => (index == 0),
            'last' => (index == length - 1)
          }

          result << render_all(@nodelist, context)
        end
      end
      result
    end

  end

end

Liquid::Template.register_tag('foldergallery', Jekyll::FolderGalleryTag)

