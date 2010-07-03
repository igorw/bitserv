require 'bundler'
Bundler.setup
require 'sinatra'
require 'grit'
require 'bluecloth'

repo = Grit::Repo.new('.')

get '/:page' do
  page = params[:page]
  blob = repo.heads.first.commit.tree/page
  BlueCloth.new(blob.data).to_html
end
