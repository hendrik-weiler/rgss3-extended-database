## RPG MAKER VX ACE Extended Database

This script will give the vx ace real database support.

##### So it will come with:
* Basic CRUD
* Tables with Auto-Increement
* Advanced search with ==,<=,>=,<,>,!=,*=(is_included?)
* Sort ASC, DESC
* Multiple databases
* ini parser

### Examples

```ruby
# Create a table
# ---------------------
# First param = tablename
# Second param = table columns
# Third param = primary key have auto increement?
DB::Create.table "persons",["id:primary","last_name","first_name","age"],true

# Insert a row into a table
# ---------------------
# First param = tablename
# Second param = row content (primary key should have just an empty string)
DB::Insert.new "persons",["","Weiler","Hendrik"]

# Select some rows
# ---------------------
# First param = tablename
# Second param = whether row primary id, hash or "all"
# Third param = optional, you do "column asc" or "column desc" 
# ---------------------
# will return an array of elements
DB::Select.find "persons", {"last_name" => "Weiler"}
# will return the specific element
DB::Select.find "persons", 2
# will return an array of elements
DB::Select.find "persons", "all"
# will return an array of elements in descending order
DB::Select.find "persons", {"last_name" => "Weiler"},"last_name desc"
DB::Select.find "persons", {"age" => ">=20"},"last_name desc"
DB::Select.find "persons", {"age" => ">20"},"last_name desc"
DB::Select.find "persons", {"age" => "<=20"},"last_name desc"
DB::Select.find "persons", {"age" => "<20"},"last_name desc"
DB::Select.find "persons", {"age" => "!=Weiler"},"last_name desc"
DB::Select.find "persons", {"age" => "*=ler"},"last_name desc"

# Editing rows
# ---------------------
myrow = DB::Select.find "persons", 2
myrow.last_name = "Power"
myrow.first_name = "Max"
# use the save method to edit the row
myrow.save
# use the delete method to delete the row
myrow.delete

# Set global variables in rpg maker
myrow = DB::Select.find "persons", 2
# first param : var number, second param: value
DB.set_var 0, myrow.last_name
# Set all column values into global variables in rpg maker
myrow = DB::Select.find "persons", 2
# first param : starting point, second param: result obj
DB.set_var_row 0, myrow
# now variable 0,1,2 are filled with the row values

# using configs class ini parser 
value = DB::Config.get "groupname.variable"
value2 = DB::Config.get "variable"
# setting configs a new
DB::Config.set "variable","some value"
```

#### Using multiple databases
```ruby
# create a database
DB::Create.database "some_database_name"

# select that database
DB::Config.set "database.selected_db","some_database_name"
```

Now everything will be will be executed in "some_database_name" database.

### Testing

If you want to test the script use the terminal.rb file inside the test directory.
The requirement is that you have to have ruby installed.