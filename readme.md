## RPG MAKER VX ACE Extended Database

This script will give the vx ace real database support.

So it will comes with:
* Basic CRUD
* Tables with Auto-Increement
* Advanced search with ==,<=,>=,<,>,!=,*=(is_included?)
* Sort ASC, DESC

### Examples

<pre>
// Create a table
// ---------------------
// First param = tablename
// Second param = table columns
// Third param = primary key have auto increement?
DB::Create.table "persons",["id:primary","last_name","first_name","age"],true

// Insert a row into a table
// ---------------------
// First param = tablename
// Second param = row content (primary key should have just an empty string)
DB::Insert.new "persons",["","Weiler","Hendrik"]

// Select some rows
// ---------------------
// First param = tablename
// Second param = whether row primary id, hash or "all"
// Third param = optional, you do "column asc" or "column desc" 
// ---------------------
// will return an array of elements
DB::Select.find "persons", {"last_name" => "Weiler"}
// will return the specific element
DB::Select.find "persons", 2
// will return an array of elements
DB::Select.find "persons", "all"
// will return an array of elements in descending order
DB::Select.find "persons", {"last_name" => "Weiler"},"last_name desc"

// Editing rows
// ---------------------
myrow = DB::Select.find "persons", 2
myrow.last_name = "Power"
myrow.first_name = "Max"
// use the save method to edit the row
myrow.save
// use the delete method to delete the row
myrow.delete
</pre>

### Testing

If you want to test the script use the terminal.rb file inside the test directory.
The requirement is that you have to have ruby installed.