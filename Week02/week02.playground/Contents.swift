// Oleksandr A. Week02 HW
import UIKit

// helper function to draw circle
func drawCircle(
    in context: UIGraphicsImageRendererContext,
    center: CGPoint,
    radius: CGFloat,
    fill: UIColor,
    stroke: UIColor,
    lineWidth: CGFloat = 2
) {
    let rect = CGRect(
        x: center.x - radius,
        y: center.y - radius,
        width: radius * 2,
        height: radius * 2
    )
    let path = UIBezierPath(ovalIn: rect)
    
    fill.setFill()
    path.fill()
    
    stroke.setStroke()
    path.lineWidth = lineWidth
    path.stroke()
}

// rectangle function
func drawRect(
    in context: UIGraphicsImageRendererContext,
    rect: CGRect,
    fill: UIColor,
    stroke: UIColor,
    lineWidth: CGFloat = 2
) {
    let path = UIBezierPath(rect: rect)
    
    fill.setFill()
    path.fill()
    
    stroke.setStroke()
    path.lineWidth = lineWidth
    path.stroke()
}

// cloud function
func drawCloud(
    in ctx: UIGraphicsImageRendererContext,
    origin: CGPoint,
    size: CGSize,
    fill: UIColor,
) {
    let w = size.width, h = size.height
    let x = origin.x, y = origin.y
    
    // create 4 cloud "puffs" that will form the cloud
    struct Puff {
        let cx: CGFloat;
        let cy: CGFloat;
        let r: CGFloat
    }
    
    let puffs: [Puff] = [
        // big left
        .init(cx: x + w*0.28, cy: y + h*0.62, r: h*0.28),
        // biggest middle
        .init(cx: x + w*0.50, cy: y + h*0.55, r: h*0.34),
        // right
        .init(cx: x + w*0.70, cy: y + h*0.62, r: h*0.26),
        // top bump
        .init(cx: x + w*0.46, cy: y + h*0.34, r: h*0.22),
    ]
    
    // draw the actual cloud
    for p in puffs {
        drawCircle(in: ctx,
                   center: CGPoint(x: p.cx, y: p.cy),
                   radius: p.r,
                   fill: fill,
                   stroke: .clear,
                   lineWidth: 0)
    }
}

// helper to generate x, y, and varying size for clouds for the image
func generateCloudPoints(for number: Int, cloudSize: Int, imgSize: Int) -> [(Int, Int, Int)] {
    var points: [(Int, Int, Int)] = []
    let maxDSize = Int((Double(cloudSize) * 0.3))
    let minDSize = -maxDSize
    for _ in 1...number {
        var cSize = cloudSize + Int.random(in: minDSize...maxDSize)
        let point = (Int.random(in: -cloudSize..<(imgSize-50)), // cloud X
                     Int.random(in: -cloudSize..<(imgSize-50)), // cloud Y
                     cSize // cloud size
                    )
        points.append(point)
    }
    return points
}


let dim = 1024.0
let renderer = UIGraphicsImageRenderer(size: CGSize(width: dim, height: dim))

let image = renderer.image { ctx in

    let canvas = renderer.format.bounds
    // background
    UIColor(red: 66/255, green: 135/255, blue: 245/255, alpha: 1).setFill()
    ctx.fill(canvas)

    // draw sun in the middle
    drawCircle(in: ctx, center: CGPoint(x: dim/2, y: dim/2),
               radius: dim/4, fill: .yellow, stroke: .orange, lineWidth: 5)
    
    // draw clouds around the sun
    let points = generateCloudPoints(for: 10, cloudSize: 400, imgSize: Int(dim))
    for point in points {
        drawCloud(in: ctx,
                  origin: CGPoint(x: point.0, y: point.1),
                  size: CGSize(width: point.2, height: Int(Double(point.2)*0.7)),
                      fill: .white,
                    )
    }
}

// final image
image
