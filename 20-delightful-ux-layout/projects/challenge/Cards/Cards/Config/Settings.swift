/// Copyright (c) 2023 Kodeco
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

enum Settings {
  static let cardSize =
    CGSize(width: 1300, height: 2000)
  static let thumbnailSize =
    CGSize(width: 150, height: 250)
  static let defaultElementSize =
    CGSize(width: 800, height: 800)
  static let borderColor: Color = .blue
  static let borderWidth: CGFloat = 5

  static func calculateSize(_ size: CGSize) -> CGSize {
    var newSize = size
    let ratio =
      Settings.cardSize.width / Settings.cardSize.height

    if size.width < size.height {
      newSize.height = min(size.height, newSize.width / ratio)
      newSize.width = min(size.width, newSize.height * ratio)
    } else {
      newSize.width = min(size.width, newSize.height * ratio)
      newSize.height = min(size.height, newSize.width / ratio)
    }
    return newSize
  }

  static func calculateScale(_ size: CGSize) -> CGFloat {
    let newSize = calculateSize(size)
    return newSize.width / Settings.cardSize.width
  }
}

// use this method for
// the drag and drop challenge
extension Settings {
  static func calculateDropOffset(
    proxy: GeometryProxy?,
    location: CGPoint
  ) -> CGSize {
    guard
      let proxy,
      proxy.size.width > 0 && proxy.size.height > 0
    else { return .zero }

    // `frame` is a CGRect bounding the whole area including margins
    // surrounding the card
    /*
      The frame is in *global* coordinates.
      To illustrate what a coordinate space is, all card offsets are saved
      with the origin being at the center of the card.
      The origin is location (0, 0).
      However, `location` is in screen coordinates,
      where the origin is at the top left of the screen.
      So you must convert from “screen space” to “card space”.
      */
    let frame = proxy.frame(in: .global)

    // size is the calculated card size without margins
    let size = proxy.size

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
