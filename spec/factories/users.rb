FactoryGirl.define do
  factory :admin, class: User do
    login "admin"
    password "admin"
  end

end
