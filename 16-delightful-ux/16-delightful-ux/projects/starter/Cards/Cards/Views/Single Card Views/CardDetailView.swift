///// Copyright (c) 2021 Razeware LLC
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
  @EnvironmentObject var model: Model
  @EnvironmentObject var viewState: ViewState
  @Environment(\.scenePhase) private var scenePhase
  @Binding var card: Card
  @State private var currentModal: CardModal?

  var body: some View {
    content
    .onChange(of: scenePhase) { newScenePhase in
      if newScenePhase == .inactive {
        card.save()
      }
    }
    .onDisappear {
      card.save()
    }
    .cardToolbar(currentModal: $currentModal)
    .cardModals(card: $card, currentModal: $currentModal)
  }

  func boundTransform(for element: CardElement)
    -> Binding<Transform> {
    guard let index = element.index(in: card.elements) else {
      fatalError("Element does not exist")
    }
    return $card.elements[index].transform
  }

  var content: some View {
    ZStack {
      card.backgroundColor
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
          viewState.selectedElement = nil
        }
        .onDrop(
          of: [.image],
          delegate: CardDrop(card: $card))
      ForEach(card.elements, id: \.id) { element in
        CardElementView(
          element: element,
          selected: viewState.selectedElement?.id == element.id)
          .contextMenu {
            // swiftlint:disable:next multiple_closures_with_trailing_closure
            Button(action: { card.remove(element) }) {
              Label("Delete", systemImage: "trash")
            }
          }
          .resizableView(transform: boundTransform(for: element))
          .frame(
            width: element.transform.size.width,
            height: element.transform.size.height)
          .onTapGesture {
            viewState.selectedElement = element
          }
      }
    }
  }
}

struct CardDetailView_Previews: PreviewProvider {
  struct CardDetailPreview: View {
    @State private var card = initialCards[0]
    var body: some View {
      CardDetailView(
        card: $card)
        .environmentObject(Model(defaultData: true))
        .environmentObject(ViewState())
    }
  }
  static var previews: some View {
    NavigationView {
      CardDetailPreview()
    }
  }
}
