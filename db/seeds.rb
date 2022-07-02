ActiveRecord::Base.transaction do
  require 'csv'

  User.destroy_all
  Place.destroy_all
  Location.destroy_all
  Like.destroy_all

  CSV.foreach('db/places_seeds.csv', headers: true) do |line|
    Place.create! line.to_hash.except(*%w[type latitude longitude])
  end

  locations = [
    { city: 'Greenville', state: 'SC', country: 'US' },
    { city: 'Chicago', state: 'IL', country: 'US' },
    { city: 'Miami', state: 'FL', country: 'US' },
    { city: 'Tokyo', state: '', country: 'JP' },
    { city: 'Dallas', state: 'TX', country: 'US' },
    { city: 'Boston', state: 'MA', country: 'US' },
    { city: 'New York', state: 'NY', country: 'US' },
    { city: 'Munich', state: '', country: 'DE' },
    { city: 'Barcelona', state: '', country: 'ES' },
    { city: 'London', state: '', country: 'GB' },
    { city: 'Nashville', state: 'TN', country: 'US' },
    { city: 'Dallas', state: 'TX', country: 'US' },
    { city: 'Portland', state: 'OR', country: 'US' }
  ]

  100.times do
    user = User.create({
                         email: Faker::Internet.email,
                         name: Faker::Name.name,
                         password: Faker::Internet.password
                       })

    3.times do
      location = locations.sample
      new_location = Location.create(
        city: location[:city],
        state: location[:state],
        country: location[:country]
      )
      user.locations << new_location
    end

    10.times do
      place = Place.all.sample
      Like.create(
        user: user,
        place: place
      )
    end
  end
end
