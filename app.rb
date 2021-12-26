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

get('/projects/new') do
  erb(:new_project)
end

post('/projects') do
  name = params[:project_name]
  project = Project.new(name: name)
  project.save()
  @projects = Project.all
  erb(:projects)
end

get('/projects/:id') do
  @project = Project.find(params[:id].to_i())
  erb(:project)
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i())
  erb(:edit_project)
end

patch('/projects/:id') do
  @project = Project.find(params[:id].to_i())
  @project.update({name: params[:name]})
  @projects = Project.all
  erb(:projects)
end

delete('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @project.delete()
  @projects = Project.all
  erb(:projects)
end

get('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:city_id].to_i())
  erb(:volunteers)
end

post('/projects/:id/volunteers') do
  @project = Project.find(params[:id].to_i())
  volunteer = Volunteer.new({name: params[:volunteer_name]})
  volunteer.save()
  @project.update(volunteer_name: volunteer.name)
  erb(:project)
end
