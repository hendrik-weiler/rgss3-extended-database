module DB
  class Insert
    def initialize table,values
      selected_db = DB::Config.get("database.selected_db")
      if Dir.exists? selected_db + '/' + table
        data_content = File.read(selected_db + '/' + table + '/data').split("\n")
        File.open(selected_db + '/' + table + '/data', 'w') { |data|
          f = File.read(selected_db + '/' + table + '/columns') 
          columns = f.split "|"
          columns.each_with_index do |value,key|
            if value.include?(":primary")
              inc = File.open(selected_db + '/' + table + '/increement','r')
              inc = inc.read.to_i
              inc = inc+=1
              values[key] = inc
              File.open(selected_db + '/' + table + '/increement', 'w') { |inc_file| 
                inc_file.write(inc) 
              }
            end
          end
          values.each_with_index do |value,key|
            values[key] = value.split("\n").join('<br>') if value.is_a? String
          end 
          data_content << values.join("|")
          data.write( data_content.join "\n" )
        }
      end
    end
    
  end
  
end
