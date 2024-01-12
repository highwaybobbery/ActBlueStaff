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

  describe 'maximum candidates validation' do
    it 'allows up to 10 candidates' do
      10.times do
        expect(create(:candidate)).to be_valid
      end

      next_candidate = build(:candidate)
      expect{ next_candidate.save }.not_to change { Candidate.count }.from(10)

      expect(next_candidate.errors.messages).to eq({ base: ['exceeded maximum entries']})
    end
  end
end
