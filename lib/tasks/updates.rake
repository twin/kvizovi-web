namespace :updates do
  desc "Generates updates"
  task :generate do
    if ENV["NAME"].nil?
      puts "Usage: rake updates:generate NAME=name_of_update"
      exit
    end

    path = "#{Rails.root}/app/views/updates/index"
    name = ENV["NAME"]
    last_id = Dir["#{path}/*.md.erb"].map { |filename| filename.split("/").last[/^\d+/].to_i }.max || 0
    id = (ENV["ID"] || last_id + 1).to_i
    filename = "#{id}_#{name}.md.erb"

    touch File.join(path, filename)
  end
end
