ActiveRecord::Base.transaction do
  require 'csv'

  User.destroy_all
  Place.destroy_all
  Location.destroy_all
  Like.destroy_all

  CSV.foreach("db/places_seeds.csv", headers: true) do |line|
    Place.create! line.to_hash.except(*%w{type latitude longitude})
  end

  locations = [
    { city: "Greenville", state: "SC", country: "USA" },
    { city: "Chicago", state: "IL", country: "USA" },
    { city: "Miami", state: "FL", country: "USA" },
    { city: "Tokyo", state: "", country: "Japan" },
    { city: "Dallas", state: "TX", country: "USA" },
    { city: "Boston", state: "MA", country: "USA" },
    { city: "New York", state: "NY", country: "USA" },
    { city: "Munich", state: "", country: "Germany" },
    { city: "Barcelona", state: "", country: "Spain" },
    { city: "London", state: "", country: "England" },
    { city: "Nashville", state: "TN", country: "USA" },
    { city: "Dallas", state: "TX", country: "USA" },
    { city: "Portland", state: "OR", country: "USA" }
  ]

  50.times do
    user = User.create({
      email: Faker::Internet.email,
      name: Faker::Name.name,
      password: Faker::Internet.password
    })

    3.times do
      location = locations.sample
      Location.create(
        city: location[:city],
        state: location[:state],
        country: location[:country],
        user: user
      )
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
