require_relative("../db/sqlrunner.rb")
require_relative("film.rb")
require_relative("ticket.rb")

class Film

  attr_reader( :id )
  attr_accessor( :title, :price )

  def initialize( options )

    @id = options["id"].to_i if options["id"].to_i
    @title = options["title"]
    @price = options["price"].to_i()

  end

  def save()

    sql = "INSERT INTO films
    (
      title, price
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run( sql, values ).first()
    @id = film['id'].to_i

  end

  def popular_time()

    sql = "SELECT screening_id, COUNT (*)
           FROM tickets
           INNER JOIN screenings
           ON screening_id = (screenings.id)
           INNER JOIN films
           ON film_id = (films.id)
           WHERE film_id = $1
           GROUP BY screening_id"
    values = [@id]
    screenings = SqlRunner.run( sql, values )
    screenings = screenings.map { |screening| {"number" => screening["count"].to_i, "id" => screening["screening_id"].to_i}}
    screenings = screenings.max_by(){ |screening| screening["number"]}
    if screenings != nil
      popular_time = Screening.find_by_id( screenings["id"])
      return "The most popular time for #{@title} is #{popular_time.show_time}"
    else
      return "There are no tickets for #{@title}"
    end

  end

  def update

    sql = "UPDATE films SET title = $1, price = $2 WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run( sql, values )

  end

  def customers

    sql ="SELECT * FROM customers
          INNER JOIN tickets
          ON tickets.customer_id = customers.id
          INNER JOIN screenings
          ON tickets.screening_id = (screenings.id)
          INNER JOIN films
          ON film_id = (films.id)
          WHERE customers.id = $1"
    values = [@id]
    customers = SqlRunner.run( sql,values )
    return customers = customers.map {|customer| Customer.new( customer )}

  end

  def ticket_number

    sql = "SELECT tickets.film_id FROM tickets
           WHERE film_id = $1"
    values = [@id]
    tickets = SqlRunner.run( sql, values )
    tickets = tickets.map{|ticket| ticket["film_id"]}
    return tickets.size()

  end

  def self.find_by_id( id )

    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    film = SqlRunner.run( sql, values ).first
    return film = Film.new( film )
  end

  def self.find_all()

    sql = "SELECT * FROM films"
    films = SqlRunner.run( sql )
    return films = films.map { |film| Film.new( film ) }

  end

  def self.delete_all()

    sql = "DELETE FROM films"
    SqlRunner.run( sql )

  end

end
