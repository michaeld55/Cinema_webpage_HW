require("sinatra")
require("sinatra/contrib/all") if development?
require_relative("models/film.rb")
also_reload("models/*")

get("/films") do
  @films = Film.find_all
  erb(:index)
end

get("/films/:id") do
  @film = Film.find_by_id( params[:id].to_i )
  erb(:films)
end

# get("/home")do
# @films = []
#   films = Film.find_all
#   for film in films
#     @films << film.title
#   end
#   "The films are#{@films}"
# end
