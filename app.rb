require_relative 'couchdb'
require 'sinatra'
require 'json'

# cloudant
db = CouchDB.get(ENV)

# create view
CouchDB.create_view(db, 'todos', "function(doc){if(doc.title && doc.completed != null){emit(doc.order,{title: doc.title,completed: doc.completed})}}", "_count")

# get all items
get '/api/todos' do
  content_type :json

  db.view('todos/todos', {reduce: false} )['rows'].to_a.map{|t| Todo.to_client(t)}.to_json
end

# get single item
get '/api/todos/:id' do
  content_type :json
  db.get(params[:id]).to_json
end

# create an item
post '/api/todos' do
  content_type :json

  item = Todo.create(request)
  db.save_doc(item)

  status 200
end

# update an item
put '/api/todos/:id' do
  content_type :json

  item = Todo.create(request)

  current = db.get(params[:id])
  current['completed'] = item['completed'] ?  true : false

  db.save_doc(current)

  status 201
end

# delete an item
delete '/api/todos/:id' do
  db.delete_doc(db.get(params[:id]))
  status 200
end

# main page
get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

class Todo

  def self.create(req)
    item = JSON.parse(req.body.read.to_s)
    if item['completed'] == nil
      item['completed'] = false
    end
    item['created_at'] = Time.now
    item
  end

  def self.to_client(obj)
      obj['value'].merge({'id' => obj['id'], 'order' => obj['key']})
  end
end

