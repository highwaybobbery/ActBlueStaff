require 'rails_helper'

describe Candidate do
  describe 'name' do
    it 'must be unique' do
      create(:candidate, name: 'Joe')
      new_candidate = Candidate.new(name: 'Joe')
      expect(new_candidate).to be_invalid
      expect(new_candidate.errors.messages).to eq({ name: ['has already been taken']})
    end

    it 'must be present' do
      candidate = Candidate.new(name: '')
      expect(candidate).to be_invalid
      expect(candidate.errors.messages).to eq({ name: ["can't be blank"]})
    end
  end

end
