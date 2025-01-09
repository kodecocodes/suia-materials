/// Copyright (c) 2025 Kodeco Inc.
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
  var viewScale: CGFloat = 1

  func isSelected(_ element: CardElement) -> Bool {
    store.selectedElement?.id == element.id
  }

  var body: some View {
    card.backgroundColor
      .onTapGesture {
        store.selectedElement = nil
      }
      .overlay {
        ForEach($card.elements, id: \.id) { $element in
          CardElementView(element: element)
            .overlay(
              element: element,
              isSelected: isSelected(element))
            .elementContextMenu(
              card: $card,
              element: $element)
            .resizableView(
              transform: $element.transform,
              viewScale: viewScale)
            .frame(
              width: element.transform.size.width,
              height: element.transform.size.height)
            .onTapGesture {
              store.selectedElement = element
            }
        }
      }
      .clipped()
      .onDisappear {
        store.selectedElement = nil
      }
      .dropDestination(for: CustomTransfer.self) { items, location in
        let offset = Settings.calculateDropOffset(
          viewScale: viewScale,
          location: location)
        Task {
          await MainActor.run {
            card.addElements(
              from: items,
              at: offset)
          }
        }
        return !items.isEmpty
      }
  }
}

#Preview {
  @Previewable @State var card = initialCards[0]
  CardDetailView(card: $card, viewScale: 0.3)
    .environmentObject(CardStore(defaultData: true))
}

private extension View {
  @ViewBuilder
  func overlay(
    element: CardElement,
    isSelected: Bool
  ) -> some View {
    if isSelected,
       let element = element as? ImageElement,
       let frameIndex = element.frameIndex {
      let shape = Shapes.shapes[frameIndex]
      self.overlay(shape
        .stroke(lineWidth: Settings.borderWidth)
        .foregroundStyle(Settings.borderColor))
    } else {
      self
        .border(
          Settings.borderColor,
          width: isSelected ? Settings.borderWidth : 0)
    }
  }
}
