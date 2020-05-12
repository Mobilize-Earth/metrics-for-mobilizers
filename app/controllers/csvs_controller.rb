require 'zip'

class CsvsController < ApplicationController
  def download

    return head :method_not_allowed unless current_user.role == "admin"

    begin
      temp_file = Tempfile.new("all-data-#{Date.today}.zip")

      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        zipfile.get_output_stream("growth-activities-#{Date.today}.csv") { |f| f.puts(GrowthActivity.to_csv) }
        zipfile.get_output_stream("trainings-#{Date.today}.csv") { |f| f.puts(Training.to_csv) }
        zipfile.get_output_stream("street-swarms-#{Date.today}.csv") { |f| f.puts(StreetSwarm.to_csv) }
        zipfile.get_output_stream("arrestable-actions-#{Date.today}.csv") { |f| f.puts(ArrestableAction.to_csv) }
        zipfile.get_output_stream("social-media-blitzings-#{Date.today}.csv") { |f| f.puts(SocialMediaBlitzing.to_csv) }
        zipfile.get_output_stream("addresses-#{Date.today}.csv") { |f| f.puts(Address.to_csv) }
      end

      zip_data = File.read(temp_file.path)
      send_data zip_data, filename: "all-data-#{Date.today}.zip", type: 'application/zip'
    ensure
      temp_file.close
    end
  end
end
