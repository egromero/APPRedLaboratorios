import os
import datetime




def dbwirter():
	pass

def recordsWriter(value):
	  
	if not os.path.isfile('./registrosOffline.csv'):
		file = open('registrosOffline.csv', 'a')
		file.write('rfid,created_at,tipo,lab_id\n')	

	with open('registrosOffline.csv', 'a') as file:
		text = value['rfid']+','+datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")+','+value['tipo']+','+value['lab_id']+'\n'
		file.write(text)



def visitsRecordsWriter(value):
	if not os.path.isfile('./registrosVisitasOffline.csv'):
		file = open('registrosVisitasOffline.csv','a')
		file.write('rut,created_at,motivo,institucion\n')
	with open('registrosVisitasOffline.csv', 'a') as file:
		text = value['rut']+','+datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")+','+value['motivo']+','+value['institucion']+','+value['lab_id']+'\n'
		file.write(text)



 				



