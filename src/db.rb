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
		1.1
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