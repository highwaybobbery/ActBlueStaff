require 'rails_helper'

describe SessionManager do
  let(:user) { create(:user, logged_in_at: logged_in_at) }
  let(:logged_in_at) { nil }
  let(:session_user_id_key) { described_class::SESSION_USER_ID_KEY }

  # NOTE: This hash is used to represent the session storage
  let(:session) { Hash.new }
  subject { described_class.new(session) }

  describe '#current_user' do
    context 'with an existing session' do
      let(:session) { { user_id: user.id } }

      context 'when the user logged in recently' do
        let(:logged_in_at) { 2.minutes.ago }

        it 'finds existing user by session user_id' do
          expect(subject.current_user.id).to eq user.id
        end
      end

      context 'when the user login has expired' do
        let(:logged_in_at) { 6.minutes.ago }

        it 'does not return the user' do
          expect(subject.current_user).to be_nil
        end

        it 'clears the user_id from the session' do
          subject
          expect(session).not_to have_key(session_user_id_key)
        end
      end
    end

    context 'with a blank session' do
      let(:session) { Hash.new }
      it 'returns nil' do
        expect(subject.current_user).to be_nil
      end
    end
  end

  describe 'login_user' do
    it 'sets the user_id on the session' do
      expect { subject.login_user(user) }.to change {
        session[session_user_id_key]
      }.from(nil).to(user.id)
    end

    it 'sets logged_in_at on the user in database' do
      Timecop.freeze do
        expect { subject.login_user(user) }.to change {
          user.reload.logged_in_at
        }.from(nil).to(Time.now)
      end
    end

    it 'sets current_user' do
      expect { subject.login_user(user) }.to change {
        subject.current_user&.id
      }.from(nil).to(user.id)
    end
  end

  describe 'logout_user' do
    before do
      subject.login_user(user)
    end

    it 'unsets the user_id on the session' do
      expect { subject.logout_user }.to change {
        session[session_user_id_key]
      }.from(user.id).to(nil)
    end

    it 'unsets logged_in_at on the user in database' do
      Timecop.freeze do
        expect { subject.logout_user }.to change {
          user.reload.logged_in_at
        }.to(nil)
      end
    end

    it 'unsets current_user' do
      expect { subject.logout_user }.to change {
        subject.current_user&.id
      }.from(user.id).to(nil)
    end
  end
end
