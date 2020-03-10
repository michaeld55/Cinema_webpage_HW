require_relative("../db/sqlrunner.rb")
require_relative("film.rb")
require_relative("ticket.rb")
require_relative("screening.rb")

class Customer

  attr_reader( :id )
  attr_accessor( :name, :funds )

  def initialize( options )

    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @funds = options["funds"].to_i()

  end

  def save()

    sql = "INSERT INTO customers
    (
      name, funds
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run( sql, values ).first()
    @id = customer['id'].to_i

  end

  def update
    sql = "UPDATE customers SET name = $1, funds = $2 WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run( sql, values )
  end

  def films
    sql ="SELECT * FROM films
           INNER JOIN screenings
           ON screenings.film_id = (films.id)
           INNER JOIN tickets
           ON tickets.screening_id = (screenings.id)
           INNER JOIN customers
           ON tickets.customer_id = (customers.id)
           WHERE customer_id = $1"
   values = [@id]
   films = SqlRunner.run( sql,values )
   return films = films.map {|film| Film.new( film )}

  end

  def ticket_number

    sql = "SELECT tickets.customer_id FROM tickets
           WHERE customer_id = $1"
    values = [@id]
    tickets = SqlRunner.run( sql, values )
    tickets = tickets.map{|ticket| ticket["customer_id"]}
    return tickets.size()

  end

  def self.buy_ticket( screening, customer )

    film = Film.find_by_id( screening.film_id)
    cost = film.price
    if screening.available_tickets > 0
        screening.available_tickets -= 1
        Screening.update_available_tickets( screening )
        @funds = customer.funds - cost
        customer.update()
        puts "There are #{screening.available_tickets} tickets left for #{film.title}"
        return true
      else
        puts "No tickets for #{film.title}"
        return false
    end

  end

  def self.find_by_id( id )

    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    customer = SqlRunner.run( sql, values ).first
    customer = Customer.new( customer )
    return customer

  end

  def self.find_all()

    sql = "SELECT * FROM customers"
    customers = SqlRunner.run( sql )
    return customers = customers.map { |customer| Customer.new( customer ) }
  end

  def self.delete_all()

    sql = "DELETE FROM customers"
    SqlRunner.run( sql )

  end

end
