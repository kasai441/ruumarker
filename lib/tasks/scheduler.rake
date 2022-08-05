# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on'
task delete_outdated: :environment do
  puts 'Deleting outdated...'
  puts Room.destroy_ten_days_old
  puts 'done.'
end
