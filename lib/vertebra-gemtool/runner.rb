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

require 'rubygems'
require 'vertebra-gemtool/actor'

begin
  require 'vertebra/base_runner'
rescue LoadError
  puts "Please install the vertebra gems."
  exit
end

begin
  require 'thor'
rescue LoadError
  puts "Please install the thor gem."
  exit
end

# TODO: There should be a way to stub out runners using the information in actor.rb.

module Vertebra
  class VGem < BaseRunner
  
    @@global_method_options = {:node => :optional, :cluster => :required, :only_nodes => :boolean, :slice => :optional}

    inherit_from_actor(VertebraGemtool::Actor)

    describe_from_actor(:list)
    def list(opts = {})
      gems = broadcast('list', '/gem', opts)
      gems.each { |host, gems| puts "\n#{host}";puts "---"; puts gems.is_a?(Array) ? gems.join("\n") : gems }
    end

    desc "install <gem_name>", "Install a gem"
    all_method_options

    def install(gem_name, opts = {})
      result = broadcast('install', '/gem', opts.merge(:name => gem_name))
      puts result.inspect
    end

  end
end
