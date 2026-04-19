admin = User.find_or_initialize_by(email_address: "admin@foodmapp.test")
admin.update!(
  name: "Admin Taster",
  password: "password123",
  password_confirmation: "password123",
  role: :admin
)

users = [
  {
    name: "Amina Carter",
    email_address: "amina@foodmapp.test",
    residences: [
      { city: "Greenville", state: "SC", country: "USA", latitude: 34.8526, longitude: -82.3940 },
      { city: "Chicago", state: "IL", country: "USA", latitude: 41.8781, longitude: -87.6298 }
    ]
  },
  {
    name: "Leo Alvarez",
    email_address: "leo@foodmapp.test",
    residences: [
      { city: "San Antonio", state: "TX", country: "USA", latitude: 29.4241, longitude: -98.4936 },
      { city: "Austin", state: "TX", country: "USA", latitude: 30.2672, longitude: -97.7431 }
    ]
  },
  {
    name: "Mei Tan",
    email_address: "mei@foodmapp.test",
    residences: [
      { city: "Singapore", state: "", country: "Singapore", latitude: 1.3521, longitude: 103.8198 },
      { city: "New York", state: "NY", country: "USA", latitude: 40.7128, longitude: -74.0060 }
    ]
  }
]

seed_users = users.map do |attributes|
  user = User.find_or_initialize_by(email_address: attributes[:email_address])
  user.update!(
    name: attributes[:name],
    password: "password123",
    password_confirmation: "password123",
    role: :member
  )

  user.residences.destroy_all
  attributes[:residences].each { |residence| user.residences.create!(residence) }
  user
end

venues = [
  {
    name: "The Anchorage",
    category: "Seafood",
    address: "586 Perry Ave, Greenville, SC 29611",
    phone: "(864) 412-0311",
    website: "https://theanchoragerestaurant.com",
    latitude: 34.8415,
    longitude: -82.4300
  },
  {
    name: "Verde on Smith",
    category: "Cafe",
    address: "1115 S Smith St, Charlotte, NC 28203",
    phone: "(704) 333-1800",
    website: "https://verdegreensalads.com",
    latitude: 35.2212,
    longitude: -80.8561
  },
  {
    name: "Kemuri Tatsu-Ya",
    category: "Japanese Smokehouse",
    address: "2713 E 2nd St, Austin, TX 78702",
    phone: "(512) 803-2224",
    website: "https://kemuri-tatsuya.com",
    latitude: 30.2605,
    longitude: -97.7145
  },
  {
    name: "Win Son",
    category: "Taiwanese",
    address: "159 Graham Ave, Brooklyn, NY 11206",
    phone: "(347) 466-3257",
    website: "https://www.winsonbrooklyn.com",
    latitude: 40.7089,
    longitude: -73.9424
  }
]

seed_venues = venues.map do |attributes|
  venue = Venue.find_or_initialize_by(name: attributes[:name])
  venue.update!(attributes)
  venue
end

likes = {
  "Amina Carter" => [ "The Anchorage", "Win Son" ],
  "Leo Alvarez" => [ "Kemuri Tatsu-Ya", "The Anchorage" ],
  "Mei Tan" => [ "Win Son", "Kemuri Tatsu-Ya", "Verde on Smith" ]
}

likes.each do |user_name, venue_names|
  user = User.find_by!(name: user_name)
  venue_names.each do |venue_name|
    venue = Venue.find_by!(name: venue_name)
    Like.find_or_create_by!(user:, venue:)
  end
end

Like.find_or_create_by!(user: admin, venue: seed_venues.first)
