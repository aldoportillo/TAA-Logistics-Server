User.find_or_create_by!(
  email: 'admin@example.com'
) do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = 'admin'
  user.name = 'Admin'
end
