$(document).ready(function() {
  var statesCanvas = document.getElementById("statesChart");

  $.ajax({ url: statesCanvas.dataset.url, dataType: 'json', success: function(data) {
    new Chart(statesCanvas, { type: 'bar', data: data, options: chartOptions });}
  })

  var chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
      scales: {
        xAxes: [{
          stacked: true
        }],
        yAxes: [{
          stacked: true
        }]
      }
  };
})
