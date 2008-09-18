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
