require 'json'
module Jekyll
  class MapPageGenerator < Generator
    safe true

    def generate(site)
	  limiter = Jekyll.configuration({})['sitemap_limit']
      file = File.read('./data.json')
      pesrt = JSON.parse(file)
      as = []
      pesrt.each do |tag|
        unless tag[1]["time"].empty?
            datey = Time.parse(tag[1]["time"])
            today=Time.now
            if today >= datey
                as.append(tag[1])
            end
        end
      end
      as.each do |tag|
        # reh = as.find_index(tag)
        # c = reh > 15 ? reh-16 : 0
        # releateds = as[c,c+15]
        # releateds = releateds.delete_if { |i| i == tag }
        releateds = as.sample(10)
        site.pages << MapPage.new(site, site.source, tag, releateds)
      end
    end
  end

  class MapPage < Page
    def initialize(site, base, tag, releateds)
      @site = site
      @base = base
      @dir  = "#{tag['url']}"
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'postm.html')
      self.data['perm'] = tag
	  self.data['permalink'] = "/#{tag['url']}"
      self.data['relateds'] = releateds
    end
  end
end