require File.dirname(__FILE__) + '/spec_helper'
require 'vertebra-gemtool/actor'

describe VertebraGemtool do
  
  if Process.uid != 0
    puts "Please run these tests as root."
    exit
  end
     
  before(:each) do
    @options = {'name' => 'vertebra-testgem'}
    @actor = VertebraGemtool::Actor.new(@options)
  end

  it "should install a gem" do
      `gem uninstall orderedhash -I`
      lambda { @actor.install(@options) }.should_not raise_error
      `gem list orderedhash`.should match(/orderedhash/)        
  end

  it "should uninstall a gem" do
      `gem install orderedhash --no-rdoc --no-ri`
      lambda { @actor.uninstall(@options) }.should_not raise_error
      `gem list orderedhash`.should_not match(/orderedhash/)        
      `gem install orderedhash --no-rdoc --no-ri`
  end

end