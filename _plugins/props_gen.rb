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
      prop_title_prefix = site.config['prop_title_prefix'] || ''
      prop_title_suffix = site.config['prop_title_suffix'] || ''
      self.data['title'] = "#{prop_title_prefix}#{prop}#{prop_title_suffix}"
    end
  end
  class PropsGenerator < Generator
    include ::Jekyll::Itafroma
    safe true
    def generate(site)
      key = "props"
      allProps = ::Jekyll::Itafroma::PostGroupsGenerator.new.post_key_hash(site, key, [])
      if site.layouts.key? "prop"
        dir = site.config['prop_dir'] || key
        existingProps = site.collections[key].docs.map{ |d| d.basename_without_ext }
        
        for prop in allProps
          exists = existingProps.include? prop[0]
          if !exists
            write_prop_index(site, File.join(dir, prop[0]), prop[0])
          end
        end
      end
    end
    def write_prop_index(site, dir, prop)
      index = PropsIndex.new(site, site.source, dir, prop)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end
  end
end
