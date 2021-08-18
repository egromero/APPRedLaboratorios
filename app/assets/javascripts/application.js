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
  var table = $("#previous-table");
  table.html("");
  fetch("http://localhost:3000/get_records", {
    method: "POST",
    body: JSON.stringify(data),
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then(function(response) { return response.json() })
    .then(function(data) {
      data.forEach(function(element) {
        fetch("http://localhost:3000/get_student", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ student_id: element.student_id }),
        })
          .then(function (response) { return response.json() })
          .then(function(studentData) {
            const date = new Date(element.created_at)
              .toLocaleString("es-ES")
              .split(" ");
            const row = `<tr><td><a href="/students/${studentData.id}">${
              studentData.nombre
            }</a></td>
                      <td>${date[0]}</td>
                      <td>${date[1]}</td>
                      <td>${element.tipo == "t" ? "Ingreso" : "Salida"}</td>
                      </tr>`;
            table.append(row);
          });
      });
    });
};

window.postForm = function () {
  fetch("/visits", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      visit: {
        rut: document.getElementById("run").value,
        institucion: document.getElementById("institution").value,
        lab_id: document.getElementById("lab").value,
        motivo: document.getElementById("motivo").value,
        other: document.getElementById("otro").value,
        quantity: document.getElementById("counter").value,
      },
    }),
  })
    .then(function (response) { return response.json() })
    .then(function(data){
      if (data.type == "student") {
        alert(`Bienvenido ${data.name} registro realizado`);
      } else {
        alert("Visita registrada.");
      }
      window.location.replace("/slideshow");
    });
};
