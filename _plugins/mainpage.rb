require 'json'
module Jekyll
  class MainindexPageGenerator < Generator
    safe true

    def generate(site)
	  limiter = Jekyll.configuration({})['sitemap_limit']
      file = File.read('./data.json')
      pesrt = JSON.parse(file)
      as = []
      pesrt.each do |tag|
        #print tag[1]["time"]
        unless tag[1]["time"].empty?
            datey = Time.parse(tag[1]["time"])
            today=Time.now
            if today >= datey
                as.append(tag[1])
            end
        end
      end
      site.pages << MainindexPage.new(site, site.source, as)
    end
  end

  class MainindexPage < Page
    def initialize(site, base, as)
      @site = site
      @base = base
      @dir  = "index.html"
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'default.html')
      self.data['tot'] = as.last(32).reverse()
	  self.data['permalink'] = "/index.html"
    end
  end
end