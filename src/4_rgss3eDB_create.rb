module RGSS3EDB
  class Create
    def self.table name,columns,autoincreement
      selected_db = Config.get("database.selected_db")
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
  end
  
end
