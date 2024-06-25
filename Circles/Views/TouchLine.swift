//
//  TouchLine.swift
//  Circles
//
//  Created by John-Patrick Whitaker on 6/15/24.
//
import SwiftUI
import CoreHaptics
//

struct TouchLine: View {
  @ObservedObject var viewModel: UnitCircleViewModel
  var hapticService = HapticFeedbackService()
  
  var body: some View {
    ZStack {
      if viewModel.dragging {
        Path { path in
          path.move(to: viewModel.center)
          path.addLine(to: viewModel.touchLocation)
        }
        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
        .stroke(Color.red, lineWidth: 2)
      }
      
      Path { path in
        path.move(to: viewModel.center)
        path.addLine(to: constrainToCircle(center: viewModel.center, position: viewModel.touchLocation, radius: viewModel.radius))
      }
      .stroke(.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
    }
  }
  
  func constrainToCircle(center: CGPoint, position: CGPoint, radius: CGFloat) -> CGPoint {
    let dx = position.x - center.x
    let dy = position.y - center.y
    let distance = sqrt(dx * dx + dy * dy)
    let scale = radius / distance
    return CGPoint(x: center.x + dx * scale, y: center.y + dy * scale)
  }
}


#Preview {
  ContentView()
}
