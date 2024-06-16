import SwiftUI
import SwiftMath



struct ContentView: View {
  @State private var touchLocation: CGPoint = .zero
  @State private var dragging: Bool = false
  @State var showingBottomSheet = false
  @State private var sinValue: CGFloat = 0
  @State private var cosValue: CGFloat = 0
  
  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      GeometryReader { geometry in
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let frameSize = min(geometry.size.width, geometry.size.height)
        let circleSize = frameSize * 0.8
        let radius = circleSize / 2
        
        UnitCircle(center: center, radius: radius)
        TouchLine(
          touchLocation: $touchLocation,
          dragging: $dragging,
          center: center,
          radius: radius
        ){
          touchLocation, updatedLocation, sinValue, cosValue in
          self.touchLocation = touchLocation
          self.sinValue = sinValue
          self.cosValue = cosValue
        }
        
        
        VStack(alignment: .leading) {
            HStack {
                Text("sin: ")
                    .frame(width: 50, alignment: .leading) // Fixed width for the label
                Text("\(sinValue, specifier: "%.4f")")
                    .frame(width: 90, alignment: .trailing) // Fixed width for the value
                    .font(.system(.body, design: .monospaced)) // Apply monospaced font
            }
            HStack {
                Text("cos: ")
                    .frame(width: 50, alignment: .leading) // Fixed width for the label
                Text("\(cosValue, specifier: "%.4f")")
                    .frame(width: 90, alignment: .trailing) // Fixed width for the value
                    .font(.system(.body, design: .monospaced)) // Apply monospaced font
            }
        }
        .padding()
        .fontWeight(.black)
        .padding()
        .position(x: geometry.size.width - 80, y: geometry.size.height - 40)

        
        Button("Settings"){
          showingBottomSheet.toggle()
        }
        .buttonStyle(.borderedProminent)
        
        .position(x:  80, y: geometry.size.height - 40)
      }
      
      .sheet(isPresented: $showingBottomSheet, content: {
        BottomSheetView()
          .presentationDetents([.fraction(0.2), .medium])
      })
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
}

struct BottomSheetView: View{
  @State var snapping = true
  
  var body: some View {
    
    Toggle(isOn: $snapping) {
      Text("Snapping")
    }
    .padding()
  }
  
}

#Preview {
  ContentView()
}
