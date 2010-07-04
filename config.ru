require './bitserv'
require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :expanded

use Sass::Plugin::Rack
run Sinatra::Application
