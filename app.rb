require 'sinatra'
require 'sinatra/reloader'
also_reload 'lib/**/*.rb'
require 'pry'
require "pg"
require './lib/project'
require './lib/volunteer'

DB = PG.connect({ dbname: 'projects', host: 'db', user: 'postgres', password: 'password' })

get '/' do
  @projects = Project.all
  erb(:projects)
end

get('/projects') do
  @projects = Project.all
  erb(:projects)
end

delete('/projects') do
  Project.clear
  redirect to('/projects')
end

get('/trains/user') do
  @trains = Train.all
  erb(:user_trains)
end

get('/trains/:id/destination') do
  @train = Train.find(params[:id].to_i())
  erb(:user_destinations)
end

get('/trains/new') do
  erb(:new_train)
end

post('/trains') do
  name = params[:train_name]
  train = Train.new(name: name)
  train.save()
  @trains = Train.all
  erb(:trains)
end

get('/trains/:id') do
  @train = Train.find(params[:id].to_i())
  erb(:train)
end

get('/trains/:id/edit') do
  @train = Train.find(params[:id].to_i())
  erb(:edit_train)
end

patch('/trains/:id') do
  @train = Train.find(params[:id].to_i())
  @train.update({name: params[:name]})
  @trains = Train.all
  erb(:trains)
end

delete('/trains/:id') do
  @train = Train.find(params[:id].to_i)
  @train.delete()
  @trains = Train.all
  erb(:trains)
end

get('/trains/:id/cities/:city_id') do
  @city = City.find(params[:city_id].to_i())
  erb(:city)
end

post('/trains/:id/cities') do
  @train = Train.find(params[:id].to_i())
  city = City.new({name: params[:city_name]})
  city.save()
  @train.update(city_name: city.name)
  erb(:train)
end

get('/cities') do
  @cities = City.all
  erb(:cities)
end

get('/cities/user') do
  @cities = City.all
  erb(:user_cities)
end

delete('/cities') do
  City.clear
  redirect to('/cities')
end

get('/cities/:id') do
  @city = City.find(params[:id].to_i)
  erb(:city)
end

get('/cities/:id/user') do
  @city = City.find(params[:id].to_i)
  erb(:user_city)
end

patch('/cities/:id') do
  city = City.find(params[:id].to_i())
  city.update({name: params[:name]})
  @cities = City.all
  erb(:cities)
end

delete('/cities/:id') do
  city = City.find(params[:id].to_i())
  city.delete
  @cities = City.all
  erb(:cities)
end
