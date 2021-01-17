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

struct CarouselCards {
  let card: Card
  var offset: CGFloat = 0
  var image: UIImage?
}

struct Carousel: View {
  @EnvironmentObject var model: Model
  @EnvironmentObject var viewState: ViewState

  var body: some View {
    GeometryReader { proxy in
      TabView {
        ForEach((0..<model.cards.count), id: \.self) { index in
          cardView(model.cards[index])
            .frame(
              width: calculateSize(index: index, size: proxy.size).width,
              height: calculateSize(index: index, size: proxy.size).height)
            .cornerRadius(15)
            .shadow(
              color: Color(white: 0.5, opacity: 0.7),
              radius: 5)
            .onTapGesture {
              viewState.selectedCard = model.cards[index]
              withAnimation {
                viewState.showAllCards = false
              }
            }
            .offset(y: -proxy.size.height * 0.1)
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

  func calculateSize(index: Int, size: CGSize) -> CGSize {
    let width = cardWidth(size: size)
    let aspectRatio = Settings.cardSize.height / Settings.cardSize.width
    let height = width * aspectRatio
    return CGSize(width: width, height: height)
  }

  func cardWidth(size: CGSize) -> CGFloat {
    let cardSize = min(size.width, size.height)
    let width = cardSize * 0.8
    return width
  }
}

struct Carousel_Previews: PreviewProvider {
  static var previews: some View {
    Carousel()
      .environmentObject(Model(defaultData: true))
      .environmentObject(ViewState())
  }
}
