module VertebraGemtool
  class Actor  < ::Vertebra::Actor
    
    provides '/gem'

    def list(args = {})
      filter = args['filter'] || nil
      ::Gem.source_index.refresh!.search(filter).flatten.collect {|gemspec| "#{gemspec.name} #{gemspec.version}" }
    end
          
    def install(args = {})
      str = args['name']
      str << "-#{args['version']}" if args['version']
      `gem install #{str}`
    end
  end
end