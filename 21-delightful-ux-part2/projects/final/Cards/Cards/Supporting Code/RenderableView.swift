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

// This is a pass-through ViewBuilder with simple screenshot ability
// It watches viewState.shouldScreenshot, and when it is true,
// it takes a full screenshot.
// It takes a thumbnail screenshot when the view is taken down
// and saves it to documents with the same filename as the card id.

struct RenderableView<Content>: View where Content: View {
  @EnvironmentObject var viewState: ViewState

  let content: () -> Content
  @Binding var card: Card

  init(
    card: Binding<Card>,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content
    self._card = card
  }

  var body: some View {
    content()
      // Share
      .onChange(of: viewState.shouldScreenshot) { _ in
        if viewState.shouldScreenshot {
          viewState.shouldScreenshot = false
          card.shareImage = content().screenShot(size: Settings.cardSize)
        }
      }
      // Thumbnail
      .onDisappear {
        DispatchQueue.main.async {
          if let image = content().screenShot(size: Settings.thumbnailSize(size: Settings.cardSize)) {
            _ = image.save(to: card.id.uuidString)
            card.image = image
          }
        }
      }
  }
}

private extension View {
  func screenShot(size: CGSize) -> UIImage? {
    let controller = UIHostingController(rootView: self)
    guard let renderView = controller.view,
      let window = UIApplication.shared.windows.first else { return nil }
    renderView.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
    window.rootViewController?.view.addSubview(renderView)

    let viewSize = controller.sizeThatFits(in: size)
    renderView.bounds = CGRect(origin: .zero, size: viewSize)
    renderView.sizeToFit()

    let image = UIGraphicsImageRenderer(bounds: renderView.bounds).image { _ in
      renderView.drawHierarchy(in: renderView.bounds, afterScreenUpdates: true)
    }
    renderView.removeFromSuperview()
    return image.resize(to: size)
  }
}
