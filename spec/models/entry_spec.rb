require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe "validations" do
    it { should validate_presence_of :occurred_on }
    it { should validate_presence_of :budget_sheet }
    it { should validate_numericality_of :amount }
    it { should_not allow_value(-1).for :amount }
  end

  describe "associations" do
    it { should belong_to :category }
    it { should belong_to :budget_sheet }
  end
end
