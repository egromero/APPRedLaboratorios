// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require keyboard/jquery.keyboard.min

window.getRecords = function (id) {
  var start = document.getElementById("start-previous-records").value;
  var end = document.getElementById("end-previous-records").value;
  var data = { lab_id: id, start: start, end: end };
  if (!data.start) {
    return alert("Debes seleccionar una fecha.");
  }
  var table = $("#previous-table");
  table.html("");
  $.ajax({
    type: "POST",
    url: "/get_records",
    data: data,
    dataType: "json",
    success: function (data) {
      if (!!data.length) {
        data.forEach(function (studentRecord) {
          $.ajax({
            type: "POST",
            url: "/get_student",
            data: { student_id: studentRecord.student_id },
            success: function (student) {
              var date = new Date(studentRecord.created_at)
                .toLocaleString("es-ES")
                .split(" ");
              var type = studentRecord.tipo == "t" ? "Ingreso" : "Salida";
              var row =
                '<tr><td><a href="/students/' +
                student.id +
                '">' +
                student.nombre +
                "</a></td>" +
                "<td>" +
                date[0] +
                "</td>" +
                "<td>" +
                date[1] +
                "</td>" +
                "<td>" +
                type +
                "</td></tr>";
              table.append(row);
            },
          });
        });
      } else {
        alert("No se encontraron registros en las fechas seleccionadas");
      }
    },
  });
};

window.postForm = function () {
  var data = {
    visit: {
      rut: document.getElementById("run").value,
      institucion: document.getElementById("institution").value,
      lab_id: document.getElementById("lab").value,
      motivo: document.getElementById("motivo").value,
      other: document.getElementById("otro").value,
      quantity: document.getElementById("counter").value,
      uc_student: document.getElementById("uc_student").value,
    },
  };
  console.log('Entrando a ajax...')
  $.ajax({
    type: "POST",
    url: "/visits",
    dataType: "json",
    data: data,
    send: function (data) {
      console.log(data);
      console.log('Entrando a send ajax...');
      alert("Visita registrada.");
      window.location.replace("/slideshow");
    },  
    success: function (data) {
      console.log('Entrando a success ajax...');
      console.log(data);
      if (data.type == "student") {
        alert("Bienvenido/a " + data.name + " registro realizado");
      } else {
        alert("Visita registrada.");
      }
      window.location.replace("/slideshow");
    },
    error: function (jqXHR, textStatus, errorThrown) {
      console.log(data)
      console.error("Error:", textStatus, errorThrown);
      alert("Error al registrar la visita: " + errorThrown);
      window.location.replace("/slideshow");
    }
  });
};

window.elements = [];
window.addElement = function (element){
  if(!window.elements.includes(element)){
    $("#hour-"+element).addClass("selected")
    window.elements.push(element);
    console.log("add:",window.elements)
  }else{
    $("#hour-"+element).removeClass("selected")
    window.elements.splice(window.elements.indexOf(element),1)
    console.log("remove:", window.elements)
  }
  if(window.elements.length>0){
    $("#reservation-button").prop("disabled", false)
    $("#reservation-button").attr("onClick", "submitForm();");
  }
}


window.rut = {
  validaRut: function(rutCompleto) {
      if (!/^[0-9]+-[0-9kK]{1}$/.test(rutCompleto))
          return false;
      var tmp = rutCompleto.split('-');
      var digv = tmp[1];
      var rut = tmp[0];
      if (digv == 'K') digv = 'k';
      return (window.rut.dv(rut) == digv);
  },
  dv: function(T) {
      var M = 0,
          S = 1;
      for (; T; T = Math.floor(T / 10))
          S = (S + T % 10 * (9 - M++ % 6)) % 11;
      return S ? S - 1 : 'k';
  }
}

window.modules = {
  0: "8:00",
  1: "8:30",
  2: "9:00",
  3: "9:30",
  4: "10:00",
  5: "10:30",
  6: "11:00",
  7: "11:30",
  8: "12:00",
  9: "12:30",
  12: "14:00",
  13: "14:30",
  14: "15:00",
  15: "15:30",
  16: "16:00",
  17: "16:30",
  18: "17:00",
  19: "17:30",
}