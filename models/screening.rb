require_relative("customer.rb")

class Screening
  attr_accessor( :show_time, :film_id, :available_tickets )
  attr_reader( :id )

  def initialize( options )

    @id = options['id'].to_i if options['id']
    @show_time = options['show_time']
    @film_id = options['film_id'].to_i
    @available_tickets = options['available_tickets'].to_i

  end

  def save()

    sql = "INSERT INTO screenings
    (
      show_time, film_id, available_tickets
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING *"
    values = [@show_time, @film_id, @available_tickets]
    screening = SqlRunner.run( sql, values ).first()
    @id = screening['id'].to_i


  end

  def update

    sql = "UPDATE screenings SET show_time = $1, film_id = $2, available_tickets = $3 WHERE id = $4"
    values = [@show_time, @film_id, @available_tickets, @id]
    SqlRunner.run( sql, values )

  end

  def self.update_available_tickets( screening )

    sql = "UPDATE screenings SET show_time = $1, film_id = $2, available_tickets = $3 WHERE id = $4"
    values = [screening.show_time, screening.film_id, screening.available_tickets, screening.id]
    SqlRunner.run( sql, values )
    # puts screening.available_tickets
    # @available_tickets = screening.available_tickets
    # puts @available_tickets
  end

  def self.find_by_id( id )

    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [id]
    screening = SqlRunner.run( sql, values ).first
    return screening = Screening.new( screening )

  end
  #
  # def self.find_by_film_id( id )
  #
  #   sql = "SELECT * FROM screenings WHERE film_id = $1"
  #   values = [id]
  #   screening = SqlRunner.run( sql, values ).first
  #   return screening = Screening.new( screening )
  #
  # end

  def self.all()

    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run( sql )
    return screenings = screenings.map { |screening| Screening.new( screening ) }

  end

  def self.delete_all()

    sql = "DELETE FROM screenings"
    SqlRunner.run( sql )

  end

end
