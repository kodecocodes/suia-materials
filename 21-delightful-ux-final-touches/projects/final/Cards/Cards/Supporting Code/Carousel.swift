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

struct Carousel: View {
  @EnvironmentObject var store: CardStore
  @Binding var selectedCard: Card?

  let thumbnailScale: CGFloat = 0.7
  func cardSize(from proxySize: CGSize) -> CGSize {
    let cardSize = Settings.calculateSize(proxySize)
    return cardSize * thumbnailScale
  }

  var body: some View {
    GeometryReader { proxy in
      TabView {
        ForEach((0..<store.cards.count), id: \.self) { index in
          cardView(store.cards[index])
            .frame(
              width: cardSize(from: proxy.size).width,
              height: cardSize(from: proxy.size).height)
            .cornerRadius(15)
            .shadow(
              color: Color(white: 0.5, opacity: 0.7),
              radius: 5)
            .onTapGesture {
              selectedCard = store.cards[index]
            }
            .offset(y: -proxy.size.height * 0.05)
        }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .tabViewStyle(PageTabViewStyle())
    }
  }

  func cardView(_ card: Card) -> some View {
    Group {
      if let image = loadCardImage(card) {
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
      } else {
        card.backgroundColor
      }
    }
  }

  func loadCardImage(_ card: Card) -> Image? {
    if let uiImage = UIImage.load(uuidString: card.id.uuidString) {
      return Image(uiImage: uiImage)
    }
    return nil
  }
}

struct Carousel_Previews: PreviewProvider {
  static var previews: some View {
    Carousel(selectedCard: .constant(Card()))
      .environmentObject(CardStore(defaultData: true))
  }
}
