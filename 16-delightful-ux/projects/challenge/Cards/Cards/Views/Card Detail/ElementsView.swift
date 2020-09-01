/// Copyright (c) 2020 Razeware LLC
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


struct ElementsView: View {
  @EnvironmentObject var model: Model
  
  @Binding var card: Card
  @Binding var elementSelected: Element?
  @Binding var viewState: ViewState?
  
  @State private var elementForContextMenu: Element?
  
  var body: some View {
    return ZStack {
      Group {
      ForEach(card.elements) { element in
        ZStack {
          ResizableView(id: element.id,
                        transform: element.transform,
                        update: getUpdate(element: element)) {
            ElementView(element: element,
                        isSelected: elementSelected?.id == element.id)
              .onTapGesture {
                elementSelected = element
                if element.elementType == .text {
                  viewState = .textEntry
                }
              }
              .onLongPressGesture {
                withAnimation {
                elementForContextMenu = element
                }
              }
            /*
             // to demonstrate how useful a view builder is
             // it allows multiple views
             Text("Watermark")
             .font(.system(size: 1000))
             .foregroundColor(.white)
             .minimumScaleFactor(0.001)
             .lineLimit(1)
             .rotationEffect(.degrees(30))
             .frame(width: element.transform.size.width,
             height: element.transform.size.height)
             .allowsHitTesting(false)
             */
            
            /*
             // The UI here doesn't work, so use preferences to show a delete menu
             .contextMenu {
             Button(action: {
             card.remove(element)
             model.save(card: card)
             elementSelected = nil
             }) {
             Label("Delete", systemImage: "trash")
             }
             }
             */
          }
        }
      }
    }
    .blur(radius: elementForContextMenu == nil ? 0 : 10)
      if elementForContextMenu != nil {
        ElementContextMenu(elementForContextMenu: $elementForContextMenu, deleteAction: {
          if let element = elementForContextMenu {
            card.remove(element)
          }
          elementForContextMenu = nil
        })
      }
    }
  }
    
  func getUpdate(element: Element) -> ResizableUpdate {
    let update: ResizableUpdate = { transform in
      card.update(element, transform: transform)
    }
    return update
  }
}

struct ElementsView_Previews: PreviewProvider {
  @State static var card = initialCards[0]
  @State static var elementSelected: Element?
  @State static var viewState: ViewState? = nil
  static var previews: some View {
    ElementsView(card: $card,
                 elementSelected: $elementSelected,
                 viewState: $viewState)
      .environmentObject(Model())
  }
}
