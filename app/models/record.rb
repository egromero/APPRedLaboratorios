class Record < ApplicationRecord
    belongs_to :student
    require 'csv'

    def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
            hashrow = row.to_hash
            student = Student.where(rfid: hashrow['rfid'])[0]
            if student.status.nil?
                student.status = true
                student.save
            end
            @record = student.records.new({:tipo => student.status,
                                           :created_at =>hashrow['created_at'],
                                           :lab_id =>hashrow['lab_id']})
            student.status = !student.status
            student.save
            @record.save
        end
    end
    def self.to_csv
        attributes = %w{estudiante fecha_registro hora_de_registro laboratorio}
    
        CSV.generate(headers: true) do |csv|
          csv << attributes
          all.each do |record|
            csv << [record.student.nombre, record.created_at.to_s.split(' ')[0],record.created_at.to_s.split(' ')[1], Laboratory.find(record.lab_id).nombre]
          end
          
        end
      end

end
