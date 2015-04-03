FactoryGirl.define do
  factory :admin, class: User do
    login "admin"
    password "admin"
  end

  factory :not_admin_user, class: User do
    login "pepe"
    password "pepe"
  end

end
