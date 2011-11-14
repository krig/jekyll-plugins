module Jekyll
  class TagPage < Page
    def initialize(site, base, dir, tag, posts)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['tag'] = tag
      self.data['title'] = "Posts tagged with #{tag}"
      self.data['collated_posts'] = posts
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag'
        dir = 'tags'
        site.tags.each do |tag, posts|
          write_tag_index(site, File.join(dir, tag), tag, posts)
        end
      end
    end

    def write_tag_index(site, dir, tag, posts)
      index = TagPage.new(site, site.source, dir, tag, posts)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.static_files << index
    end
  end
end
