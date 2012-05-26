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
