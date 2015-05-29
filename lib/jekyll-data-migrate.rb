require 'JSON'
class DataMigrate < Jekyll::Command
  class << self

    def init_with_program(prog)
      site = Jekyll::Site.new(Jekyll.configuration)
      @site = site
      prog.command(:migrate) do |c|
        c.syntax "migrate [options]"
        c.description 'Migrate values from data files to collection documents'
        c.option 'from', '--from FROM', 'The data file to read from.'
        c.option 'to', '--to TO', 'The targeted collection.'
        c.action do |args, options|
          self.migrate_data(options)
        end
      end
    end
    def migrate_data(options)
      data = self.load_data(options)
      loop_collections(data, options['to'])
    end
    def load_data(options)
      path_root = Jekyll.configuration['source']
      data_root = File.join(@site.config['data_source'])
      json = File.join(data_root, "#{options['from']}.json")
      if File.exists?(json)
        file = File.read(json)
        data = JSON.parse(file)
      elsif File.exists?(yaml)
        data = YAML.load_file(yaml)
      else
        puts "Migration failed, no data file found named '#{options['from']}, check your data directory at #{data_root} to ensure this file exists."
        exit 1
      end
    end
    def loop_collections(data, collection)
      dir = File.join(Jekyll.configuration['source'], "_#{collection}")
      unless @site.collections[collection]
          puts "Migration failed no collection exists named '#{collection}!'"
          exit 1
      end
      data.each do |d|
        doc = File.join(dir, "#{d[0]}.md")
        file = File.open(doc)
        new = YAML.load_file(doc)
        merge = Jekyll::Utils.deep_merge_hashes(new, d[1])
        require 'pry'; binding.pry;  
      end
    end
  end
end
