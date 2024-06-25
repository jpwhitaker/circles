import SwiftUI
import SwiftMath

struct UnitCircle: View {
  let center: CGPoint
  let radius: CGFloat
  
  let angles: [Double] = [0, 30, 45, 60, 90, 120, 135, 150, 180, 210, 225, 240, 270, 300, 315, 330]
  let angleLabels: [String] = [
    "0", "\\frac{\\pi}{6}", "\\frac{\\pi}{4}", "\\frac{\\pi}{3}", "\\frac{\\pi}{2}",
    "\\frac{2\\pi}{3}", "\\frac{3\\pi}{4}", "\\frac{5\\pi}{6}", "\\pi",
    "\\frac{7\\pi}{6}", "\\frac{5\\pi}{4}", "\\frac{4\\pi}{3}", "\\frac{3\\pi}{2}",
    "\\frac{5\\pi}{3}", "\\frac{7\\pi}{4}", "\\frac{11\\pi}{6}"
  ]
  @State private var animateLines = false
  @State private var animateOpacity = false
  @State private var animateDots = false

  
  
  var body: some View {
    ZStack {
      // Circle at the center
      Circle()
        .fill(Color.white)
        .overlay(Circle().stroke(Color.blue, lineWidth: 4))
        .frame(width: radius * 2, height: radius * 2)
        .position(center)
      
      // Loop over the angles array and call the unitCircleLine function with each angle
      ForEach(Array(angles.enumerated()), id: \.offset) { index, angle in
        unitCircleLine(from: center, radius: radius, angle: angle, index: index)
          .rotationEffect(animateLines ? .degrees(-angle) : .degrees(0), anchor: .center)
          .animation(Animation.linear(duration: 0.5).delay(Double(index) * 0.15), value: animateLines)
          .opacity(animateOpacity ? 1.0 : 0.0)
          .animation(Animation.easeOut(duration: 0.5).delay(Double(index) * 0.15), value: animateOpacity)
        
        
      }
      
      
      ForEach(Array(zip(angles.enumerated(), angleLabels)), id: \.0.offset) { indexAndAngle, angleLabel in
        let (index, angle) = indexAndAngle
        unitCirclePoints(from: center, radius: radius, angle: angle, angleLabel: angleLabel)
          .opacity(animateDots ? 1.0 : 0.0)
          .animation(Animation.linear(duration: 0.5).delay((0.14) + Double(index) * 0.15), value: animateDots)
      }
      
      ForEach(Array(zip(angles, angleLabels)), id: \.0) { angle, angleLabel in
        unitCircleLabels(from: center, radius: radius, angle: angle, angleLabel: angleLabel)
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        animateLines = true
        animateOpacity = true
        animateDots = true
      }
    }
  }
}

extension View {
  func unitCircleLine(from startPoint: CGPoint, radius: CGFloat, angle: Double, index: Int) -> some View {
    let endPoint = CGPoint(
      x: startPoint.x + radius * CGFloat(cos(-angle * .pi / 180)),
      y: startPoint.y + radius * CGFloat(sin(-angle * .pi / 180))
    )
    
    return ZStack {
      Path { path in
        path.move(to: startPoint)
        path.addLine(to: endPoint)
      }
      .stroke(Color.black, lineWidth: 2)
    }
    .rotationEffect(.degrees(angle), anchor: .center)
  }
}

extension View {
  func unitCirclePoints(from startPoint: CGPoint, radius: CGFloat, angle: Double, angleLabel: String) -> some View {
    let endPoint = CGPoint(
      x: startPoint.x + radius * CGFloat(cos(-angle * .pi / 180)),
      y: startPoint.y + radius * CGFloat(sin(-angle * .pi / 180))
    )
    
    let textPosition = CGPoint(
      x: endPoint.x + 30 * CGFloat(cos(-angle * .pi / 180)),
      y: endPoint.y + 30 * CGFloat(sin(-angle * .pi / 180))
    )
    
    return ZStack {
      
      Circle()
        .fill(Color.red)
        .frame(width: 10, height: 10)
        .position(endPoint)
      
    }
  }
}


extension View {
  func unitCircleLabels(from startPoint: CGPoint, radius: CGFloat, angle: Double, angleLabel: String) -> some View {
    let endPoint = CGPoint(
      x: startPoint.x + radius * CGFloat(cos(-angle * .pi / 180)),
      y: startPoint.y + radius * CGFloat(sin(-angle * .pi / 180))
    )
    
    let textPosition = CGPoint(
      x: endPoint.x + 30 * CGFloat(cos(-angle * .pi / 180)),
      y: endPoint.y + 30 * CGFloat(sin(-angle * .pi / 180))
    )
    
    return ZStack {
      LabelView(equation: angleLabel)
        .position(textPosition)
    }
  }
}

#Preview {
  ContentView()
}
