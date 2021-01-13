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

struct CardModals: ViewModifier {
  @EnvironmentObject var viewState: ViewState
  @Binding var card: Card
  @Binding var currentModal: CardModal?

  @State private var stickerImage: UIImage?
  @State private var images: [UIImage] = []
  @State private var frame: AnyShape?
  @State private var text: String = ""
  @State private var textColor: Color = .black

  func body(content: Content) -> some View {
    content
      .sheet(item: $currentModal) { item in
        switch item {
        case .stickerPicker:
          StickerPicker(stickerImage: $stickerImage)
            .onDisappear {
              if let stickerImage = stickerImage {
                card.addElement(uiImage: stickerImage)
              }
              stickerImage = nil
            }
        case .photoPicker:
          PhotoPicker(images: $images)
            .onDisappear {
              for image in images {
                card.addElement(uiImage: image)
              }
              images = []
            }
        case .framePicker:
          FramePicker(frame: $frame)
            .onDisappear {
              if let frame = frame {
                card.update(viewState.selectedElement, frame: frame)
              }
              frame = nil
            }
        case .textPicker:
          TextPicker(text: $text, textColor: $textColor)
            .onDisappear {
              if !text.isEmpty {
                card.addElement(text: text, textColor: textColor)
              }
              text = ""
            }
        default:
          EmptyView()
        }
      }
  }
}

extension View {
  func cardModals(
    card: Binding<Card>,
    currentModal: Binding<CardModal?>
  ) -> some View {
    modifier(CardModals(card: card, currentModal: currentModal))
  }
}
