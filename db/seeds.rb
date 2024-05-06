User.find_or_create_by!(
  email: ENV['MAILER_EMAIL']
) do |user|
  user.password = ENV['ADMIN_PASSWORD']
  user.password_confirmation = ENV['ADMIN_PASSWORD']
  user.role = 'admin'
  user.name = 'Ed'
end
