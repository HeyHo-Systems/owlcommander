# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Numbers' do
  describe 'GET /index' do
    context 'without a current user' do
      let(:account_with_user) { create(:account_with_user) }

      it 'redirects to login page' do
        get account_numbers_path(account_with_user.account)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'with a normal user' do
      let(:account_with_user) { create(:account_with_user) }

      before do
        sign_in account_with_user.user
      end

      it 'is a normal user' do
        expect(account_with_user.user).not_to be_superuser
      end

      it 'renders index' do
        get account_numbers_path(account_with_user.account)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with a superuser' do
      let(:account_with_user) { create(:account_with_user, :superuser) }

      before do
        sign_in account_with_user.user
      end

      it 'is a superuser' do
        expect(account_with_user.user).to be_superuser
      end

      it 'renders index' do
        get account_numbers_path(account_with_user.account)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with multiple accounts' do
      let(:account_with_user) { create(:account_with_user, :superuser, :twilio_account) }
      let(:user) { account_with_user.user }
      let(:other_account_with_user) { create(:account_with_user, :twilio_account, user:) }
      let!(:number) { create(:number, twilio_account: account_with_user.twilio_accounts.first) }
      let!(:other_number) { create(:number, twilio_account: other_account_with_user.twilio_accounts.first) }

      before do
        sign_in user
      end

      it 'is a superuser' do
        expect(account_with_user.user).to be_superuser
      end

      it 'only shows numbers from first account' do
        get account_numbers_path(account_with_user.account)
        expect(response.body).to include(number.sid)
          .and not_include(other_number.sid)
      end
    end
  end
end
