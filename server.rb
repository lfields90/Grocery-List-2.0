require 'sinatra'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: "grocery_list")
    yield(connection)
  ensure
    connection.close
  end
end

def list
  db_connection { |conn| conn.exec("SELECT name, amount FROM groceries ORDER BY id;") }
end

get '/' do
  redirect '/groceries'
end

get '/groceries' do
  erb :index, locals: { list: list }
end

post "/groceries" do

  name = params['item']
  amount = params['number']

  redirect '/groceries' if name == ""
  amount = 1 if amount == ""

  db_connection { |conn| conn.exec("INSERT INTO groceries (name, amount) VALUES ($1, $2)", [name, amount]) }

  redirect '/groceries'
 end
