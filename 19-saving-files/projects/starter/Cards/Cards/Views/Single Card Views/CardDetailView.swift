/// Copyright (c) 2022 Razeware LLC
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

struct CardDetailView: View {
  @EnvironmentObject var store: CardStore
  @Binding var card: Card

  func isSelected(_ element: CardElement) -> Bool {
    if let selected = store.selectedElement,
      element.id == selected.id {
      return true
    }
    return false
  }

  var body: some View {
    ZStack {
      card.backgroundColor
        .onTapGesture {
          store.selectedElement = nil
        }
      ForEach($card.elements, id: \.id) { $element in
        CardElementView(element: element)
          .clip(element: element)
          .contentShape(element: element)
          .overlay(
            element: element,
            isSelected: isSelected(element))
          .elementContextMenu(
            card: $card,
            element: $element)
          .resizableView(transform: $element.transform)
          .frame(
            width: element.transform.size.width,
            height: element.transform.size.height)
          .onTapGesture {
            store.selectedElement = element
          }
      }
    }
    .onDisappear {
      store.selectedElement = nil
    }
    .dropDestination(for: CustomTransfer.self) { items, location in
      print(location)
      Task {
        card.addElements(from: items)
      }
      return !items.isEmpty
    }
  }
}

struct CardDetailView_Previews: PreviewProvider {
  struct CardDetailPreview: View {
    @EnvironmentObject var store: CardStore
    var body: some View {
      CardDetailView(card: $store.cards[0])
    }
  }

  static var previews: some View {
    CardDetailPreview()
      .environmentObject(CardStore(defaultData: true))
  }
}

extension View {
  @ViewBuilder
  func clip(element: CardElement) -> some View {
    if let element = element as? ImageElement,
      let frameIndex = element.frameIndex {
      self.clipShape(Shapes.shapes[frameIndex])
    } else {
      self
    }
  }

  @ViewBuilder
  func overlay(
    element: CardElement,
    isSelected: Bool
  ) -> some View {
    if isSelected,
      let element = element as? ImageElement,
      let frameIndex = element.frameIndex {
      self.overlay(Shapes.shapes[frameIndex]
        .stroke(lineWidth: Settings.borderWidth)
        .foregroundColor(Settings.borderColor))
    } else {
      self
        .border(
          Settings.borderColor,
          width: isSelected ? Settings.borderWidth : 0)
    }
  }

  @ViewBuilder
  func contentShape(element: CardElement) -> some View {
    if let element = element as? ImageElement,
      let frameIndex = element.frameIndex {
      self.contentShape(Shapes.shapes[frameIndex])
    } else {
      self
    }
  }
}
