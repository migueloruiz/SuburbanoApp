// Accept-Language	en-MX;q=1, es-MX;q=0.9
// User-Agent	MiSuburbano/5.0.0 (iPhone; iOS 11.2.6; Scale/2.00)

// "https://app.fsuburbanos.com/suburbano/mobileMethods/Eventos.php?usr=subur"
// "https://app.fsuburbanos.com/suburbano/mobileMethods/Saldo.php?tarjeta=2102802447&usr=subur"

// {
// 	"IdEvento": "2344",
// 	"Titulo": "Talleres Sabatinos",
// 	"Descripcion": "<p><strong>Talleres sabatinos de&nbsp;rob&oacute;tica, tejido, migaj&oacute;n, ajedrez, etc.<\/strong><\/p>",
// 	"Fecha": "2018-07-01",
// 	"hora": "11",
// 	"minutos": "00",
// 	"Fecha2": "2018-07-31",
// 	"hora2": "17",
// 	"minutos2": "00",
// 	"categoria": "1",
// 	"Lugar": "Lobby de la Estaci\u00f3n Buenavista"
// }

const Entities = require('html-entities').AllHtmlEntities;
const entities = new Entities();

function sanitize(text) {
    text = entities.decode(text)
    let cleaners = [
        " presenta:",
        /\s+?class="[\w\s]+"[\s+]?/g,
        /<(\/)?\w{0,20}>/g
    ]
    return cleaners.reduce((result, cleaner) => {
        return result.replace(cleaner, "")
        
    }, text)
}

var categoria = {
    "0": "concierto",
    "1": "tallere",
    "2": "feria",
    "3": "exposicione",
    "4": "especiale"
}
var events = []

var request = require('request');
request('https://app.fsuburbanos.com/suburbano/mobileMethods/Eventos.php?usr=subur', function (error, response, body) {
  console.log('error:', error)
  console.log('statusCode:', response && response.statusCode)
  JSON.parse(body).forEach(element => {
    let data = {
        id: sanitize(element.IdEvento),
        title: sanitize(element.Titulo),
        descripcion: sanitize(element.Descripcion),
        startDate: element.Fecha,
        endDate: element.Fecha2,
        schedule: `${element.hora}:${element.minutos} - ${element.hora2}:${element.minutos2}`,
        category: categoria[element.categoria],
        loaction: element.Lugar
    }
    events.push(data)
  })
  console.log(JSON.stringify(events))
})
