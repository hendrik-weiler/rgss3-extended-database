module RGSS3EDB
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