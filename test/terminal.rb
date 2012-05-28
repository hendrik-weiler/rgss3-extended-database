def reload
	Dir.glob("../src/*.rb").each do |file|
		load '../src/' + file if !file.include? "__"
	end
	1
end

def edbtemplate name, situation, items
  if DB.table_exists? "npc_messages"
    template = DB.find "npc_messages",{"name" => name,"situation" => situation},'order asc'
    message = ''
    items.each do |item|
      lines = template[0].text.split("\n")
      while lines.length != 4
        lines << ""
      end
      message += lines.join("\n")
    end
    $game_message = Game_Message.new
    $game_message.face_name = message.face_name
    $game_message.face_index = message.face_index.to_i
    $game_message.add(message)
  end
end

reload

puts $LOADED_FEATURES

require 'irb'

IRB.start