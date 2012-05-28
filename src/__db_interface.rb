module DB_Interface
	def self.find table, selector, order
		raise NotImplementedError.new
	end

	def self.insert table, data_array
		raise NotImplementedError.new
	end

	def self.create_table name, column_array, auto_increement
		raise NotImplementedError.new
	end

	def self.create_database name
		raise NotImplementedError.new
	end
end