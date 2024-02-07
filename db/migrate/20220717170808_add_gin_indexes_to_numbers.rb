# frozen_string_literal: true

class AddGinIndexesToNumbers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pg_trgm'

    add_index :numbers, 'name gin_trgm_ops', using: :gin
    add_index :numbers, 'phone gin_trgm_ops', using: :gin
  end
end
