# frozen_string_literal: true

module FormHelper
  def twilio_accounts_for_select
    return [] if current_account.blank?

    policy_scope(current_account.twilio_accounts)
      .includes(:account)
      .order(:name)
      .pluck(:name, :id)
      .map { |name, id| [id.to_s, name] }
  end

  def item_limit(pagy = nil)
    return Pagy::DEFAULT[:items] unless pagy

    pagy.items
  end
end
