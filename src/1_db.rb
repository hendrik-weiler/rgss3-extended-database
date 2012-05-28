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
	def self.find table, selector, order=false
		order = 'id none' if !order
		RGSS3EDB::Select.find table, selector, order
	end

	def self.insert table, data_array
		RGSS3EDB::Insert.new table, data_array
	end

	def self.create_table name, column_array, auto_increement=false
		RGSS3EDB::Create.table name, column_array, auto_increement
	end

	def self.create_database name
		RGSS3EDB::Create.database name
	end

	def self.set_var number, value
		RGSS3EDB.set_var number,value
	end

	def self.set_var_obj start_number, obj
		RGSS3EDB.set_var_obj start_number,obj
	end

	def self.set_sw number, value
		RGSS3EDB.set_sw number, value
	end

	def self.set_config expr, value
		RGSS3EDB::Config.set expr, value
	end

	def self.get_config expr
		RGSS3EDB::Config.get expr
	end
end