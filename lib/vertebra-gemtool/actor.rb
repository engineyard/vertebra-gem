require 'thor'
require 'pp'
require 'vertebra/actor'

module VertebraGemtool
  class Actor < Vertebra::Actor
    
    provides '/gem'
        
    desc "list", "Get a list of gems"
    method_options :filter => :optional
    
    def list
      filter = options['filter'] || nil
      output = spawn "gem", "list" do |output|
        gemlist = output.chomp.split("\n").reject { |g| g =~ /^\*\*\* / || g.empty? }
        gemlist.inject({}) do |hsh, str| 
          md = str.match(/(.*)\W\((.*)\)/)
          hsh[md[1]] = md[2].split(", ")
          hsh
        end
      end
    end
    
    desc "install", "Install a gem"
    method_options :name => :required
          
    def install
      str = options['name']
      str << "-#{options['version']}" if options['version']
      spawn "gem", "install", str, "--no-rdoc", "--no-ri"
    end

    desc "uninstall", "Install a gem"
    method_options :name => :required

    def uninstall
      str = options['name']
      str << "-#{options['version']}" if options['version']
      spawn "gem", "uninstall", str
    end

    desc "reinstall", "Install a gem"
    method_options :name => :required

    def reinstall
      uninstall_output = uninstall('name' => options['name'])
      install_output = install('name' => options['name'])
      uninstall_output + install_output
    end

    desc "add_source_url", "Add a rubygems source URL"
    method_options :source_url => :required

    def add_source_url
      spawn "gem", "source", "-a", options['source_url']
    end

    desc "remove_source_url", "Remove a rubygems source URL"
    method_options :source_url => :required

    def remove_source_url
      spawn "gem", "source", "-r", options['source_url']
    end

    desc "list_sources", "List rubygem sources"
    def remove_source_url
      spawn "gem", "source", "-l" do |output|
        output.chomp.split("\n").reject { |s| s !~ /^http/ }
      end
    end
  end
end