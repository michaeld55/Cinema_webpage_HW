require_relative("../db/sqlrunner")
require_relative("film")
require_relative("customer")

class Ticket

  attr_reader( :id )
  attr_accessor( :customer_id, :screening_id )
  def initialize( options )

    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @screening_id = options['screening_id'].to_i

  end

  def save()

      sql = "INSERT INTO tickets
      (
        customer_id,
        screening_id
      )
      VALUES
      (
        $1, $2
      )
      RETURNING id"
      values = [@customer_id, @screening_id]
      ticket = SqlRunner.run( sql, values ).first()
      @id = ticket['id'].to_i

  end

  # def customers
  #
  #   sql= "SELECT * FROM customers WHERE customers.id = $1"
  #   values = [@customer_id]
  #   customer = SqlRunner.run( sql, values ).first
  #   return Customer.new( customer )
  #
  # end
  #
  # def films
  #
  #   sql = "SELECT * FROM films WHERE films.id = $1"
  #   values = [@film_id]
  #   film = SqlRunner.run( sql,values ).first
  #   return Film.new( film )
  #
  # end

  def update

  sql = "UPDATE tickets SET customer_id = $1, screening_id = $2 WHERE id = $3"
  values = [@customer_id, @screening_id, @id]
  SqlRunner.run( sql, values )

  end

  def self.all()

    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run( sql )
    return tickets = tickets.map { |ticket| Ticket.new( ticket ) }

  end

  def self.delete_all()

    sql = "DELETE FROM tickets"
    SqlRunner.run( sql )

  end

end
