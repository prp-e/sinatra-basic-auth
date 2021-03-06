require 'sinatra' 
require 'mongoid'

configure do 
 Mongoid.load!("./database.yml")
end

enable :sessions 

class User 
 include Mongoid::Document
 field :username, type: String
 field :password, type: String
end

helpers do
 def login?
  if session[:username].nil?
   return false
  else
   return true
  end
 end

 def username
  return session[:username]
 end
end

get '/' do 
 if session[:username].nil?
  erb :login_req
 else
  erb :index
 end
end

get '/login' do
 erb :login
end

post '/' do
 begin
   User.find_by(params[:user])
   session[:username] = params[:user][:username]
   redirect to("/")
 rescue
   redirect to("/incorrect")
 end
end

get '/incorrect' do
 erb :incorrect
end

get '/logout' do
 session[:username] = nil
 redirect to("/")
end

get '/signup' do
 erb :signup
end

get '/signup_error' do
 erb :signup_notmatch
end

get '/users' do 
 @users = User.all
 if session[:username].nil?
  erb :login_req
 else
  erb :users
 end
end

post '/welcome' do
 begin 
  params[:user][:password] == params[:user][:password_again]
  user = User.create(:username => params[:user][:username], :password => params[:user][:password])
  redirect to("/welcome")
 rescue
  redirect to("/signup_error")
 end
end

get '/welcome' do
 erb :welcome
end
