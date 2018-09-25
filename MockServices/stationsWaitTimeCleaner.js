var fs = require('fs');

var obj;
fs.readFile('rawStations.json', 'utf8', function (err, data) {
  if (err) throw err;
  obj = JSON.parse(data);

  var output = []
  /Users/miguelruiz/Git/suburbano/MockServices/stationsWaitTimeCleaner.js

  obj.forEach(element => {
      let name = element.name
      let levelOfOccupation = element.levelOfOccupation  
      Object.keys(levelOfOccupation).forEach( dayKey => {
        var data = {
            station: name
          }  
        let dayData = levelOfOccupation[dayKey]
        data.day = dayKey
        data.wait_time = dayData.value
        data.houre = parseInt(dayData.houre.split(":")[0]) * 60

        data.id = `${name}-${dayKey}-`
      })
      output.push(data)
  });

    fs.writeFile('new.json', JSON.stringify(output), 'utf8', () => {
        console.log("end")
    });

});