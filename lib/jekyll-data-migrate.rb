class DataMigrate < Jekyll::Command
  class << self

    def init_with_program(prog)
      prog.command(:migrate) do |c|
        c.syntax "migrate [options]"
        c.description 'Migrate values from data files to collection documents'
        c.option 'from', '-f FROM', 'The data file to read from.'
        c.option 'to', '-t TO', 'The targeted collection.'
        c.action do |args, options|
          puts "Migrate #{options['to']} to #{options['from']}"
        end
      end
    end
  end
end
