require '../src/db_update'
require '../src/db_select'
require '../src/db_create'
require '../src/db_insert'

puts $LOADED_FEATURES
require 'irb'

IRB.start