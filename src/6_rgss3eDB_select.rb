module RGSS3EDB
  class Select
    def self.find table, selector, sort="id none"
      
      @sort = sort
      @selected_db = Config.get "database.selected_db"
      if table.split('.').length == 2
        table = table.split('.')
        @selected_db = table[0]
        @table = table[1]
      else
        @table = table
      end
      @columns = File.read(@selected_db + '/' + @table + '/columns').split("\n")[0].split('|')
      @records = []
      File.read(@selected_db + '/' + @table + '/data').split("\n").each_with_index do |value,line|
        @records << { :data => value, :line => line }
      end
      @primary_col = "none";
      cols = File.read( @selected_db + '/' + @table + "/columns")
      cols.split("|").each_with_index do |col,index|
        if col.include? ":primary"
          @primary_col = index
        end
      end
      
      if selector == 'all'
        return self.get_all_records
      end
      if selector.is_a? Array
        result = []
        selector.each do |id|
          record = self.get_record_by_id(id.to_i)
          result << self.return_update_obj(record) if record != false
        end
        return result
      end
      if selector.is_a? Integer
        return self.return_update_obj (self.get_record_by_id(selector.to_i))
      end
      if selector.is_a? Hash
        return self.get_record_by_hash selector
      end
    end

    def self.get_sort_data
      sort_data = @sort.split " "
      col_number = 0;
      @columns.each_with_index do |col,key| 
        if col.include? sort_data[0]
          col_number = key
        end
      end
      { :column => col_number, :type => sort_data[1] }
    end

    def self.sort_records records, to_obj=false

      data = self.get_sort_data
      order_values = []
      records.each do |row|
        order_values << { :id => row[:data].split("|")[data[:column]].to_i, :line => row[:line] }
      end

      if data[:type].downcase == 'desc'
        order_values = order_values.sort_by {|x| -x[:id] }
      end
      if data[:type].downcase == 'asc'
        order_values = order_values.sort_by { |h| h[:id] }
      end

      sorted_values = []
      order_values.each do |row|
        if to_obj
          sorted_values << self.return_update_obj(row[:line])
        else
          sorted_values << row[:line]
        end
      end
        sorted_values
    end
    
    def self.return_update_obj line
      Update.new @table, line, @records[line], @primary_col, @selected_db
    end
    
    def self.get_all_records
      sorted = self.sort_records @records
      rows = []
      sorted.each do |line|
        rows << self.return_update_obj(line)
      end
      rows
    end
    
    def self.get_record_by_hash searchhash
      result = []
      @records.each do |row|

        rowObj = self.return_update_obj row[:line]
        condition_true = 0;
        searchhash.each do |key,value|

          objValue = rowObj.instance_variable_get("@#{key}")

          if value.include? ">="
            testval = value.gsub ">=",""
            if objValue.to_i >= testval.to_i
              condition_true += 1
            end
          else
            if value.include? ">"
              testval = value.gsub ">",""
              if objValue.to_i > testval.to_i
                condition_true += 1
              end
            end
          end

          if value.include? "<="
            testval = value.gsub "<=",""
            if objValue.to_i <= testval.to_i
              condition_true += 1
            end
          else
            if value.include? "<"
              testval = value.gsub "<",""
              if objValue.to_i < testval.to_i
                condition_true += 1
              end
            end
          end
          if value.include? "!="
            testval = value.gsub "!=",""
            if objValue != testval
              condition_true += 1
            end
          end
          if value.include? "*="
            testval = value.gsub "*=",""
            if objValue.include? testval
              condition_true += 1
            end
          end
          if objValue == value
            condition_true += 1
          end

        end

        if searchhash.length == condition_true
          result << row
        end
      end

      self.sort_records result, true
    end
    
    def self.get_record_by_id id_number
      return false if @primary_col == 'none'
      @records.each do |row|
        items = row[:data].split "|"
        if items[@primary_col].to_i == id_number
          return row[:line]
        end
      end

      return false
    end
  end
  
end
