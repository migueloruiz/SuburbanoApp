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
    "0": "concert",
    "1": "workshop",
    "2": "fair",
    "3": "exhibition",
    "4": "special"
}
var events = []

// "displayDate": "1, 2 y 3 de Julio",
//         "startHour": "11:00",
//         "duration": "2"
//         "dates": "2018/07/01,2018/07/02,2018/07/03", // "2018/07/01" , "2018/07/01-2018/07/03"
//         "endDate": 23456789,

var request = require('request')
var moment = require('moment')

function containsDay(text) {
    let days = {
        "viernes": 5, 
        "sábado": 6,
        "sabado": 6,
        "sabatinos": 6,
        "domingo": 0
    }
    let results = []
    for (var key in days) {
        if (text.includes(key)) {
            results.push(days[key])
        }
    }
    return Array.from(new Set(results))
}

function getDuration(data) {
    let start = moment(data.Fecha)
    let end = moment(data.Fecha)

    start.hours(data.hora)
    start.minutes(data.minutos)
    end.hours(data.hora2)
    end.minutes(data.minutos2)

    return end.diff(start, 'minutes')
}

request('https://app.fsuburbanos.com/suburbano/mobileMethods/Eventos.php?usr=subur', function (error, response, body) {
  console.log('error:', error)
  console.log('statusCode:', response && response.statusCode)
  JSON.parse(body).forEach(element => {
    let data = {
        id: sanitize(element.IdEvento),
        title: sanitize(element.Titulo),
        descripcion: sanitize(element.Descripcion),
        category: categoria[element.categoria],
        loaction: element.Lugar
    }

    let startDate = moment(element.Fecha).locale('es')
    let endDate = moment(element.Fecha2).locale('es')
    
    startDate.hours(element.hora)
    startDate.minutes(element.minutos)
    endDate.hours(data.hora2)
    endDate.minutes(data.minutos2)

    data.displayDate = ""
    data.startHour = `${element.hora}:${element.minutos} - ${element.hora2}:${element.minutos2}`
    data.duration = endDate.diff(startDate, 'minutes')
    data.starDate = startDate.unix()
    data.endDate = endDate.unix()

    if (startDate.isSame(element.Fecha2)) {
        data.displayDate = endDate.format('D [de] MMM')
    }

    let daysContanis = containsDay(data.title + " " + data.descripcion)
    if (daysContanis.length > 0) {
        data.displayDate = ""
        let now = moment()
        let nowEs = moment().locale('es')
        data.repeatEvent = []
        for (let index = 0; index < daysContanis.length; index++) {
            nowEs.day(daysContanis[index])
            now.day(daysContanis[index])
            data.repeatEvent.push(now.format('dddd'))
            data.displayDate = data.displayDate + `${nowEs.format('dddd')}`
            if (nowEs.format('dddd') == "sábado" || nowEs.format('dddd') == "domingo") {
                data.displayDate = data.displayDate + "s"
            }

            switch (index) {
                case daysContanis.length - 1: break
                case daysContanis.length - 2:
                    data.displayDate = data.displayDate + " y "
                    break
                default:
                data.displayDate = data.displayDate + ", "
                    break
            }
        }

        data.repeatEvent = data.repeatEvent.join(",")
        data.displayDate = data.displayDate + ` de ${nowEs.format('MMM')}`
    }

    if (data.displayDate == "") {
        if (startDate.format('MM') == startDate.format('MM')) {
            data.displayDate = `Del ${startDate.date()} al ${endDate.date()} de ${endDate.format('MMM')}`
        } else {
            data.displayDate = `Del ${startDate.date()} de ${startDate.format('MMM')}  al ${endDate.date()} de ${endDate.format('MMM')}`
        }
        data.repeatEvent = "All"
    }

    events.push(data)
  })
  console.log(JSON.stringify(events))
})
