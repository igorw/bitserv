require 'bundler'
Bundler.setup
require 'sinatra'
require 'grit'
require 'bluecloth'
require 'haml'
require 'sass'

set :haml, {attr_wrapper: '"'}

config = YAML.load_file('application.yml')

repo = Grit::Repo.new(config['repo_path'])

get '/:page' do
  page = params[:page]
  blob = repo.heads.first.commit.tree/(page + '.md')
  @body = BlueCloth.new(blob.data).to_html
  
  haml :index
end
