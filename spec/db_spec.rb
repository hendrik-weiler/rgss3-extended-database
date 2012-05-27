require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../src/db'

describe "DB" do
  it "should show the right version" do
    DB::version == 1.1
  end
end