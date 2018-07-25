$(document).ready(function() {
  var statesCanvas = document.getElementById("statesChart");

  Chart.defaults.global.defaultFontFamily = "Lato";
  Chart.defaults.global.defaultFontSize = 18;

  $.ajax({ url: statesCanvas.dataset.url, dataType: 'json', success: function(data) {
    new Chart(statesCanvas, { type: 'bar', data: data, options: chartOptions });
  }
  })

  var chartOptions = {
    title: {
      display: true,
      text: 'Letter statistics:'
    },
    responsive: true,
    maintainAspectRatio: false,
      scales: {
        xAxes: [{
          stacked: true,
        }],
        yAxes: [{
          stacked: true
        }]
      }
  };
})
