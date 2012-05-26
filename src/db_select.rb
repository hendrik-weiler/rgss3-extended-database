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
