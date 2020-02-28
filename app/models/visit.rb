class Visit < ApplicationRecord
    validates :rut, presence: true 
    require 'csv'

    def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
            hashrow = row.to_hash
            student = Student.where(rut: hashrow['rut'])[0]
            if student
                @record = student.records.new({:tipo => hashrow['tipo'], 
                                               :created_at =>hashrow['created_at'],
                                               :lab_id => hashrow['lab_id']})
                @record.save
            else
                @visit = Visit.new(rut: hashrow['rut'],
                                   created_at: hashrow['created_at'],
                                   motivo: hashrow['motivo'], 
                                   institucion: hashrow['institucion'],
                                   lab_id: hashrow['lab_id'])
                @visit.save
            end
        end
    end
end
