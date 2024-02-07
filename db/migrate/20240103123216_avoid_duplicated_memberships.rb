# frozen_string_literal: true

class AvoidDuplicatedMemberships < ActiveRecord::Migration[7.0]
  def change
    ActiveRecord::Base.connection.execute('
      DELETE FROM memberships
      WHERE id IN (
          SELECT
              id
          FROM (
              SELECT
                  id,
                  ROW_NUMBER() OVER w AS rnum
              FROM memberships
              WINDOW w AS (
                  PARTITION BY account_id,user_id
                  ORDER BY id
              )

          ) t
      WHERE t.rnum > 1);
      ')

    add_index :memberships, %i[account_id user_id], unique: true
  end
end
