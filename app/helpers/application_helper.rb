# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def heading(content, tag: 'h1', size: nil)
    content_tag tag, class: "#{size || default_size(tag)} font-bold leading-tight text-gray-900 py-8" do
      content
    end
  end

  def direction_icon(direction, **opts)
    case direction
    when 'inbound' then image_tag('inbound.svg', **opts)
    when 'outbound' then image_tag('outbound.svg', **opts)
    end
  end

  def duration_in_words(seconds)
    return "#{seconds}s" if seconds < 60

    minutes = seconds / 60
    seconds %= 60
    return "#{minutes}m #{seconds}s" if minutes < 60

    hours = minutes / 60
    minutes %= 60

    "#{hours}h #{minutes}m #{seconds}s" if minutes < 60
  end

  def field_errors(errors)
    return if errors.blank?

    content_tag :span, errors.to_sentence, class: 'text-sm text-red-400'
  end

  def status_color(status)
    return 'bg-red-200 text-red-600' if %w[no-answer failed busy canceled].include?(status)
    return 'bg-sky-200 text-sky-600' if %w[ringing in-progress].include?(status)
    return 'bg-yellow-200 text-yellow-600' if %w[queued].include?(status)
    return 'bg-green-200 text-green-600' if %w[completed].include?(status)

    'bg-gray-200 text-gray-600'
  end

  private

  def default_size(tag)
    case tag.to_s
    when 'h1' then 'text-3xl'
    when 'h2' then 'text-2xl'
    when 'h3' then 'text-xl'
    else 'text-lg'
    end
  end

  def format_date(datetime)
    return '' if datetime.nil?

    datetime.in_time_zone('Europe/Berlin').strftime('%d.%m.%Y')
  end

  def format_time(datetime)
    return '' if datetime.nil?

    datetime.in_time_zone('Europe/Berlin').strftime('%H:%M:%S')
  end
end
