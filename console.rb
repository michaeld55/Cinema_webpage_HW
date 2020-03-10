require_relative( "db/sqlrunner.rb" )
require_relative( "models/customer.rb" )
require_relative( "models/film.rb" )
require_relative( "models/ticket.rb" )
require_relative( "models/screening.rb" )

require( "pry-byebug" )

Ticket.delete_all()
Screening.delete_all()
Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({ "name" => "Bob McJoe", "funds" => 2000})
customer2 = Customer.new({ "name" => "Joe McBob", "funds" => 3000})
customer3 = Customer.new({ "name" => "Tim McTam", "funds" => 3000})
customer1.save()
customer2.save()
customer3.save()

# customer1.name = "Joe McBob"
# customer1.update()


film1 = Film.new({ "title" => "Big Movie", "price" => 20})
film2 = Film.new({ "title" => "Small Movie", "price" => 30})
film1.save()
film2.save()

# film1.title = "Small Movie"
# film1.update()
screening1 = Screening.new({ "show_time" => "18:00", "film_id" => film1.id(), "available_tickets" => 1 })
screening2 = Screening.new({ "show_time" => "19:00", "film_id" => film1.id(), "available_tickets" => 50 })
screening3 = Screening.new({ "show_time" => "16:00", "film_id" => film2.id(), "available_tickets" => 50 })
screening4 = Screening.new({ "show_time" => "18:00", "film_id" => film2.id(), "available_tickets" => 50 })


screening1.save()
screening2.save()
screening3.save()
screening4.save()

# screening1.show_time = "15:00"
# screening1.update

ticket1 = Ticket.new({ "customer_id" => customer1.id(), "screening_id" => screening1.id() })
ticket2 = Ticket.new({ "customer_id" => customer2.id(), "screening_id" => screening2.id() })
ticket3 = Ticket.new({ "customer_id" => customer1.id(), "screening_id" => screening2.id() })
ticket4 = Ticket.new({ "customer_id" => customer1.id(), "screening_id" => screening2.id() })
ticket5 = Ticket.new({ "customer_id" => customer3.id(), "screening_id" => screening1.id() })

if Customer.buy_ticket( screening1, customer1) == true
  ticket1.save()
end
if Customer.buy_ticket( screening2, customer2) == true
  ticket2.save()
end
if Customer.buy_ticket( screening2, customer1) == true
  ticket3.save()
end
if Customer.buy_ticket( screening2, customer1) == true
ticket4.save()
end
if Customer.buy_ticket( screening1, customer3) == true
  ticket5.save()
end
# ticket1.customer_id = customer2.id
# ticket1.update()



binding.pry()
nil
