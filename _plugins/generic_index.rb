require 'inflection'

module Jekyll
  class GenericPageTypeIndex < Page
    attr_accessor :page_type

    def initialize(site, base, dir, page, page_type, config)
      @page_type = page_type
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "#{config['index_page']}.html")
      self.data[@page_type] = page

      if config['do_related']
        self.data[config['related_key']] = []
        site_coll = site.send ::Inflection.plural(page_type)
        site_coll[page].each do |post|
          post_coll = post.send ::Inflection.plural(page_type)
          post_coll.each do |rel|
            self.data[config['related_key']].push(rel)
          end
        end
        self.data[config['related_key']] = self.data[config['related_key']].uniq
      end

      self.data['title'] = "#{config["title_prefix"]}#{page}"
    end
  end

  class GenericPageTypeList < Page
    attr_accessor :page_type

    def initialize(site,  base, dir, pages, page_type, config)
      @page_type = page_type
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "#{config['list_page']}.html")
      self.data[::Inflection.plural(@page_type)] = pages
    end
  end

  class GenericPageGenerator < Generator
    safe true

    def generate(site)
      if site.config.has_key?('index_pages') == false
        return true
      end

      site.config['index_pages'].each do |page_type|
        config = {}
        if page_type.is_a?(Hash)
          page_type, config['do_related'] = page_type.shift
        elsif page_type.is_a?(Array)
          page_type, config = page_type
        end

        config = config.merge!({
          'do_related'  => false,
          'page_title'  => page_type.capitalize + ': ',
          'index_page'  => "#{page_type}_index",
          'list_page'   => "#{page_type}_list",
          'page_dir'    => "#{page_type}_dir",
          'related_key' => "related"
        }){ |key, v1, v2| v1 }

        dir = site.config[config['page_dir']] || ::Inflection.plural(page_type)

        page_types = site.send ::Inflection.plural(page_type)

        if page_types && site.layouts.key?(config['index_page'])
          page_types.keys.each do |page|
            write_index(site, File.join(dir, page.gsub(/\s/, "-").gsub(/[^\w-]/, '').downcase), page, page_type, config)
          end
        end

        if page_types && site.layouts.key?(config['list_page'])
          write_list(site, dir, page_types.keys.sort, page_type, config)
        end
      end
    end

    def write_index(site, dir, page, page_type, config)
      index = GenericPageTypeIndex.new(site, site.source, dir, page, page_type, config)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.static_files << index
    end

    def write_list(site, dir, pages, page_type, config)
      index = GenericPageTypeList.new(site, site.source, dir, pages, page_type, config)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.static_files << index
    end
  end

end
