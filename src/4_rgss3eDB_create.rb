module RGSS3EDB
  class Create
    def self.table name,columns,autoincreement
      selected_db = Config.get("database.selected_db")
      if name.split('.').length == 2
        name = name.split('.')
        selected_db = name[0]
        name = name[1]
      end
      if !Dir.exists? selected_db + '/' + name
        Dir.mkdir selected_db + '/' + name
        File.open( selected_db + '/' + name + "/columns", "w" ) do |the_file|
          the_file.puts columns.join "|"
        end 
        File.open( selected_db + '/' + name + "/data", "w" )
        if autoincreement
          File.open( selected_db + '/' + name + "/increement", "w" ) do |file|
            file.write("0")
          end
        end
      end
    end

    def self.database name
      if !Dir.exists? name
        Dir.mkdir name
      end
    end

    def self.table_exists? tablename
      selected_db = Config.get("database.selected_db")
      if tablename.split('.').length == 2
        tablename = tablename.split('.')
        selected_db = tablename[0]
        tablename = tablename[1]
      end
      Dir.exists? selected_db + '/' + tablename
    end

    def self.database_exists? dbname
      Dir.exists? dbname
    end

    def self.drop_table tablename
      if self.table_exists? tablename
        selected_db = Config.get("database.selected_db")
        if tablename.split('.').length == 2
          tablename = tablename.split('.')
          selected_db = tablename[0]
          tablename = tablename[1]
        end
        File.open( selected_db + '/' + tablename + '/data' ,"w") do |file|
          file.write("")
        end
      end
    end
  end
  
end
