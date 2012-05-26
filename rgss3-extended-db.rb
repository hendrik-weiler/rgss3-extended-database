
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

module DB
  class Select
    def self.find table, selector
      
      @table = table
      @records = File.read('Database/' + table + '/data').split "\n"
      @primary_col = "none";
      cols = File.read( 'Database/' + name + "/columns")
      cols.split("|").each_with_index do |col,index|
        if col.include? ":primary"
          @primary_col = index
        end
      end
      
      if selector == 'all'
        
      end
      if selector.is_a? Integer
        return self.return_update_obj (self.get_record_by_id selector)
      end
      if selector.is_a? Hash
        
      end
    end
    
    def self.return_update_obj line
      Select.new @table, line, @records[line]
    end
    
    def self.get_all_records
      
    end
    
    def self.get_record_by_hash searchhash
      
    end
    
    def self.get_record_by_id id_number
      return false if @primary_col == 'none'
      
      @records.each_with_index do |row,index|
        items = row.split "|"
        if items[@primary_col].include? id_number
          return index
        end
      end
      
      return false
    end
  end
  
end

module DB
  class Update
    
    def initialize table,line,data
      f = File.read('Database/' + table + '/columns') 
      @line = line
      @columns = f.split "|"
      @values = data.split("|")
      @values.each_with_index do |value,key|
        instance_variable_set('@' + @columns[key],value)
      end
    end
    
    def save
      new_values = []
      @values.each_with_index do |value,key|
        new_values << instance_variable_get('@' + @columns[key])
      end
      
      current_data = File.read('Database/' + table + '/data')
      current_data = current_data.split "\n"
      
      current_data[@line] = new_values.join "|"
      
      File.open('Database/' + table + '/data',"w") do |the_file|
        the_file.write(current_data.join("\n"))
      end
    end
    
    def delete
      current_data = File.read('Database/' + table + '/data')
      current_data = current_data.split "\n"
      
      current_data.delete_at(@line)
      
      File.open('Database/' + table + '/data',"w") do |the_file|
        the_file.write(current_data.join("\n"))
      end
    end
  end
  
end
