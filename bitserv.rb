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

def parse_page(page, ignore_missing = false)
  blob = $repo.head.commit.tree/page
  if blob.nil?
    if ignore_missing
      return
    end
    raise Sinatra::NotFound
  end
  output = BlueCloth.new(blob.data).to_html
  output.gsub!(/\[([a-zA-Z0-9_\/]+)\]/) do
    '<a href="/' + $1 + '">' + $1 + '</a>'
  end
  output
end

def render_page(page)
  @page = page
  @title = page
  @content = parse_page(page)
  haml :page
end

not_found do
  @title = 'page not found'
  haml :not_found
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
  @diffs = @commit.diffs.select do |diff|
    diff.a_path == page || diff.b_path == page
  end
  
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

# index redirect
get '/index' do
  redirect '/'
end

# index page
get '/' do
  render_page 'index'
end

# page
get '/*' do
  page = params[:splat].first
  render_page page
end
