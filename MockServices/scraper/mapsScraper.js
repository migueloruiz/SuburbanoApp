(function(){
    var section = document.getElementsByClassName("section-popular-times-graph")
    var childrens = [].slice.call(section);
    var levelOfOccupation = {}
    childrens.forEach((children) => {
        var day = children.parentElement.getAttribute("jsinstance")
        var bars = Array.from(children.getElementsByClassName("section-popular-times-bar"))
        var data = []
        bars.forEach((bar) => {
            let rawData = bar.getAttribute("aria-label")
            let dataRegex = /(\d+) % \(hora: (\d+:00)\)/g
            var match = dataRegex.exec(rawData)
            data.push({
                "value": match[1],
                "houre": match[2]
            })
        })
        levelOfOccupation[day] = data
    })
    console.log("\"levelOfOccupation\": "+JSON.stringify(levelOfOccupation))
})();