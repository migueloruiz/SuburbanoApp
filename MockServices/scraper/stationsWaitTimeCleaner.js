var fs = require('fs');

var obj;
fs.readFile('rawStations.json', 'utf8', function (err, json) {
  if (err) throw err;
  obj = JSON.parse(json);

  var output = []

  obj.stations.forEach(element => {
      let name = element.name
      let levelOfOccupation = element.levelOfOccupation  
      Object.keys(levelOfOccupation).forEach( dayKey => {
        let dayData = levelOfOccupation[dayKey]
        dayData.forEach(houre => {
          var data = {
            station: name,
            day: dayKey,
            concurence: houre.value,
            time: houre.houre,
            houre: parseInt(houre.houre.split(":")[0]) * 60
          }  
          output.push(data)
        })
      })
  });

    fs.writeFile('new.json', JSON.stringify(output), 'utf8', () => {
        console.log("end")
    });

});