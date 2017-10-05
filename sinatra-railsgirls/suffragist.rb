require 'sinatra'
require 'yaml/store'

# Have some choices in a global variable.
# global variables are accessible to the erbs
Choices = {
    'HAM' => 'Hamburger',
    'PIZ' => 'Pizza',
    'CUR' => 'Curry',
    'NOO' => 'Noodles',
  }

# Create a root route
get '/' do
  # instace variable @title is storing the page title
  # this variable is set only when the '/' route is instantiated.
  # @instance variable contents are avilable to the erbs.
  @title = 'Welcome to the Suffragist!'

  # call the index and pass the @Choices parameter
  erb :index
end


post '/cast' do
  @title = 'Thanks for casting your vote!'

  @vote  = params['vote']
  puts @vote
  puts Choices[@vote]

  # Instantiate a yaml store.
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
    # crete a hash
    @store['votes'] ||= {}
    # if no data make @vote = 0
    @store['votes'][@vote] ||= 0
    # don't understand this code very much
    # seems like it is incrementing the value
    @store['votes'][@vote] += 1
  end


  erb :cast
end


get '/results' do
  @title = 'Results so far:'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
end