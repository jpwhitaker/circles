import SwiftUI
import SwiftMath

struct ContentView: View {
  @State private var touchLocation: CGPoint = .zero
  @State private var dragging: Bool = false
  @State var showingBottomSheet = false
  
  @StateObject var viewModel: UnitCircleViewModel  // Declaration
  
  init() {
    // Instantiating the ViewModel with default values, these will be updated once the geometry is known
    _viewModel = StateObject(wrappedValue: UnitCircleViewModel(center: CGPoint(x: 0, y: 0), frameSize: 0))
  }
  
  var body: some View {
    GeometryReader { geometry in
      let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
      let frameSize = min(geometry.size.width, geometry.size.height)
      
      ZStack {
        UnitCircle(center: viewModel.center, radius: viewModel.radius)
        TouchLine(viewModel: viewModel)
      }
      .onAppear {
        viewModel.updateGeometry(center: center, frameSize: frameSize)
        viewModel.updateFrameSize(geometry.size)
      }
      .onChange(of: viewModel.frameSize) {
        viewModel.updateFrameSize(viewModel.frameSize)
      }
      .contentShape(Rectangle())  // Makes the entire ZStack tappable and draggable
      .gesture(
        DragGesture()
          .onChanged { gesture in
            viewModel.touchLocation = gesture.location  // Update the viewModel with the new location
            viewModel.dragging = true
            viewModel.updateSinCos()
          }
          .onEnded { _ in
            viewModel.dragging = false
          }
      )
      
      DataView(viewModel: viewModel)
        .sheet(isPresented: $viewModel.showingBottomSheet, content: {
        BottomSheetView()
          .presentationDetents([.fraction(0.2), .medium])
      })
    }
  }
}





#Preview {
  ContentView()
}
