# Copyright 2008, Engine Yard, Inc.
#
# This file is part of Vertebra.
#
# Vertebra is free software: you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# Vertebra is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Vertebra.  If not, see <http://www.gnu.org/licenses/>.

require File.dirname(__FILE__) + '/spec_helper'
#require 'vertebra'
require 'vertebra-gemtool/actor'

class Vertebra::Actor
  def spawn(*args, &block)
    out = File.read(File.dirname(__FILE__) + "/fixtures/#{args[0]+args[1]}.txt")
    out = yield(out) if block_given?
    {:result => out}
  end
end

describe VertebraGemtool::Actor do
  
  before(:all) do
    @actor = VertebraGemtool::Actor.new
  end
  
  it 'should provide /core resource' do
    @actor.provides.should == [Vertebra::Resource.new('/gem')]
  end

  it 'should parse and return hashed gem list' do
    result = @actor.list
    result[:result].keys.size.should == 150
  end

  it 'should set proper arguments for gem install' do
    mock(@actor).spawn(["gem", "install", "test", "--no-rdoc", "--no-ri"])
    @actor.install({'name' => 'test'})
  end
  
  it 'should set proper arguments for gem install with version' do
    mock(@actor).spawn(["gem", "install", "test", "-v", "1.2.3", "--no-rdoc", "--no-ri"])
    @actor.install({'name' => 'test', 'version' => '1.2.3'})
  end

  it 'should set proper arguments for gem uninstall' do
    mock(@actor).spawn("gem", "uninstall", "test-1.2.3")
    @actor.uninstall({'name' => 'test', 'version' => '1.2.3'})
  end

  it 'should set proper arguments for adding gems source URL' do
    mock(@actor).spawn("gem", "source", "-a", "http://test")
    @actor.add_source_url({'source_url' => 'http://test'})    
  end

  it 'should set proper arguments for removing gems source URL' do
    mock(@actor).spawn("gem", "source", "-r", "http://test")
    @actor.remove_source_url({'source_url' => 'http://test'})    
  end

  it 'should list sources' do
    puts @actor.list_sources.should == {:result => ["http://gems.rubyforge.org", "http://gems.github.com"]}
  end
end
