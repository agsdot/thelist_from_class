namespace :list do

desc "update the concert list"

  task :update_shows => :environment do

      Show.destroy_all

      s = InputShowData.new
      s.input_arrays


  end

end