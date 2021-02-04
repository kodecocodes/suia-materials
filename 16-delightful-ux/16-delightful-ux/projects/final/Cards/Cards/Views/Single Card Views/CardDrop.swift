/// Copyright (c) 2021 Razeware LLC
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

struct CardDrop: DropDelegate {
  @Binding var card: Card
  var size: CGSize = .zero
  var frame: CGRect = .zero

  func performDrop(info: DropInfo) -> Bool {
    let itemProviders = info.itemProviders(for: [.image])

    for item in itemProviders {
      if item.canLoadObject(ofClass: UIImage.self) {
        item.loadObject(ofClass: UIImage.self) { image, _ in
          if let image = image as? UIImage {
            DispatchQueue.main.async {
              let offset = calculateOffset(location: info.location)
              let transform = Transform(offset: offset)
              card.addElement(uiImage: image, transform: transform)
            }
          }
        }
      }
    }
    return true
  }

  func calculateOffset(location: CGPoint) -> CGSize {
    guard size.width > 0 && size.height > 0 else { return .zero }
    // `frame` is a CGRect bounding the whole area including margins
    // surrounding the card
    // size is the calculated card size without margins

    // margins are the frame around the card
    // plus the frame's origin, if the frame is inset
    let leftMargin = (frame.width - size.width) * 0.5 + frame.origin.x
    let topMargin = (frame.height - size.height) * 0.5 + frame.origin.y

    // location is in screen coordinates
    // convert location from screen space to card space
    // top left of the screen is the old origin
    // top left of the card is the new origin
    var cardLocation = CGPoint(x: location.x - leftMargin, y: location.y - topMargin)

    // convert cardLocation into the fixed card coordinate space
    // so that the location is in 1300 x 2000 space
    cardLocation.x = cardLocation.x / size.width * Settings.cardSize.width
    cardLocation.y = cardLocation.y / size.height * Settings.cardSize.height

    // calculate the offset where 0, 0 is at the center of the card
    let offset = CGSize(
      width: cardLocation.x - Settings.cardSize.width * 0.5,
      height: cardLocation.y - Settings.cardSize.height * 0.5)
    return offset
  }
}
