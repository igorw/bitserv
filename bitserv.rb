require 'bundler'
Bundler.setup
require 'sinatra'
require 'grit'
require 'bluecloth'
require 'haml'
require 'sass'
require 'coderay'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

set :haml, {attr_wrapper: '"'}

$config = YAML.load_file('application.yml')
$repo = Grit::Repo.new($config['repo_path'])

def parse_page(page)
  blob = $repo.head.commit.tree/page
  if blob.nil?
    raise Sinatra::NotFound
  end
  BlueCloth.new(blob.data).to_html
end

def render_page(page)
  @title = page
  @content = parse_page(page)
  haml :page
end

not_found do
  @title = 'page not found'
  haml :not_found
end

get '/' do
  render_page 'index'
end

get '/pages' do
  @title = "pages"
  @tree = $repo.head.commit.tree
  haml :pages
end

# history diff
get %r{/h/(.*)/([0-9a-f]{40})} do |page, id|
  @title = "history diff of #{page}"
  @page = page
  @commit = $repo.commit(id)
  @diffs = @commit.diffs
  
  haml :history_diff
end

# history
get '/h/*' do
  page = params[:splat].first
  
  @title = "history of #{page}"
  @page = page
  @commits = $repo.log($repo.head.commit.id, page)
  
  haml :history
end

# page
get '/*' do
  @page = params[:splat].first
  render_page @page
end
