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
    { city: "Greenville", state: "SC", country: "United States" },
    { city: "Chicago", state: "IL", country: "United States" },
    { city: "Miami", state: "FL", country: "United States" },
    { city: "Tokyo", state: "", country: "Japan" },
    { city: "Dallas", state: "TX", country: "United States" },
    { city: "Boston", state: "MA", country: "United States" },
    { city: "New York", state: "NY", country: "United States" },
    { city: "Munich", state: "", country: "Germany" },
    { city: "Barcelona", state: "", country: "Spain" },
    { city: "London", state: "", country: "England" },
    { city: "Nashville", state: "TN", country: "United States" },
    { city: "Dallas", state: "TX", country: "United States" },
    { city: "Portland", state: "OR", country: "United States" }
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
