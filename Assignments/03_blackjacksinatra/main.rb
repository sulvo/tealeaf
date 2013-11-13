require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

## ROUTES

get('/') do
	"Hello world, it's #{Time.now.strftime("%H:%M%p, %A %d %B %Y")}"
end

get('/template') do
	erb :template
end

get('/template/nested') do
	erb :'/templates/nested'
end

get('/form') do
	erb :'/templates/form'
end

post '/form001' do
	@user = params['user']
	@class = params['class']
	binding.pry
end
