require 'bundler'
Bundler.setup
require 'sinatra'
require 'grit'
require 'bluecloth'
require 'haml'
require 'sass'

repo_path = '.'

set :haml, {attr_wrapper: '"'}

repo = Grit::Repo.new(repo_path)

get '/:page' do
  page = params[:page]
  blob = repo.heads.first.commit.tree/(page + '.md')
  @body = BlueCloth.new(blob.data).to_html
  
  haml :index
end
