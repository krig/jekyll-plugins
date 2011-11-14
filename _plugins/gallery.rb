# Basic: add a `gallery` attribute to the YAML header of any page with value
# being the extension of your images. Every image with that extension stored
# inside the page's directory (and every one of its subdirectories) will be
# added to the `gallery_items` attribute of that same page (alphabetically
# sorted).

module Jekyll
  class Gallery < Generator
    safe true

    def generate site
      # first collect all image pages
      images = []
      site.posts.reverse.each do |post|
        if post.data['image']
          images.push({
            'title' => post.data['title'],
            'image' => post.data['image'],
            'thumb' => File.join('/thumbnails', File.basename(post.data['image'])),
            'url' => post.url
          })
          end
      end

      # then add the images to all gallery pages
      site.pages.each do |page|
        gallery(site, page, images) if page.data['gallery']
      end
    end

    def gallery site, page, images
      page.data = page.data.deep_merge 'gallery_items' => images
    end
  end
end
