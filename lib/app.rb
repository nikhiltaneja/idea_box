require 'idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  not_found do
    erb :error
  end
  
  configure :development do 
    register Sinatra::Reloader
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new, search_results: []}
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post '/:id/up' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.up_vote!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  post '/:id/down' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.down_vote!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/sms' do
    title, description = params[:Body].split(", ")
    attributes = {"title" => title, "description" => description}
    idea = Idea.new(attributes)
    idea.save
    redirect '/' 
  end

  get '/search' do
    search_results = IdeaStore.find_ideas(params[:search])
    erb :search, locals: {search_results: search_results}
  end

end
