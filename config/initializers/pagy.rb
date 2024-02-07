# frozen_string_literal: true

require 'pagy/extras/items'

# If you change this, update items in app/javascript/controllers/search_controller.js to match
Pagy::DEFAULT[:items] = 50
Pagy::DEFAULT[:max_items] = 1_000
