# coding=utf-8
import sys
from PyQt5 import QtGui
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget, QPushButton, QGridLayout, QLabel, QVBoxLayout, QMessageBox
from PyQt5.QtCore import pyqtSlot, QTimer, QDate, QTime, QDateTime, pyqtSignal, QThread, Qt, QRect, QMetaObject, QCoreApplication
from PyQt5.QtTest import QTest
import datetime
import webbrowser
import time
import sys
import requests

font_but = QtGui.QFont()
font_but.setFamily("Segoe UI Symbol")
font_but.setPointSize(20)
font_but.setWeight(200) 

class MainWindow(QMainWindow):
    def __init__(self, parent=None):
        super(MainWindow, self).__init__(parent=parent)
        self.setupUi(self)

    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(1202, 706)
        MainWindow.setStyleSheet("background: rgba(222, 222, 222, 130)")
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.pushButton = QPushButton(self.centralwidget)
        self.pushButton.setGeometry(QRect(540, 390, 221, 71))
        self.pushButton.setStyleSheet("font: 14pt \"MS Shell Dlg 2\";\n"
        "background :rgba(217, 56, 48,255)")
        self.pushButton.setObjectName("pushButton")
        self.label = QLabel(self.centralwidget)
        self.label.setGeometry(QRect(480, 250, 381, 121))
        self.label.setStyleSheet("background: rgba(222, 222, 222, 0);\n"
        "font: 20pt \"MS Shell Dlg 2\";\n""")
        self.label.setObjectName("label")
        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        QMetaObject.connectSlotsByName(MainWindow)
        self.showFullScreen()
        self.thread = Reader()
        self.thread.start()
        self.thread.sig1.connect(self.changeColor)
        self.thread.sig2.connect(self.changeColor)


        ## Send text between two class with pyqsignal 

    def changeColor(self, value):

            option = {"<class 'dict'>":('Bienvenido '+value['nombre'] if type(value)==dict else 0, 'rgb(0,255,0)'),
                      "<class 'str'>": (value, 'rgb(230,0,0)'), 
                      "<class 'NoneType'>":('Estudiante no inscrito en Laboratorio','rgb(230,0,0)')}

            value = None if len(value)<1 else value
            texto, color = option[str(type(value))]
            self.label.setText(texto)
            self.pushButton.setVisible(False)
            self.setStyleSheet("QWidget {background-color: %s ;}" % (color))
            QTest.qWait(1500)
            self.setStyleSheet("QWidget {background-color: rgb(222,222,222);}")
            self.pushButton.setVisible(True)
            self.label.setText('Sistema De Acceso a Laboratorios UC')
       


    def retranslateUi(self, MainWindow):
        _translate = QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.pushButton.setText(_translate("MainWindow", "Registrar Visita"))
        self.label.setText(_translate("MainWindow", "Sistema De Acceso a Laboratorios UC"))


class Reader(QThread):

    sig1 = pyqtSignal(dict)
    sig2 = pyqtSignal(str)

    def __init__(self, parent=None):
        QThread.__init__(self, parent)

    def run(self):
        while True:
            time.sleep(5)
            self.lectura = {"rfid":"80394AF2", "tipo":"ingreso"}
            try:
                req = requests.post("http://localhost:3000/records", self.lectura).json()
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
    myapp.setWindowOpacity(0.9)
    myapp.show()
    myapp.move(resolution.center() - myapp.rect().center())
    sys.exit(app.exec_())


