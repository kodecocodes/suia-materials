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

struct CardThumbView: View {
  let isButton: Bool
  let card: Card?
  let size: CGSize
  
  var body: some View {
    if isButton {
      CardAddButton(size: cardSize(size: size))
    } else {
      Group {
        if let card = card {
          if let image = card.image {
            ZStack {
              card.backgroundColor
              Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            }
          } else {
            card.backgroundColor
          }
        }
      }
      .frame(width: cardSize(size: size).width,
             height: cardSize(size: size).height)
      .cornerRadius(20).shadow(radius: 5)
    }
  }
  
  func cardSize(size: CGSize) -> CGSize {
    var cardSize = CGSize(width: 150, height: 180)
    if size.width > 500 && size.height > 500 {
      cardSize = CGSize(width: 240, height: 300)
    }
    return cardSize
  }
}

struct CardThumbView_Previews: PreviewProvider {
  static let isButton = false
  static let card = initialCards[0]
  static let size = CGSize(width: 150, height: 200)

  static var previews: some View {
    CardThumbView(isButton: isButton,
                  card: card,
                  size: size)
  }
}
