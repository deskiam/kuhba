require 'json'
module Jekyll
  class SMapPageGenerator < Generator
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
      maps = (as.length/limiter).floor
      (0..maps).each do |tag|
	    dnmo = tag+1
		cru = tag*limiter 
        arre = as[cru,cru+limiter]
        site.pages << SMapPage.new(site, site.source, dnmo, arre)
      end
    end
  end

  class SMapPage < Page
    def initialize(site, base, dnmo, arre)
      @site = site
      @base = base
      @dir  = "post-sitemap#{dnmo.to_s}"
      @name = 'index.xml'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'maps.xml')
      self.data['deta'] = arre
	  self.data['permalink'] = "/post-sitemap#{dnmo.to_s}.xml"
    end
  end
end