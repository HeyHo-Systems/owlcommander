# frozen_string_literal: true

class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: :index # rubocop:disable Rails/LexicallyScopedActionFilter
  after_action :verify_policy_scoped, only: :index # rubocop:disable Rails/LexicallyScopedActionFilter
end
