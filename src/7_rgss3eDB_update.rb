module RGSS3EDB
  class Update
    attr_accessor :current_db
    
    def initialize table,line,data,primary_col,database
      @current_db = database
      f = File.read(@current_db + '/' + table + '/columns') 
      @table = table
      @line = line
      @columns = f.split("\n")[0].split("|")
      @columns.delete_at @columns.length
      @columns[primary_col] = @columns[primary_col].gsub(":primary","") if primary_col.is_a? Integer
      @values = data[:data].split("|")
      @columns.each_with_index do |value,key|
        self.class.__send__(:attr_accessor, value)
        @values[key] = "" if @values[key].nil?
        self.__send__(value + "=", @values[key].split('<br>').join("\n"))
      end
      self
    end

    def get_columns
      @columns
    end

    def set_column name, value
        @columns << name
        self.class.__send__(:attr_accessor, name)
        self.__send__(name + "=", value.split('<br>').join("\n"))
    end
    
    def save
      new_values = []
      @values.each_with_index do |value,key|
        new_values << instance_variable_get('@' + @columns[key]).encode('UTF-8')
      end
      
      current_data = File.read(@current_db + '/' + @table + '/data')
      current_data = current_data.split "\n"
      
      current_data[@line] = new_values.join "|"
      
      File.open(@current_db + '/' + @table + '/data',"w") do |the_file|
        the_file.write(current_data.join("\n"))
      end
    end
    
    def delete
      current_data = File.read(@current_db + '/' + @table + '/data')
      current_data = current_data.split "\n"

      current_data.delete_at(@line)
      
      File.open(@current_db + '/' + @table + '/data',"w") do |the_file|
        the_file.write(current_data.join("\n"))
      end
    end
  end
  
end
