require 'bundler'
Bundler.setup
require 'sinatra'
require 'grit'
require 'bluecloth'
require 'haml'
require 'sass'

set :haml, {attr_wrapper: '"'}

config = YAML.load_file('application.yml')

@@repo = Grit::Repo.new(config['repo_path'])

def render_page(page)
  blob = @@repo.heads.first.commit.tree/page
  @content = BlueCloth.new(blob.data).to_html
  
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
