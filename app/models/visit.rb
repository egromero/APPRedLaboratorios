class Visit < ApplicationRecord
    
    require 'csv'

    def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
            hashrow = row.to_hash
            student = Student.where(rut: hashrow['rut'])[0]
            if student
                @record = student.records.new({:tipo => hashrow['tipo'], :created_at =>hashrow['created_at']})
                @record.save
            else
                @visit = Visit.new(rut: hashrow['rut'], motivo: hashrow['motivo'], institucion: hashrow['institucion'])
                @visit.save
            end
        end
    end
end
