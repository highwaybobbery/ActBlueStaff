require 'rails_helper'

describe User do
  describe 'email_address' do
    it 'must be unique' do
      user = create(:user, email: 'test@nullmailer.com')
      new_user = User.new(email: 'test@nullmailer.com')
      expect(new_user).to be_invalid
      expect(new_user.errors.messages).to eq({ email: ['has already been taken']})
    end

    it 'must be a valid email address' do
      user = User.new(email: 'notanemail.com')
      expect(user).to be_invalid
      expect(user.errors.messages).to eq({ email: ['is invalid']})
    end

    it 'must be present' do
      user = User.new(email: nil)
      expect(user).to be_invalid
      expect(user.errors.messages).to eq({ email: ['is invalid']})
    end
  end

  describe 'zipcode' do
    it 'can be blank' do
      expect(build(:user, email: 'test@nullmailer.com', zipcode: '')).to be_valid
    end

    it 'can be 5 digits' do
      expect(build(:user, email: 'test@nullmailer.com', zipcode: '12345')).to be_valid
    end

    it 'cannot be 6 digits' do
      user = User.new(email: 'test@nullmailer.com', zipcode: '123456')
      expect(user).to be_invalid
      expect(user.errors.messages).to eq({ zipcode: ['must be 5 digits']})
    end

    it 'cannot have have letters' do
      user = User.new(email: 'test@nullmailer.com', zipcode: '1234Q')
      expect(user).to be_invalid
      expect(user.errors.messages).to eq({ zipcode: ['must be 5 digits']})
    end
  end
end
