# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'main.ui'
#
# Created by: PyQt5 UI code generator 5.9
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QGridLayout, QLabel, QVBoxLayout, QMessageBox
import sys


class MainWindow(QtWidgets.QMainWindow):
    def __init__(self, parent=None):
        super(Ui_MainWindow, self).__init__(parent=parent)
        self.setupUi(self)

    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(1202, 706)
        MainWindow.setStyleSheet("background: rgba(222, 222, 222, 130)")
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.pushButton = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton.setGeometry(QtCore.QRect(540, 390, 221, 71))
        self.pushButton.setStyleSheet("font: 14pt \"MS Shell Dlg 2\";\n"
"background :rgba(217, 56, 48,255)")
        self.pushButton.setObjectName("pushButton")
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(480, 250, 381, 121))
        self.label.setStyleSheet("background: rgba(222, 222, 222, 0);\n"
"font: 16pt \"MS Shell Dlg 2\";\n"
"")
        self.label.setObjectName("label")
        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)
         self.showFullScreen()
        self.thread = Reader()
        #self.thread.start()
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
            self.setStyleSheet("QWidget {background-color: %s ;}" % (color))
            QTest.qWait(1500)
            self.setStyleSheet("QWidget {background-color: rgb(222,222,222);}")
            self.label.setText('Sistema de acceso')
       


    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.pushButton.setText(_translate("MainWindow", "Registrar Visita"))
        self.label.setText(_translate("MainWindow", "Sistema De Acceso a Laboratorios UC"))

if __name__ == "__main__":  
    app = QApplication(sys.argv)
    desktop = QApplication.desktop()
    resolution = desktop.availableGeometry()
    myapp = Ui_MainWindow()
    myapp.setWindowOpacity(0.9)
    myapp.show()
    myapp.move(resolution.center() - myapp.rect().center())
    sys.exit(app.exec_())

