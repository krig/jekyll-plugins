# Jekyll Plugins

These are the plugins for Jekyll I use on my personal website.

### archive.rb

This is a pretty much an unmodified version of 
[this plugin][archive] by `josegonzalez`.

 [archive]: https://github.com/josegonzalez/josediazgonzalez.com/blob/master/_plugins/archive.rb "archive.rb"

### foldergallery.rb

This is a very simple art gallery type plugin. The basic idea is to create a page that has thumbnails for all of the images in a directory.

1. Create a directory, lets call it `art`, and create an `index.html` post in there.
2. Put a bunch of images in the directory. They can be `.jpg`, `.png` or `.gif`s.
3. Put thumbnails for each image in another directory somewhere. For this example, lets call that `art_thumbs`. I have another plugin that creates the thumbnails automatically.
4. In the index.html file, put the foldergallery tag:

    {% foldergallery name:art thumbnails:art_thumbs %}

    Here, you can access file.title, file.url, file.thumb, file.name and file.path.

    {% endfoldergallery %}

`file.title` is a bit of a hack: It's the name of the file with underscores converted to spaces, titleized. 
So `my_little_image.jpg` would get the title `My Little Image`.

`foldergallery.rb` is heavily based on the gallery plugin created by [github.com/robru][robru] and which is being included in jekyll properly, but his use case was slightly different than my own.

 [robru]: https://github.com/robru "github.com/robru"

### minimagick.rb

Originally by [zroger][zroger]. My version is modified to execute multiple filter steps in the order that they are given in `_config.yml`. This is what I use to generate thumbnails for the gallery and the cats page on my site. The commands I have in `_config.yml` look like this:

    mini_magick:
      thumbnail:
        source: gallery
        destination: thumbnails
        commands:
          - thumbnail: "140x140^"
          - crop: "140x140-0x0"
      catnail:
        source: cats
        destination: cats/thumbs
        commands:
          - thumbnail: "140x140^"
          - crop: "140x140-0x0"

 [zroger]: https://github.com/zroger/jekyll-minimagick "github.com/zroger/jekyll-minimagick"

### gallery.rb

This, again, is a gallery related plugin. This one is used to create the art gallery page. In this case, I didn't just want each picture to be just a picture with a thumbnail, I wanted to be able to add any amount of information to a particular image. Therefore, I start off by creating a post for the image.

I then set `image` to point to the image I want to post, and I also require the `title` to be set. That's it. I also have some special magic in the layout for image pages that optionally uses a medium sized preview image in the post itself and links to the image if it is very large.

The plugin handles the rest. It loops through all of the posts with `image` set and adds them to a list, and then loops through all pages with the `gallery` flag set and adds the list of images to those pages.

On the gallery page, I just loop over `page.gallery_items` to display the thumbnails.


### tags.rb

This plugin just generates pages for every tag, using `tag.html` as layout. It sets the variable `page.tag` on each page.

### tagcloud.rb

This is a slightly modified version (perhaps even not modified at all) of the plugin made by Anurag Priyam. Get it [here][tagcloud].

 [tagcloud]: http://yeban.in/jekyll-tag-cloud.html "tag_cloud.rb"

### haml_converter.rb

This is a HAML/SASS converter that has been tweaked to handle `.scss` files.

### version.rb

Basically the simplest example provided for how to make a Jekyll plugin. I use it to cache-bust between versions of the site.

### related.rb

`related.rb` is a plugin which modified the related pages-algorithm to look at categories. I changed it so it is based on tags, not categories.

Categories in Jekyll is basically the folder structure used, so a post in `/ruby/_posts/` would have the category `ruby`. I don't really use that feature, instead I use tags to categorize my posts.

Original [here][rel].

 [rel]: https://github.com/LawrenceWoodman/related_posts-jekyll_plugin/blob/master/_plugins/related_posts.rb "related_posts.rb"

# Other plugins

There's a few other files in there that I'm not entirely sure what they do.
There's something that does source highlighting via pygments, and some other plugins I also use.
