require 'thor'
require 'pp'
require 'vertebra/actor'
require 'vertebra/extensions'

module VertebraGemtool
  class Actor < Vertebra::Actor

    provides '/gem'

    bind_op "/gem/list", :list
    desc "/gem/list", "Get a list of gems"
    method_options :filter => :optional

    def list(options = {})
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

    bind_op "/gem/install", :install
    desc "/gem/install", "Install a gem"
    method_options :name => :required

    def install(options = {})
      str = options['name']
      args = ["gem", "install", str]
      args = args + ['-v', options['version']] if options['version']
      args = args + ["--no-rdoc", "--no-ri"]
      spawn args
    end

    bind_op "/gem/uninstall", :uninstall
    desc "/gem/uninstall", "Install a gem"
    method_options :name => :required

    def uninstall(options = {})
      str = options['name']
      str << "-#{options['version']}" if options['version']
      spawn "gem", "uninstall", str
    end

    bind_op "/gem/source/add", :add_source_url
    desc "/gem/source/add", "Add a rubygems source URL"
    method_options :source_url => :required

    def add_source_url(options = {})
      spawn "gem", "source", "-a", options['source_url']
    end

    bind_op "/gem/source/remove", :remove_source_url
    desc "/gem/source/remove", "Remove a rubygems source URL"
    method_options :source_url => :required

    def remove_source_url(options = {})
      spawn "gem", "source", "-r", options['source_url']
    end

    bind_op "/gem/source/list", :list_sources
    desc "/gem/source/list", "List rubygem sources"

    def list_sources(options = {})
      spawn "gem", "source", "-l" do |output|
        output.chomp.split("\n").reject { |s| s !~ /^http/ }
      end
    end
  end
end
