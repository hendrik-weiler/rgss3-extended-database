def reload
	Dir.glob("../src/*.rb").each do |file|
		load '../src/' + file if !file.include? "__"
	end
	1
end

reload

puts $LOADED_FEATURES

require 'irb'

IRB.start