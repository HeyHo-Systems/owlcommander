# frozen_string_literal: true

class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    mail = super

    Rails.logger.debug record.inspect
    if record.created_at > 1.minute.ago && record.creator.present? && record.accounts.first.present?
      mail.subject = "#{record.creator.name} invited you to join the #{record.accounts.first.name} team in owl commander"
      mail.reply_to = record.creator.email
    end

    mail
  end
end
