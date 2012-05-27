def reload
	load '../src/db.rb'
	load '../src/db_config.rb'
	load '../src/db_update.rb'
	load '../src/db_select.rb'
	load '../src/db_create.rb'
	load '../src/db_insert.rb'
end

reload

puts $LOADED_FEATURES

require 'irb'

IRB.start