# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence :rsa_key do |n|
    rsa_key = OpenSSL::PKey::RSA.new(1024)
    key = rsa_key.public_key.to_pem
    key.gsub!("-----BEGIN PUBLIC KEY-----","")
    key.gsub!("-----END PUBLIC KEY-----","")
    key = key.split("\n").join("")
  end

  factory :key do
    association :user
    name { Faker::Lorem.words.join(" ").titleize }
    blob { FactoryGirl.generate(:rsa_key) }
    algorithm { "ssh-rsa" }
  end
end
