class Student < ApplicationRecord
  has_and_belongs_to_many :laboratories
  has_many :records
  has_many :wallets

  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      hashrow = row.to_hash
      @student = Student.new({ rfid: hashrow['rfid'],
                               nombre: hashrow['nombre'],
                               nalumno: hashrow['nalumno'],
                               sit_academica: hashrow['sit_academica'],
                               correo: hashrow['correo'],
                               rut: hashrow['rut'] })
      @student.save
    end
  end

  def current_wallet
    walet = wallets.where(current: true).first
    if walet.nil?
      self.wallets.create(student_id: self.id, hours: 16)
    else
      walet
    end
  end

  def format_rut
    '' if rut.nil?
    rut if rut.include? '-'
    "#{rut[..-2]}-#{rut[-1]}"
  end
end
