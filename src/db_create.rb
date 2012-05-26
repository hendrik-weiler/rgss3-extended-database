module DB
  class Create
    def self.table name,columns,autoincreement
      if !Dir.exists? 'Database/' + name
        Dir.mkdir 'Database/' + name
        File.open( 'Database/' + name + "/columns", "w" ) do |the_file|
          the_file.puts columns.join "|"
        end 
        File.open( 'Database/' + name + "/data", "w" )
        if autoincreement
          File.open( 'Database/' + name + "/increement", "w" ) do |file|
            file.write("0")
          end
        end
      end
    end
  end
  
end
