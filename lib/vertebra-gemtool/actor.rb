require 'rubygems'
require 'thor'

  module VertebraGemtool
  class Actor < Thor
    
    RESOURCES = ['/gem']
    
    desc "list", "Get a list of gems"
    method_options :filter => :optional
    
    def list(options = {})
      filter = options['filter'] || nil
      ::Gem.source_index.refresh!.search(filter).flatten.collect {|gemspec| "#{gemspec.name} #{gemspec.version}"}
    end
    
    desc "install", "Install a gem"
    method_options :name => :required
          
    def install(options = {})
      str = options['name']
      str << "-#{options['version']}" if options['version']
      shell "gem install #{str} --no-rdoc --no-ri"
    end

    desc "uninstall", "Install a gem"
    method_options :name => :required

    def uninstall(options = {})
      str = options['name']
      str << "-#{options['version']}" if options['version']
      shell "gem uninstall #{str}"
    end

    desc "reinstall", "Install a gem"
    method_options :name => :required

    def reinstall(options = {})
      uninstall_output = uninstall('name' => options['name'])
      install_output = install('name' => options['name'])
      uninstall_output + install_output
    end

    desc "add_source_url", "Add a rubygems source URL"
    method_options :source_url => :required

    def add_source_url(options = {})
      shell "gem source -a #{options['source_url']}"
    end

    desc "remove_source_url", "Remove a rubygems source URL"
    method_options :source_url => :required

    def remove_source_url(options = {})
      shell "gem source -r #{options['source_url']}"
    end

    desc "list_sources", "List rubygem sources"

    def remove_source_url(options = {})
      shell "gem source -l".chomp.split("\n").reject { |s| s !~ /^http/ }
    end

  end
end