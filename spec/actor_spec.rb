require File.dirname(__FILE__) + '/spec_helper'

describe VertebraGemtool do
  
  before(:each) do
    @options = {'name' => 'orderedhash'}
    @actor = VertebraGemtool::Actor.new(@options)
  end
  
  it "should install a gem" do
    @actor.install(@options)
    # should we install a gem or not?
  end
end