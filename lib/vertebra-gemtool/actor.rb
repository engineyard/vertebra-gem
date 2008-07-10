module VertebraGemtool
  class Actor < Thor
    
    RESOURCES = ['/gem']

    def initialize(opts, *args)
      super
    end
    
    def list(args = {})
      filter = args['filter'] || nil
      ::Gem.source_index.refresh!.search(filter).flatten.collect {|gemspec| "#{gemspec.name} #{gemspec.version}"}
    end
          
    def install(args = {})
      str = args['name']
      str << "-#{args['version']}" if args['version']
      `gem install #{str}`
    end

    def remove(args = {})
      str = args['name']
      str << "-#{args['version']}" if args['version']
      `gem uninstall #{str}`
    end

  end
end