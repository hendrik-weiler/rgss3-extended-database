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

	def self.drop_table tablename
		raise NotImplementedError.new
	end

	def self.table_exists? tablename
		raise NotImplementedError.new
	end

	def self.database_exists? dbname
		raise NotImplementedError.new
	end

	def self.set_var number, value
		raise NotImplementedError.new
	end

	def self.get_var number
		raise NotImplementedError.new
	end

	def self.set_var_row start_number, obj
		raise NotImplementedError.new
	end

	def self.set_sw number, value
		raise NotImplementedError.new
	end

	def self.set_config expr, value
		raise NotImplementedError.new
	end

	def self.get_config expr
		raise NotImplementedError.new
	end
end