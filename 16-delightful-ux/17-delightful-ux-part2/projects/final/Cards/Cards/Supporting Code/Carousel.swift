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
  @State private var frontCardIndex = 0
  @State private var offsets: [CGFloat] = []

  var body: some View {
    VStack {
      GeometryReader { proxy in
        ForEach((0..<model.cards.count).reversed(), id: \.self) { index in
          cardView(model.cards[index])
            .frame(
              width: calculateSize(index: index, size: proxy.size).width,
              height: calculateSize(index: index, size: proxy.size).height)
            .cornerRadius(15)
            .offset(x: calculateOffset(index: index))
            .gesture(dragGesture(index: index, size: proxy.size))
            .shadow(
              color: Color(
                white: 0.5,
                opacity: calculateShadow(index: index)),
              radius: 5)
            .onAppear {
              offsets = [CGFloat](repeating: 0, count: model.cards.count)
              frontCardIndex = 0
            }
            .onTapGesture {
              viewState.selectedCard = model.cards[index]
              withAnimation {
                viewState.showAllCards = false
              }
            }
        }
        .frame(
          width: proxy.size.width,
          height: proxy.size.height * 0.9)
        .offset(CGSize(width: -10, height: 0))
        .padding(.horizontal)
      }
    }
  }

  func dragGesture(index: Int, size: CGSize) -> some Gesture {
    return DragGesture()
      .onChanged { value in
        let leftDrag = value.translation.width < 0
        // right drag drags the previous card
        if leftDrag {
          if index == frontCardIndex && index < model.cards.count - 1 {
            offsets[index] = value.translation.width
          }
        } else {
          if index - 1 >= 0 {
            offsets[index - 1] = -size.width + value.translation.width
          }
        }
      }
      .onEnded { value in
        withAnimation {   // card will animate to final position
          let leftDrag = value.translation.width < 0
          if leftDrag {
            // move card off
            if index == frontCardIndex && index < model.cards.count - 1 {
              if abs(value.translation.width) > size.width / 4 {
                offsets[index] = -size.width
                frontCardIndex += 1
              } else {
                offsets[index] = 0
              }
            }
          } else {
            // bring card back
            if value.translation.width > size.width / 4 {
              if index - 1 >= 0 {
                offsets[index - 1] = 0
                frontCardIndex -= 1
              }
            }
          }
        }
      }
  }

  func cardView(_ card: Card) -> some View {
    ZStack {
      card.backgroundColor
      if let image = card.image {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
    }
  }

  func calculateOffset(index: Int) -> CGFloat {
    if index >= offsets.count { return 0 }
    let offset: CGFloat = 30
    var position = index - frontCardIndex <= 1 ? index - frontCardIndex : 2
    if position < 0 {
      position = 0
    }
    return offsets[index] + CGFloat(position) * offset
  }

  func calculateShadow(index: Int) -> Double {
    let position = abs(frontCardIndex - index)
    return position < 3 ? 0.5 : 0
  }

  func calculateSize(index: Int, size: CGSize) -> CGSize {
    let scaleOffset: CGFloat = 30
    var position = index - frontCardIndex <= 1 ? index - frontCardIndex : 2
    if position < 0 {
      position = 0
    }
    let width = cardWidth(size: size) - scaleOffset * CGFloat(position)
    let aspectRatio = Settings.cardSize.height / Settings.cardSize.width
    let height = width * aspectRatio
    return CGSize(width: width, height: height)
  }

  func cardWidth(size: CGSize) -> CGFloat {
    let cardSize = min(size.width, size.height)
    let padding: CGFloat = 0.25 * cardSize
    let width = cardSize - 2 * padding
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
