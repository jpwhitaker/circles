//
//  DataView.swift
//  Circles
//
//  Created by John-Patrick Whitaker on 6/24/24.
//

import SwiftUI

struct DataView: View {
  @ObservedObject var viewModel: UnitCircleViewModel
  
  var body: some View {
    
    // Additional UI elements such as Text and Buttons
    VStack(alignment: .leading) {
      Text("Angle \(viewModel.angleValue)")
      HStack {
        Text("sin: ")
          .frame(width: 50, alignment: .leading)
        Text("\(viewModel.sinValue, specifier: "%.4f")")
          .frame(width: 90, alignment: .trailing)
          .font(.system(.body, design: .monospaced))
      }
      HStack {
        Text("cos: ")
          .frame(width: 50, alignment: .leading)
        Text("\(viewModel.cosValue, specifier: "%.4f")")
          .frame(width: 90, alignment: .trailing)
          .font(.system(.body, design: .monospaced))
      }
    }
    .padding()
    .fontWeight(.black)
    .padding()
    .position(x: viewModel.frameSize.width - 80, y: viewModel.frameSize.height - 40)
    
    Button("Settings") {
      viewModel.showingBottomSheet.toggle()
    }
    .buttonStyle(.borderedProminent)
    .position(x: 80, y: viewModel.frameSize.height - 40)
  }
}




struct BottomSheetView: View {
  @State var snapping = true
  
  var body: some View {
    Toggle(isOn: $snapping) {
      Text("Snapping")
    }
    .padding()
  }
}


