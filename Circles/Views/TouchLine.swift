//
//  UnitCircleLine.swift
//  Circles
//
//  Created by John-Patrick Whitaker on 6/15/24.
//
import SwiftUI

struct TouchLine: View {
  @Binding var touchLocation: CGPoint
  @Binding var dragging: Bool
  var center: CGPoint
  var radius: CGFloat
  var onUpdate: (CGPoint, CGPoint, CGFloat, CGFloat) -> Void

  @State private var sinValue: CGFloat = 0
  @State private var cosValue: CGFloat = 0
  
  var body: some View {
    ZStack {
      // Line from center to current finger position (use touchLocation for red line)
      if dragging {
        Path { path in
          path.move(to: center)
          path.addLine(to: touchLocation) // Use touchLocation here
        }
        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
        .stroke(Color.red, lineWidth: 2)
      }
      
      //Blue line from center to constrained position
      Path { path in
        path.move(to: center)
        path.addLine(to: constrainToCircle(center: center, position: touchLocation, radius: radius)) // Constrain touchLocation here
      }
      .stroke(.blue, style: (StrokeStyle(lineWidth: 4, lineCap: .round)))
    }
    .contentShape(Rectangle())
    .gesture(
      DragGesture()
        .onChanged { gesture in
          self.touchLocation = gesture.location
          self.dragging = true
          let constrainedPosition = constrainToCircle(center: center, position: touchLocation, radius: radius)
          self.updateSinCos(touchLocation: touchLocation, constrainedPosition: constrainedPosition)
        }
        .onEnded { _ in
          self.dragging = false
        }
    )
    .onAppear {
      // Initialize touchLocation to point (0,0) on the unit circle
      self.touchLocation = CGPoint(x: center.x + radius, y: center.y)
      let constrainedPosition = constrainToCircle(center: center, position: touchLocation, radius: radius)
      self.updateSinCos(touchLocation: touchLocation, constrainedPosition: constrainedPosition)
    }
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
  
  func updateSinCos(touchLocation: CGPoint, constrainedPosition: CGPoint) {
      let dx = constrainedPosition.x - center.x
      let dy = constrainedPosition.y - center.y
      let distance = sqrt(dx * dx + dy * dy)
      
    // Calculate sine and cosine
    if distance != 0 {
        self.sinValue = -dy / distance
        self.cosValue = dx / distance

        // Correct very small sine and cosine values close to zero
        if abs(self.sinValue) < 1e-10 {
            self.sinValue = 0
        }
        if abs(self.cosValue) < 1e-10 {
            self.cosValue = 0
        }
    } else {
        self.sinValue = 0
        self.cosValue = 0
    }
    self.onUpdate(touchLocation, constrainedPosition, sinValue, cosValue)

  }
}

#Preview {
  ContentView()
}
