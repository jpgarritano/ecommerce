class JsonWebToken
  def self.encode(user)
    JWT.encode({ id: user.id, exp: 7.days.from_now.to_i }, SECRET_KEY)
  end

  def self.decode(request)
    JWT.decode(request.headers['Authorization'].split(' ')[1], SECRET_KEY).first
  end
end
