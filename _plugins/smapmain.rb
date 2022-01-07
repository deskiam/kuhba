require 'json'
module Jekyll
  class SmapmainPageGenerator < Generator
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
      site.pages << SmapmainPage.new(site, site.source, as)
    end
  end

  class SmapmainPage < Page
    def initialize(site, base, as)
      @site = site
      @base = base
      @dir  = "sitemap.xml"
      @name = 'index.xml'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'sitemap.xml')
      self.data['tot'] = as.length
	  self.data['permalink'] = "/sitemap.xml"
    end
  end
end