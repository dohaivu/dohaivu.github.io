module Jekyll

  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category

      category_title_prefix = 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['tag'] = tag

      category_title_prefix = 'Tag: '
      self.data['title'] = "#{category_title_prefix}#{tag}"
    end
  end

  class AtomPage < Page
    def initialize(site, base, dir, type, val, posts)
      @site = site
      @base = base
      @dir = dir
      @name = 'rss.xml'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "rss_index.xml")
      self.data[type] = val
      self.data["grouptype"] = type 
      self.data["posts"] = posts     
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || 'categories'
        site.categories.each do |category|
          site.pages << CategoryPage.new(site, site.source, File.join(dir, category[0]), category[0])
          site.pages << AtomPage.new(site, site.source, File.join(dir, category[0]), "category", category[0], category[1])
        end
      end

      if site.layouts.key? 'tag_index'
        dir = site.config['tag_dir'] || 'tags'
        site.tags.each do |tag|
          site.pages << TagPage.new(site, site.source, File.join(dir, tag[0]), tag[0])
          site.pages << AtomPage.new(site, site.source, File.join(dir, tag[0]), "tag", tag[0], tag[1])
        end
      end
    end
  end    
end