module DB
  class Insert
    def initialize table,values
      if Dir.exists? 'Database/' + table
        File.open('Database/' + table + '/data', 'a') { |data|
          f = File.read('Database/' + table + '/columns') 
          columns = f.split "|"
          columns.each_with_index do |value,key|
            if value.include?(":primary")
              inc = File.open('Database/' + table + '/increement','r')
              inc = inc.read.to_i
              inc = inc+=1
              values[key] = inc
              File.open('Database/' + table + '/increement', 'w') { |inc_file| 
                inc_file.write(inc) 
              }
            end
          end
          data.puts values.join("|")
        }
      end
    end
    
  end
  
end
