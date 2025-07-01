class Like < ApplicationRecord
  belongs_to :user
    belongs_to :quote, counter_cache: true
end
