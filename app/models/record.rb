class Record < ApplicationRecord
    belongs_to :student
    require 'csv'

    def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
            hashrow = row.to_hash
            student = Student.where(rfid: hashrow['rfid'])[0]
            @record = student.records.new({:tipo => hashrow['tipo'],
                                           :created_at =>hashrow['created_at'],
                                           :lab_id =>hashrow['lab_id']})
            @record.save
        end
    end

end
