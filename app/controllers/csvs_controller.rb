class CsvsController < ApplicationController
  def index
    respond_to do |format|
      format.csv { send_data Mobilization.to_csv, filename: "mobilization-#{Date.today}.csv" }
    end
  end
end
