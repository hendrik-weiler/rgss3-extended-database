module RGSS3EDB
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