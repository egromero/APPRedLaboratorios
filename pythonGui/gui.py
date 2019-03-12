# -*- coding: utf-8 -*-
import sys
from PyQt5 import QtGui
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget, QPushButton, QGridLayout, QLabel, QVBoxLayout, QMessageBox, QComboBox, QStyle
from PyQt5.QtCore import pyqtSlot, QTimer, QDate, QTime, QDateTime, pyqtSignal, QThread, Qt, QRect, QMetaObject, QCoreApplication
from PyQt5.QtTest import QTest
import datetime
import time
import sys
import requests
import urllib.request
from localdbmanager import recordsWriter, visitsRecordsWriter
      

font_but = QtGui.QFont()
font_but.setFamily("Segoe UI Symbol")
font_but.setPointSize(20)
font_but.setWeight(200) 


def internet_on():
    try:
        urllib.request.urlopen('http://216.58.192.142', timeout=1)
        return True
    except urllib.request.URLError as err: 
        return False


class MainWindow(QMainWindow):
    def __init__(self, parent=None):
        super(MainWindow, self).__init__(parent=parent)
        self.setupUi(self)

    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(1202, 706)
        MainWindow.setStyleSheet("background: rgba(222, 222, 222, 255)")
        self.lab_id = 1
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.pushButton = QPushButton(self.centralwidget)
        self.pushButton.setGeometry(QRect(540, 390, 221, 71))
        self.pushButton.setStyleSheet("font: 14pt \"MS Shell Dlg 2\";\n"
        "background :rgba(217, 56, 48,255)")
        self.pushButton.setObjectName("pushButton")
        self.label_6 = QLabel(self.centralwidget)
        self.label_6.setGeometry(QRect(480, 250, 381, 121))
        self.label_6.setStyleSheet("background: rgba(222, 222, 222, 0);\n"
        "font: 20pt \"MS Shell Dlg 2\";\n""")
        self.label_6.setObjectName("label_6")
        self.pushButton_1 = QPushButton(self.centralwidget)
        self.pushButton_1.setGeometry(QRect(90, 250, 161, 91))
        self.pushButton_1.setStyleSheet("font: 14pt \"MS Shell Dlg 2\";")
        self.pushButton_1.setObjectName("pushButton_1")
        self.label = QLabel(self.centralwidget)
        self.label.setGeometry(QRect(100, 130, 471, 51))
        self.label.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.label.setObjectName("label")
        self.label_5 = QLabel(self.centralwidget)
        self.label_5.setGeometry(QRect(160, 180, 471, 51))
        self.label_5.setStyleSheet("font: 30pt \"MS Shell Dlg 2\";")
        self.label_5.setObjectName("label_5")
        self.comboBox = QComboBox(self.centralwidget)
        self.comboBox.setGeometry(QRect(750, 250, 311, 61))
        self.comboBox.setStyleSheet("font: 12pt \"MS Shell Dlg 2\";")
        self.comboBox.setObjectName("comboBox")
        self.comboBox.addItem("")
        self.comboBox.addItem("")
        self.comboBox.addItem("")
        self.comboBox.addItem("")
        self.comboBox.addItem("")
        self.pushButton_2 = QPushButton(self.centralwidget)
        self.pushButton_2.setGeometry(QRect(250, 250, 161, 91))
        self.pushButton_2.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.pushButton_2.setObjectName("pushButton_2")
        self.pushButton_3 = QPushButton(self.centralwidget)
        self.pushButton_3.setGeometry(QRect(410, 250, 161, 91))
        self.pushButton_3.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";\n""")
        self.pushButton_3.setObjectName("pushButton_3")
        self.pushButton_14 = QPushButton(self.centralwidget)
        self.pushButton_14.setGeometry(QRect(430, 190, 40, 41))
        self.pushButton_14.setIcon(self.style().standardIcon(QStyle.SP_ArrowLeft))
        self.pushButton_14.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";\n""")
        self.pushButton_14.setObjectName("pushButton_del")
        self.pushButton_4 = QPushButton(self.centralwidget)
        self.pushButton_4.setGeometry(QRect(90, 340, 161, 91))
        self.pushButton_4.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.pushButton_4.setObjectName("pushButton_4")
        self.pushButton_6 = QPushButton(self.centralwidget)
        self.pushButton_6.setGeometry(QRect(410, 340, 161, 91))
        self.pushButton_6.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.pushButton_6.setObjectName("pushButton_6")
        self.pushButton_5 = QPushButton(self.centralwidget)
        self.pushButton_5.setGeometry(QRect(250, 340, 161, 91))
        self.pushButton_5.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.pushButton_5.setObjectName("pushButton_5")
        self.pushButton_7 = QPushButton(self.centralwidget)
        self.pushButton_7.setGeometry(QRect(90, 430, 161, 91))
        self.pushButton_7.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";\n""\n""")
        self.pushButton_7.setObjectName("pushButton_7")
        self.pushButton_9 = QPushButton(self.centralwidget)
        self.pushButton_9.setGeometry(QRect(410, 430, 161, 91))
        self.pushButton_9.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.pushButton_9.setObjectName("pushButton_9")
        self.pushButton_8 = QPushButton(self.centralwidget)
        self.pushButton_8.setGeometry(QRect(250, 430, 161, 91))
        self.pushButton_8.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.pushButton_8.setObjectName("pushButton_8")
        self.pushButton_10 = QPushButton(self.centralwidget)
        self.pushButton_10.setGeometry(QRect(90, 520, 161, 91))
        self.pushButton_10.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.pushButton_10.setObjectName("pushButton_10")
        self.pushButton_11 = QPushButton(self.centralwidget)
        self.pushButton_11.setGeometry(QRect(410, 520, 161, 91))
        self.pushButton_11.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.pushButton_11.setObjectName("pushButton_11")
        self.pushButton_12 = QPushButton(self.centralwidget)
        self.pushButton_12.setGeometry(QRect(250, 520, 161, 91))
        self.pushButton_12.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.pushButton_12.setObjectName("pushButton_12")
        self.label_2 = QLabel(self.centralwidget)
        self.label_2.setGeometry(QRect(750, 190, 171, 31))
        self.label_2.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.label_2.setObjectName("label_2")
        self.comboBox_2 = QComboBox(self.centralwidget)
        self.comboBox_2.setGeometry(QRect(750, 400, 311, 61))
        self.comboBox_2.setStyleSheet("font: 12pt \"MS Shell Dlg 2\";")
        self.comboBox_2.setObjectName("comboBox_2")
        self.comboBox_2.addItem("")
        self.comboBox_2.addItem("")
        self.label_3 = QLabel(self.centralwidget)
        self.label_3.setGeometry(QRect(750, 360, 251, 31))
        self.label_3.setStyleSheet("font: 16pt \"MS Shell Dlg 2\";")
        self.label_3.setObjectName("label_3")
        self.pushButton_13 = QPushButton(self.centralwidget)
        self.pushButton_13.setGeometry(QRect(820, 530, 181, 51))
        self.pushButton_13.setStyleSheet("font: 14pt \"MS Shell Dlg 2\";\n"
        "background :rgba(217, 56, 48,255)")
        self.pushButton_13.setObjectName("pushButton_13")
        self.label_4 = QLabel(self.centralwidget)
        self.label_4.setGeometry(QRect(400, 30, 491, 61))
        self.label_4.setStyleSheet("font: 28pt \"MS Shell Dlg 2\";")
        self.label_4.setObjectName("label_4")
        self.pushButton.clicked.connect(self.recordVisit)
        self.pushButton_1.clicked.connect(self.clickedButton)
        self.pushButton_2.clicked.connect(self.clickedButton)
        self.pushButton_3.clicked.connect(self.clickedButton)
        self.pushButton_4.clicked.connect(self.clickedButton)
        self.pushButton_5.clicked.connect(self.clickedButton)
        self.pushButton_6.clicked.connect(self.clickedButton)
        self.pushButton_7.clicked.connect(self.clickedButton)
        self.pushButton_8.clicked.connect(self.clickedButton)
        self.pushButton_9.clicked.connect(self.clickedButton)
        self.pushButton_10.clicked.connect(self.clickedButton)
        self.pushButton_11.clicked.connect(self.clickedButton)
        self.pushButton_12.clicked.connect(self.clickedButton)
        self.pushButton_14.clicked.connect(self.clickedButton)
        self.pushButton_13.clicked.connect(self.send)
        MainWindow.setCentralWidget(self.centralwidget)
        self.retranslateUi(MainWindow)
        QMetaObject.connectSlotsByName(MainWindow)
        self.showFullScreen()
        self.thread = Reader()
        self.thread.sig1.connect(self.changeColor)
        self.thread.sig2.connect(self.changeColor)
        #self.thread.start()
        self.sym ={'12':'0', '11':'-', '10':'K'}
        self.visible(False)
   

    def visible(self, bvalue):
        self.pushButton.setVisible(not(bvalue))
        self.pushButton_1.setVisible(bvalue)
        self.pushButton_2.setVisible(bvalue)
        self.pushButton_3.setVisible(bvalue)
        self.pushButton_4.setVisible(bvalue)
        self.pushButton_5.setVisible(bvalue)
        self.pushButton_6.setVisible(bvalue)
        self.pushButton_7.setVisible(bvalue)
        self.pushButton_8.setVisible(bvalue)
        self.pushButton_9.setVisible(bvalue)
        self.pushButton_10.setVisible(bvalue)
        self.pushButton_11.setVisible(bvalue)
        self.pushButton_12.setVisible(bvalue)
        self.pushButton_13.setVisible(bvalue)
        self.pushButton_14.setVisible(bvalue)
        self.label.setVisible(bvalue)
        self.label_2.setVisible(bvalue)
        self.label_3.setVisible(bvalue)
        self.label_4.setVisible(bvalue)
        self.label_5.setVisible(bvalue)
        self.label_6.setVisible(not(bvalue))
        self.comboBox.setVisible(bvalue)
        self.comboBox_2.setVisible(bvalue)
        self.label_5.setText('')


    def clickedButton(self):
        
        button = self.sender()
        value = button.objectName()
        value = value.replace("pushButton_", "")
        if value == 'del':
            if self.label_5.text():
                self.label_5.setText(self.label_5.text()[:-1])
                return
            else:
                return
        elif int(value)>9:
            value = self.sym[value]
        self.label_5.setText(self.label_5.text() + '{}'.format(value))

    def send(self):
        
        url = 'http://localhost:3000/visits'

        data = {'rut': self.label_5.text(), 
                'motivo': self.comboBox.currentText(),
                'institucion': self.comboBox_2.currentText()
                'tipo': 'ingreso'
                'lab_id':self.lab_id}


        if internet_on():
            response = requests.post(url, data).json()
            if response['type'] == 'student':
                self.visible(False)
                self.changeColor(response['data'])
            else:
                self.visible(False)
                texto = 'Visita Registrada, Bienvenido'
                color = 'rgb(255,164,32)'
                self.label_6.setText(texto)
                self.pushButton.setVisible(False)
                self.setStyleSheet("QWidget {background-color: %s ;}" % (color))
                QTest.qWait(1500)
                self.setStyleSheet("QWidget {background-color: rgb(222,222,222);}")
                self.pushButton.setVisible(True)
                self.label_6.setText('Sistema De Acceso a Laboratorios UC')
        else:
            visitsRecordsWriter(data)
            self.visible(False)
            texto = 'Sin Conexión a internet, Visita registrada en cola'
            color = 'rgb(255,164,0)'
            self.label_6.setText(texto)
            self.pushButton.setVisible(False)
            self.setStyleSheet("QWidget {background-color: %s ;}" % (color))
            QTest.qWait(1500)
            self.setStyleSheet("QWidget {background-color: rgb(222,222,222);}")
            self.pushButton.setVisible(True)
            self.label_6.setText('Sistema De Acceso a Laboratorios UC')


    def changeColor(self, value):

            option = {"<class 'dict'>":('Bienvenido '+value['nombre'] if type(value)==dict else 0, 'rgb(0,255,0)'),
                      "<class 'str'>": (value, 'rgb(230,0,0)'), 
                      "<class 'NoneType'>":('Estudiante no inscrito en Laboratorio','rgb(230,0,0)')}

            value = None if len(value)<1 else value
            texto, color = option[str(type(value))]
            self.label_6.setText(texto)
            self.pushButton.setVisible(False)
            self.setStyleSheet("QWidget {background-color: %s ;}" % (color))
            QTest.qWait(1500)
            self.setStyleSheet("QWidget {background-color: rgb(222,222,222);}")
            self.pushButton.setVisible(True)
            self.label_6.setText('Sistema De Acceso a Laboratorios UC')
       
    def recordVisit(self):
        self.visible(True)

    def retranslateUi(self, MainWindow):
        _translate = QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.pushButton.setText(_translate("MainWindow", "Registrar Visita"))
        self.label_6.setText(_translate("MainWindow", "Sistema De Acceso a Laboratorios UC"))
        self.pushButton_1.setText(_translate("MainWindow", "1"))
        self.label.setText(_translate("MainWindow", "INGRESE SU RUT CON GUION Y SIN PUNTOS:\n"))
        self.comboBox.setItemText(0, _translate("MainWindow", "Académica"))
        self.comboBox.setItemText(1, _translate("MainWindow", "Personal"))
        self.comboBox.setItemText(2, _translate("MainWindow", "Emprendimiento"))
        self.comboBox.setItemText(3, _translate("MainWindow", "Pregrado"))
        self.comboBox.setItemText(4, _translate("MainWindow", "Taller"))
        self.pushButton_2.setText(_translate("MainWindow", "2"))
        self.pushButton_3.setText(_translate("MainWindow", "3"))
        self.pushButton_4.setText(_translate("MainWindow", "4"))
        self.pushButton_6.setText(_translate("MainWindow", "6"))
        self.pushButton_5.setText(_translate("MainWindow", "5"))
        self.pushButton_7.setText(_translate("MainWindow", "7"))
        self.pushButton_9.setText(_translate("MainWindow", "9"))
        self.pushButton_8.setText(_translate("MainWindow", "8"))
        self.pushButton_10.setText(_translate("MainWindow", "K"))
        self.pushButton_11.setText(_translate("MainWindow", "-"))
        self.pushButton_12.setText(_translate("MainWindow", "0"))
        self.label_2.setText(_translate("MainWindow", "Motivo de la visita"))
        self.comboBox_2.setItemText(0, _translate("MainWindow", "Otro"))
        self.comboBox_2.setItemText(1, _translate("MainWindow", "Pontificia Universidad Católica de Chile"))
        self.label_3.setText(_translate("MainWindow", "Institución que pertenece"))
        self.pushButton_13.setText(_translate("MainWindow", "Enviar Información"))
        self.label_4.setText(_translate("MainWindow", "Registro de Visitas REDFAB"))




class Reader(QThread):

    sig1 = pyqtSignal(dict)
    sig2 = pyqtSignal(str)

    def __init__(self, parent=None):
        QThread.__init__(self, parent)

    def run(self):
        url = ''
        while True:
            time.sleep(5)
            self.lectura = {"rfid":"8af1345ea", "tipo":"ingreso"}
            try:
                req = requests.post(url, self.lectura).json()
                if not req:
                    req = ''
                    self.sig2.emit(req)
                else:
                    self.sig1.emit(req)
                print(req)
            except:
                req = 'Not Internet Conection'
                self.sig2.emit(req)

            
            
            time.sleep(4)




if __name__ == "__main__":  
    app = QApplication(sys.argv)
    desktop = QApplication.desktop()
    resolution = desktop.availableGeometry()
    myapp = MainWindow()
    myapp.show()
    myapp.move(resolution.center() - myapp.rect().center())
    sys.exit(app.exec_())


