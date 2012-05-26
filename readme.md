## RPG MAKER VX ACE Extended Database

This script will give the vx ace real database support.

<strong>Note: Its still in development, so its not finished</strong>

So it will comes with:
* Basic CRUD
* Tables with Auto-Increement
* Advanced search with ==,<=,>=,!=,~=(is_included?)
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
// First param = tablename
// Second param = row content (primary key should have just an empty string)
DB::Insert.new "test",["","Weiler","Hendrik"]
</pre>