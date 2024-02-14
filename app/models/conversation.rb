# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :twilio_account
  include SearchCop
  scope :search_twilio_account_id, ->(id) { where(twilio_account_id: id) }

  search_scope :search_any do
    attributes :sid,
               :account_sid,
               :friendly_name,
               :state,
               :date_created,
               :messages_content
    attributes account: 'twilio_account.name'
  end

  def self.search(terms)
    all.then do |scope|
      scope = scope.search_any(terms.search_all) if terms.search_all.present?
      scope = scope.search_twilio_account_id(terms.twilio_account_id) if terms.twilio_account_id.present?
      scope
    end
  end

  def self.upsert_from_twilio(item, twilio_account)
    Rails.logger.debug item.attributes.inspect
    # new messages don't change the "date_updated" of a conversation. You need to pull messages to see if there's a change

    conversation = where(sid: item.sid, twilio_account_id: twilio_account.id).first_or_initialize
    messages = pull_messages(item, twilio_account)

    return :no_change if conversation.date_updated == item.date_updated && conversation.messages_count == messages[:messages_count]

    conversation.update!(extract_attributes(item).merge(messages))

    :changed
  end

  def self.extract_attributes(item)
    {
      account_sid: item.account_sid,
      friendly_name: item.friendly_name,
      chat_service_sid: item.chat_service_sid,
      messaging_service_sid: item.messaging_service_sid,
      unique_name: item.unique_name,
      state: item.state,
      date_created: item.date_created,
      date_updated: item.date_updated,
      date_inactive: item.timers[:date_inactive],
      date_closed: item.timers[:date_closed],
      twilio_attributes: JSON.parse(item.attributes)
    }
  end

  def self.pull_messages(item, twilio_account)
    messages_list = twilio_account.client.conversations.v1.conversations(item.sid).messages
                                  .list(limit: 100)
                                  .map { |m| { author: m.author, time: m.date_created, body: m.body } }
    messages_content = messages_list.map { |m| "#{m[:author]} #{m[:body]}" }.join(' ')
    { messages_list:,
      messages_content:,
      messages_count: messages_list.count }
  end
end
