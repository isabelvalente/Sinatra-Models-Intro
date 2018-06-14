class Post

  attr_accessor :id, :title, :body


  def self.open_connection

    conn = PG.connect( dbname: 'blog')

  end

  def self.all

    # Calling the open connection method
    conn = self.open_connection

    #Creating an SQL string
    sql = "SELECT * FROM post ORDER BY id"

    #Execute the connection with our SQL string, storing it in a variable
    # Dirty Array
    results = conn.exec(sql)

    #Cleaned  array
    posts = results.map do |tuple|

      self.hydrate tuple

    end

  end

  # Find one using the ID that'll give it when we call it
  def self.find id
    # Open connection
    conn = self.open_connection

    # SQL to find using the ID
    sql = "SELECT * FROM post WHERE id=#{ id } LIMIT 1"

    # SQL to find using the ID
    posts = conn.exec(sql)

    # Get the raw results
    post = self.hydrate posts[0]

    # Return the cleaned post
    post
  end

  def save
    conn = Post.open_connection

    # If the object that the save method is run on does NOT have an existing ID, create a new instance
    if (!self.id)
      sql = "INSERT INTO post (title, body) VALUES ('#{self.title}', '#{self.body}')"
    else
      sql = "UPDATE post SET title='#{self.title}', body='#{self.body}' WHERE id='#{self.id}'"
    end

    conn.exec(sql)


    conn.exec(sql)

  end

  # DESTROY Method
  def self.destroy id
    conn = self.open_connection

    sql = "DELETE FROM post WHERE id=#{id}"

    conn.exec(sql)
  end
  # The data we get back from the DB isn't particularly clean, so we need to create a method to clean it up before we send it to the controllers
  def self.hydrate post_data

    #Create a new instance of post
    post = Post.new

    # Assign the id, title and body properties to those that come back from the DB
    post.id = post_data['id']
    post.title = post_data['title']
    post.body = post_data['body']

    # Return the post
    post

  end
end
