require 'thor'

  module VertebraGemtool
  class Actor < Thor
    
    RESOURCES = ['/gem']

    def initialize(opts = {}, *args)
      super
    end
    
    desc "list", "Get a list of gems"
    method_options :filter => :optional
    
    def list(args = {})
      filter = args['filter'] || nil
      ::Gem.source_index.refresh!.search(filter).flatten.collect {|gemspec| "#{gemspec.name} #{gemspec.version}"}
    end
    
    desc "install <gem_name>", "Install a gem"
    method_options :name => :required
          
    def install(args = {})
      str = args['name']
      str << "-#{args['version']}" if args['version']
      `gem install #{str}`
    end

    desc "uninstall <gem_name>", "Install a gem"
    method_options :name => :required

    def uninstall(args = {})
      str = args['name']
      str << "-#{args['version']}" if args['version']
      `gem uninstall #{str}`
    end

    desc "reinstall <gem_name>", "Install a gem"
    method_options :name => :required

    def reinstall(args = {})
      uninstall_output = uninstall('name' => args['name'])
      install_output = install('name' => args['name'])
      uninstall_output + install_output
    end

  end
end