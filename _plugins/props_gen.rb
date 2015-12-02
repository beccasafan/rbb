module Jekyll
  class PropsIndex < Page
    def initialize(site, base, dir, prop)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'prop.html')
      self.data['prop'] = prop
      self.data['title'] = prop
    end
  end
  class PropsGenerator < Generator
    safe true
    def generate(site)
      key = "props"
      allProps = site.posts.flat_map { |p| p.data[key] }.uniq
      allProps.delete(nil)
      allProps = allProps.sort_by(&:downcase)

      propsData = site.collections[key].docs.map { |doc| Hash["code", doc.basename_without_ext, "title", doc.data["title"], "url", doc.url, "image", doc.data.key?("images") ? "%s/%s/%s" % [key, doc.basename_without_ext, doc.data["images"][0]] : "no-image.jpg" ]}
      propsHash = propsData.map{ |p| [p["code"], p]}.to_h


      existingProps = site.collections[key].docs.map{ |d| d.basename_without_ext }
      for prop in allProps - existingProps
        propsHash[prop] = Hash["code", prop, "title", prop, "url", "/props/" << prop, "image", "no-image.jpg"]
        write_prop_index(site, File.join(key, prop), prop)
      end

      propsHash = propsHash.sort_by { |key, value| value["title"].downcase }.to_h

      propsHash.each_with_index do |(key, value), index|
        if index > 0
          propsHash[key]["previous"] = propsHash.keys[index-1]
        end
        if index < propsHash.size - 1
          propsHash[key]["next"] = propsHash.keys[index+1]
        end
      end
      site.config["all" << key] = propsHash
    end

    def write_prop_index(site, dir, prop)
      index = PropsIndex.new(site, site.source, dir, prop)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end
  end
end
