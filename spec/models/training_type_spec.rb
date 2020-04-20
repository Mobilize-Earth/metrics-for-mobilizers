require 'rails_helper'

RSpec.describe TrainingType, type: :model do
  describe 'when name is saved' do

    before :each do
      @training_type = TrainingType.new
    end

    it 'should take strings' do
      @training_type.name = "Hello World"
      @training_type.valid?
      expect(@training_type.errors[:name]).to be_empty
    end

    it 'should not take duplicate names' do
      TrainingType.create!(name: "Hello World")

      @training_type.name = "Hello World"
      @training_type.valid?
      expect(@training_type.errors[:name]).to include('training type name has already been taken')
    end
  end
end
