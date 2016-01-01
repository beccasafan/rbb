module Jekyll
  class ItemsIndex < Page
    def initialize(site, base, dir, item, template)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, "_layouts"), "%s.html" % [template])
      self.data[template] = item
      self.data["title"] = item
    end
  end

  class ItemsGenerator < Generator
    safe true
    def generate(site)
      site.config["varGroups"].each do |group|
        isCollection = group["isCollection"]
        collectionParent = group["collectionParent"]
        varName = group["varName"]
        template = group["template"]
        sortBy = group["sortBy"]
        permalink = group["permalink"]
        saveContent = group["saveContent"]

        groupVariable(site, isCollection, collectionParent, varName, template, sortBy, permalink, saveContent)
      end
    end

    def groupVariable(site, isCollection, collectionParent, varName, template, sortBy, permalink, saveContent)
      allItems = (isCollection ? site.collections[collectionParent].docs : site.posts.docs).flat_map { |p| p.data[varName] }.uniq
      allItems.delete(nil)
      allItems = allItems.sort_by(&:downcase)
      categoryName = template + "Categories"
      parentName = template + "Parent"
      itemsData = site.collections[varName].docs.map { |doc| Hash["code", doc.basename_without_ext, "title", doc.data["title"], "url", doc.url, "image", doc.data.key?("images") ? "%s/%s/%s" % [varName, doc.basename_without_ext, doc.data["images"][0]] : "no-image.jpg", parentName, doc.data[parentName], categoryName, doc.data[categoryName], "content", saveContent ? doc.content : "", "order", doc.data["order"] ]}
      itemsHash = itemsData.map { |p| [p["code"], p]}.to_h

      existingItems = site.collections[varName].docs.map { |d| d.basename_without_ext }
      for item in allItems - existingItems
        itemsHash[item] = Hash["code", item, "title", item, "url", "/%s/" % [varName] << item, "image", "no-image.jpg"]
        write_item_index(site, File.join(permalink || varName, item), item, template)
      end

      itemsHash = itemsHash.sort_by { |key, value| (value[sortBy] || "zzzzzzzzzzzzzzzz").to_s.downcase }.to_h

      itemsHash.each_with_index do |(key, value), index|
        if index > 0
          itemsHash[key]["previous"] = itemsHash.keys[index-1]
        end
        if index < itemsHash.size - 1
          itemsHash[key]["next"] = itemsHash.keys[index+1]
        end
      end
      site.config["all" << varName] = itemsHash
    end

    def write_item_index(site, dir, item, template)
      puts "%s: %s" % [template, item]

      index = ItemsIndex.new(site, site.source, dir, item, template)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end
  end
end
