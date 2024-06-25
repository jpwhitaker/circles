//
//  UnitCircleModel.swift
//  Circles
//
//  Created by John-Patrick Whitaker on 6/24/24.
//

import Foundation
import Combine
import SwiftUI

class UnitCircleViewModel: ObservableObject {
  @Published var touchLocation: CGPoint = .zero
  @Published var dragging: Bool = false
  @Published var sinValue: CGFloat = 0
  @Published var cosValue: CGFloat = 0
  @Published var angleValue: CGFloat = 0
  @Published var frameSize: CGSize = .zero
  
  @Published var center: CGPoint = .zero
  @Published var radius: CGFloat = 100
  @Published var circleSize: CGFloat = 0
  
  @Published var showingBottomSheet: Bool = false // Added property
  
  init(center: CGPoint, frameSize: CGFloat) {
    self.center = center
    self.circleSize = frameSize * 0.8
    self.radius = self.circleSize / 2
    self.touchLocation = CGPoint(x: center.x + radius, y: center.y)
    updateSinCos()
  }
  
  func updateGeometry(center: CGPoint, frameSize: CGFloat) {
    self.center = center
    self.circleSize = frameSize * 0.8
    self.radius = self.circleSize / 2
  }
  
  func updateSinCos() {
    let dx = touchLocation.x - center.x
    let dy = touchLocation.y - center.y
    let distance = sqrt(dx * dx + dy * dy)
    if distance != 0 {
      sinValue = -dy / distance
      cosValue = dx / distance
      angleValue = atan2(dy, dx)
    } else {
      sinValue = 0
      cosValue = 0
      angleValue = 0
    }
  }
  
  func updateFrameSize(_ size: CGSize) {
    frameSize = size
  }
}
