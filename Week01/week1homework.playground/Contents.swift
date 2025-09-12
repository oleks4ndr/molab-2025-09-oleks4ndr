// Oleksandr A. Week 1: HW-1
let blue: [String]   = ["🔵", "💙", "🟦"]
let purple: [String] = ["🟣", "💜", "🟪"]
let yellow: [String] = ["🟡", "⚪️", "🟨"]
let ground: [String]  = ["⚫️", "🖤", "⬛️", "🟫", "🟤", "🤎"]

func printSunset(_ skyColor1: [String],
                  _ skyColor2: [String],
                  _ sunColor: [String],
                  _ groundColor: [String],
                  width: Int,
                  height: Int)
{
    // divide image into 4 quarters
    let q1 = height / 4
    let q2 = height / 2
    let q3 = (height*3) / 4
    
    // variables for sun
    let sWidth = width / 3
    var sStart = width - (2 * sWidth)
    var sEnd = width - sWidth
    
    for row in 0 ..< height {
        var line = ""
        for col in 0 ..< width {
            let symbol: String
            if row < q1 {
                symbol = skyColor1.randomElement() ?? " "
            } else if row < q2 {
                // create gradient
                let choice = Bool.random()
                let color = choice ? skyColor1 : skyColor2
                symbol = color.randomElement() ?? " "
            } else if row < q3 {
                // color sky if not in sun area
                if col < sStart || col > sEnd {
                    symbol = skyColor2.randomElement() ?? " "
                } else { // color sun
                    symbol = sunColor.randomElement() ?? " "
                }
            } else {
                symbol = groundColor.randomElement() ?? " "
            }
            line += symbol + " "
        }
        print(line)
    }
}

printSunset(blue, purple, yellow, ground, width:20, height:20)
