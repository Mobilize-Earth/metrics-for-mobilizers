require 'rails_helper'

RSpec.describe User, type: :model do

  it 'should render full name for user with first and last name' do
    @user = User.create({ password: 'admin1', email: 'admin@test.com', role: 'admin', first_name: "Admin", last_name: "Istrator" })

    expect(@user.full_name).to include "Admin Istrator"
  end
end
