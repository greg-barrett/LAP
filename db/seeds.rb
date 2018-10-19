# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Reserver.destroy_all
Reservation.destroy_all
@ken= Reserver.create(
  title: "Mr",
  first_name: "Ken",
  last_name: "Jobbs",
  id_type: "Passport",
  id_number: "87537e7",
  contact_number: "+446679685985",
  email_address: "kjobbs@gmail.com",
  email_address_confirmation: "kjobbs@gmail.com",
  house_number: "12",
  street_name: "New Street",
  city: "Manchester",
  country: "UK",
  postcode: "WF20FG"
)
@clare= Reserver.create(
  title: "Mrs",
  first_name: "Clare",
  last_name: "Jones",
  id_type: "Passport",
  id_number: "7845896587",
  contact_number: "+4454654",
  email_address: "cjones@gmail.com",
  email_address_confirmation: "cjones@gmail.com",
  house_number: "1200",
  street_name: "Elbery Road",
  city: "Paris",
  country: "France",
  postcode: "784589"
)

@helen=Reserver.create(
  title: "Miss",
  first_name: "Helen",
  last_name: "Smiles",
  id_type: "Passport",
  id_number: "7845745587",
  contact_number: "+44546547878",
  email_address: "hsmiles@gmail.com",
  email_address_confirmation: "hsmiles@gmail.com",
  house_number: "4a",
  street_name: "Happy Street",
  city: "London",
  country: "UK",
  postcode: "LS5 3EW"
)
Reservation.create(
               arrival_date: Date.today+6,
               departure_date: Date.today+13,
               confirmed: true,
               fee: 50.5,
               party_size: 6,
               notes: "Do you havea teapot?",
               reserver_id: @ken.id,
               reservation_number: "LAP10")

Reservation.create(
               arrival_date: Date.today+14,
               departure_date: Date.today+21,
               confirmed: true,
               fee: 70.5,
               party_size: 2,
               notes: "Can I bring a dog",
               reserver_id: @clare.id,
               reservation_number: "LAP15")

Reservation.create(
               arrival_date: Date.today+35,
               departure_date: Date.today+42,
               confirmed: true,
               fee: 70.5,
               party_size: 3,
               notes: "Can't wait",
               reserver_id: @helen.id,
               reservation_number: "LAP20")
