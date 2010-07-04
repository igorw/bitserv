require 'bundler'
Bundler.setup
require 'sinatra'
require 'grit'
require 'bluecloth'
require 'haml'
require 'sass'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

set :haml, {attr_wrapper: '"'}

$config = YAML.load_file('application.yml')
$repo = Grit::Repo.new($config['repo_path'])

def parse_page(page)
  blob = $repo.heads.first.commit.tree/page
  BlueCloth.new(blob.data).to_html
end

def render_page(page)
  @title = page
  @content = parse_page(page)
  haml :page
end

get '/' do
  render_page 'index'
end

get '/*' do
  # splat is an array
  page = params[:splat][0]
  render_page page
end
