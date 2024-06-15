import SwiftUI
import SwiftMath



struct ContentView: View {
    @State private var touchLocation: CGPoint = .zero
    @State private var dragging: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GeometryReader { geometry in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let frameSize = min(geometry.size.width, geometry.size.height)
                let circleSize = frameSize * 0.8
                let radius = circleSize / 2
                // Define the array containing the unit circle common angles

              let angles: [Double] = [0, 30, 45, 60, 90, 120, 135, 150, 180, 210, 225, 240, 270, 300, 315, 330]
              let angleLabels: [String] = [
                  "0", "\\frac{\\pi}{6}", "\\frac{\\pi}{4}", "\\frac{\\pi}{3}", "\\frac{\\pi}{2}",
                  "\\frac{2\\pi}{3}", "\\frac{3\\pi}{4}", "\\frac{5\\pi}{6}", "\\pi",
                  "\\frac{7\\pi}{6}", "\\frac{5\\pi}{4}", "\\frac{4\\pi}{3}", "\\frac{3\\pi}{2}",
                  "\\frac{5\\pi}{3}", "\\frac{7\\pi}{4}", "\\frac{11\\pi}{6}"
              ]


                // Circle at the center
                Circle()
                    .fill(Color.white)
                    .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                    .frame(width: circleSize, height: circleSize)
                    .position(center)
              let reversedZippedArray = Array(zip(angles, angleLabels)).reversed()

                // Loop over the angles array and call the unitCircleLine function with each angle
              ForEach(Array(zip(angles, angleLabels)), id: \.0) { angle, angleLabel in
                  unitCircleLine(from: center, radius: radius, angle: angle, angleLabel: angleLabel)
              }

                // Line from center to current finger position (use touchLocation for red line)
                if dragging {
                    Path { path in
                        path.move(to: center)
                        path.addLine(to: touchLocation) // Use touchLocation here
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .stroke(Color.red, lineWidth: 2)
                }

                // Black line from center to constrained position (calculate on demand)
                Path { path in
                    path.move(to: center)
                    path.addLine(to: constrainToCircle(center: center, position: touchLocation, radius: radius)) // Constrain touchLocation here
                }
               
                .stroke(.blue, style: (StrokeStyle(lineWidth: 4,lineCap: .round)))
              

                // Text for coordinates at the bottom right
                Text("X: \(Int(touchLocation.x)) Y: \(Int(touchLocation.y))")
                    .fontWeight(.black)
                    .padding()
                    .position(x: geometry.size.width - 80, y: geometry.size.height - 40)
            }
        }
        .contentShape(Rectangle())

        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.touchLocation = gesture.location
                    self.dragging = true
                }
                .onEnded { _ in
                    self.dragging = false
                }
        )

    }
  

    func constrainToCircle(center: CGPoint, position: CGPoint, radius: CGFloat) -> CGPoint {
        let dx = position.x - center.x
        let dy = position.y - center.y
        let distance = sqrt(dx * dx + dy * dy)
        
            let scale = radius / distance
            let constrainedX = center.x + dx * scale
            let constrainedY = center.y + dy * scale
            return CGPoint(x: constrainedX, y: constrainedY)
    }
}

// Define the function as an extension to View

extension View {
  func unitCircleLine(from startPoint: CGPoint, radius: CGFloat, angle: Double, angleLabel: String) -> some View {
        let endPoint = CGPoint(
            x: startPoint.x + radius * CGFloat(cos(-angle * .pi / 180)),
            y: startPoint.y + radius * CGFloat(sin(-angle * .pi / 180))
        )

        let textPosition = CGPoint(
            x: endPoint.x + 30 * CGFloat(cos(-angle * .pi / 180)),
            y: endPoint.y + 30 * CGFloat(sin(-angle * .pi / 180))
        )

        // Calculate coordinates for the text
        let xCoord = cos(-angle * .pi / 180)
        let yCoord = sin(-angle * .pi / 180)

        // Format coordinates as a string
        let coordinatesText = String(format: "(%.2f, %.2f)", xCoord, yCoord)

        return ZStack {
            Path { path in
                path.move(to: startPoint)
                path.addLine(to: endPoint)
            }
            .stroke(Color.black, lineWidth: 2)

            Circle()
                .fill(Color.red)
                .frame(width: 10, height: 10)
                .position(endPoint)

          FractionView(equation: angleLabel)
                .position(textPosition)
        }
    }
}

struct MathUILabel: UIViewRepresentable {
    var latex: String

    func makeUIView(context: Context) -> MTMathUILabel {
        let label = MTMathUILabel()
        label.latex = latex
          label.layer.borderColor = UIColor.red.cgColor
          label.layer.borderWidth = 2.0
        return label
    }

    func updateUIView(_ uiView: MTMathUILabel, context: Context) {
        uiView.latex = latex
    }
}
struct MathView: UIViewRepresentable {

    var equation: String
    var fontSize: CGFloat
    
    func makeUIView(context: Context) -> MTMathUILabel {
        let view = MTMathUILabel()
//      view.layer.borderColor = UIColor.red.cgColor
//      view.layer.borderWidth = 2.0
        return view
    }
    
    func updateUIView(_ uiView: MTMathUILabel, context: Context) {
        uiView.latex = equation
        uiView.fontSize = fontSize
//        uiView.font = MTFontManager().termesFont(withSize: fontSize)
        uiView.textAlignment = .center
        uiView.labelMode = .text
    }
}
  

struct FractionView: View {
  var equation: String
    var body: some View {
          MathView(equation: equation, fontSize: 24)
        .frame(width:100, height: 100)
        .padding()
    }
}



#Preview {
    ContentView()
}
