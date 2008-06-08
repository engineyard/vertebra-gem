require 'vertebra/actor'

module Vertebra
  module Actors
    class Gem  < ::Vertebra::Actor
      
      provides '/gem'
      register_with_agent

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
end