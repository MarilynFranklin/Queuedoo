Fabricator(:user) do
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password "password"
  password_confirmation "password"
  confirmed_at "2012-11-15 03:17:12"
end
