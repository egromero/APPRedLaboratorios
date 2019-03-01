class Student < ApplicationRecord
    has_and_belongs_to_many :laboratories
    has_many :records
end
