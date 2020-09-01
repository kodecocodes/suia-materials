///// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

enum ViewState: Identifiable {
  case imagePicker, colorPicker, clipShapes
  
  var id: Int {
    self.hashValue
  }
}

struct CardView: View {
  @EnvironmentObject var model: Model
  
  // Modal View Options
  @State private var viewState: ViewState?
  @State private var images: [UIImage] = []
  @State private var shapeIndex: Int?
  @State private var elementSelected: Element?
  @State private var backgroundColor = Color.red
  
  @Binding var card: Card
  
  var body: some View {
    return GeometryReader { geometry in
      
      ZStack {
        backgroundColor
          .onTapGesture {
            elementSelected = nil
          }
        ElementsView(card: $card, elementSelected: $elementSelected)
      }
      .onDisappear {
        // save data
        print("saving data")
      }

    .edgesIgnoringSafeArea(.all)
    .toolbar {
      ToolbarItem(placement: .bottomBar) {
        CardViewToolbar(viewState: $viewState,
                        elementSelected: elementSelected != nil)
      }
    }
    .sheet(item: $viewState) { item in
      switch item {
      case .imagePicker:
        ImagePicker(images: $images)
          .onDisappear {
            for image in images {
              model.add(image: image)
            }
            images = []
          }
      case .colorPicker:
        ColorPickerView(backgroundColor: $backgroundColor)
      case .clipShapes:
        if let element = elementSelected {
          ClipShapesView(shapeIndex: $shapeIndex,
                         image: element.image)
            .onDisappear {
              if let shapeIndex = shapeIndex,
                 let index = model.elements.firstIndex(where: { $0.id == elementSelected?.id } ) {
                model.elements[index].clipShape = clipShapes[shapeIndex]
                model.elements[index].clipShapeIndex = shapeIndex
              }
              shapeIndex = nil
            }
        }
      }
    }
    .onDrop(of: [.image], isTargeted: nil) { itemProviders, location in
      if let provider = itemProviders.first {
        if provider.canLoadObject(ofClass: UIImage.self) {
          provider.loadObject(ofClass: UIImage.self) { image, error in
            if let image = image as? UIImage {
              DispatchQueue.main.async {
                let offsetX = location.x - geometry.size.width / 2
                let offsetY = location.y - geometry.size.height / 2
                model.add(image: image, offset: CGSize(width: offsetX, height: offsetY))
              }
            }
          }
        }
        return true
      }
      return false
    }
    }

  }
}

struct ContentView_Previews: PreviewProvider {
  @State private static var card = Card(backgroundColor: .yellow)
  static var previews: some View {
    NavigationView {
      CardView(card: $card)
        .environmentObject(Model())
    }
    
  }
}
