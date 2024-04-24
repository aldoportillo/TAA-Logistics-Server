class Event < ApplicationRecord
    has_many :images, dependent: :destroy
end
