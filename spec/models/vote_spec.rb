require 'rails_helper'

describe Vote do
  describe 'validation' do
    let(:user) { create(:user) }
    let(:candidate) { create(:candidate) }

    context 'when the user has already voted' do
      let!(:existing_vote) { create(:vote, user: user, candidate: candidate) }

      it 'the user cannot create another vote' do
        vote = Vote.new(user: user, candidate: candidate)
        expect(vote).to be_invalid
        expect(vote.errors.messages).to eq({ user: ['has already been taken']})
      end
    end

    context 'when the user does not exist' do
      it 'is an invalid vote' do
        vote = Vote.new(user_id: 9, candidate: candidate)
        expect(vote).to be_invalid
        expect(vote.errors.messages).to eq({ user: ['must exist']})
      end
    end

    context 'when the candidate does not exist' do
      it 'is an invalid vote' do
        vote = Vote.new(user: user, candidate_id: 9)
        expect(vote).to be_invalid
        expect(vote.errors.messages).to eq({ candidate: ['must exist']})
      end
    end

    context 'when candidate is nil' do
      it 'is an invalid vote' do
        vote = Vote.new(user: user, candidate: nil)
        expect(vote).to be_invalid
        expect(vote.errors.messages).to eq({ candidate: ['must exist']})
      end
    end

    context 'when user is nil' do
      it 'is an invalid vote' do
        vote = Vote.new(user: nil, candidate: candidate)
        expect(vote).to be_invalid
        expect(vote.errors.messages).to eq({ user: ['must exist']})
      end
    end
  end
end
