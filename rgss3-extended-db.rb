
=begin
 RPG MAKER VX ACE Extended Database
 Copyright (C) 2012  Hendrik Weiler

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

 @author     Hendrik Weiler
 @license    http://www.gnu.org/licenses/gpl.html
 @copyright  2012 Hendrik Weiler
=end
module DB
	def self.version
		1.00
	end

	def self.set_var num, value
		$game_variables[num] = value
	end

	def self.set_var_row num_start, obj
		obj.get_columns.each do |col|
			$game_variables[num_start] = obj.instance_variable_get('@' + col)
			num_start += 1
		end
	end

	def self.set_sw num, value
		$game_switches[num] = value
	end
end
module DB
  class Config
  	@configfile = "rgss3edb.conf"
  	@@config = {}

  	def self.parse file
  		@variables = {}
  		content = File.read(@configfile)
  		current_group = false
  		content.split("\n").each do |line|
  			if /\[(.*)\]/i.match(line)
  				name = line.gsub("[","").gsub("]","")
  				@variables[name] = {}
  				current_group = name
  			else
  				if line == ''
  					current_group = false
  					next
  				end
  				if(current_group != false)
  					data = line.split("=")
  					@variables[current_group][data[0].strip] = data[1].strip
  				else
					data = line.split("=")
  					@variables[data[0].strip] = data[1].strip
  				end
  			end
  		end
  		@variables
  	end

  	def self.read
  		if !File.exists? @configfile
  			File.open(@configfile,"w") do |file|
  				file.write(
  					"[database]\n" +
  					"selected_db = Database"
  				)
  			end
  		end
  		@@config = self.parse @configfile
  		if !Dir.exists? get("database.selected_db")
  			Dir.mkdir( get("database.selected_db") )
  		end
  	end

  	def self.init
  		read
  		@@config
  	end

  	def self.get selector
  		selecting = @variables
  		data = selector.split(".")
  		depth = data.length
  		if depth == 1
  			@variables[data[0]]
  		end
  		if depth == 2
  			@variables[data[0]][data[1]]
  		end
  	end

  	def self.set key, value
  		data = key.split(".")
  		depth = data.length
  		if depth == 1
  			@variables[data[0]] = value
  		end
  		if depth == 2
  			@variables[data[0]][data[1]] = value
  		end
  	end
  end
  Config.init
end
module DB
  class Create
    def self.table name,columns,autoincreement
      selected_db = DB::Config.get("database.selected_db")
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
          data_content << values.join("|")
          data.write( data_content.join "\n" )
        }
      end
    end
    
  end
  
end

module DB
  class Select
    def self.find table, selector, sort="id none"
      
      @sort = sort
      @table = table
      @columns = File.read(DB::Config.get("database.selected_db") + '/' + table + '/columns').split("\n")[0].split('|')
      @records = []
      File.read(DB::Config.get("database.selected_db") + '/' + table + '/data').split("\n").each_with_index do |value,line|
        @records << { :data => value, :line => line }
      end
      @primary_col = "none";
      cols = File.read( DB::Config.get("database.selected_db") + '/' + table + "/columns")
      cols.split("|").each_with_index do |col,index|
        if col.include? ":primary"
          @primary_col = index
        end
      end
      
      if selector == 'all'
        return self.get_all_records
      end
      if selector.is_a? Integer
        return self.return_update_obj (self.get_record_by_id selector)
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
      Update.new @table, line, @records[line], @primary_col
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

module DB
  class Update
    
    def initialize table,line,data,primary_col
      f = File.read(DB::Config.get("database.selected_db") + '/' + table + '/columns') 
      @table = table
      @line = line
      @columns = f.split("\n")[0].split("|")
      @columns.delete_at @columns.length
      @columns[primary_col] = @columns[primary_col].gsub(":primary","")
      @values = data[:data].split("|")
      @columns.each_with_index do |value,key|
        self.class.__send__(:attr_accessor, value)
        self.__send__(value + "=", @values[key])
      end
      self
    end

    def get_columns
      @columns
    end
    
    def save
      new_values = []
      @values.each_with_index do |value,key|
        new_values << instance_variable_get('@' + @columns[key]).encode('UTF-8')
      end
      
      current_data = File.read(DB::Config.get("database.selected_db") + '/' + @table + '/data')
      current_data = current_data.split "\n"
      
      current_data[@line] = new_values.join "|"
      
      File.open(DB::Config.get("database.selected_db") + '/' + @table + '/data',"w") do |the_file|
        the_file.write(current_data.join("\n"))
      end
    end
    
    def delete
      current_data = File.read(DB::Config.get("database.selected_db") + '/' + @table + '/data')
      current_data = current_data.split "\n"

      current_data.delete_at(@line)
      
      File.open(DB::Config.get("database.selected_db") + '/' + @table + '/data',"w") do |the_file|
        the_file.write(current_data.join("\n"))
      end
    end
  end
  
end
