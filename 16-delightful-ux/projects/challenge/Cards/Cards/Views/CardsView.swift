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

struct CardsListView: View {
  @EnvironmentObject var model: Model
  
  let cards = [nil, Card(backgroundColor: .red), Card(backgroundColor: .green), Card(backgroundColor: .blue),
               Card(backgroundColor: .orange), Card(backgroundColor: .pink), Card(backgroundColor: .gray)]
  
  var body: some View {
    print(model.cards.count)
    return NavigationView {
      GeometryReader { geometry in
        VStack {
          ScrollView {
            LazyVGrid(columns: columns(size: geometry.size),
                      spacing: 30) {
              CardAddButton(size: geometry.size)
              ForEach(0..<model.cards.count, id: \.self) { index in
                NavigationLink(
                  destination: ContentView(card: $model.cards[index])
                ) {
                  CardView(color: model.cards[index].backgroundColor,
                           size: geometry.size)
                }
              }
            }
            .padding(.top)
          }
        }
      }
      .navigationBarHidden(true)
    }
    .navigationViewStyle(StackNavigationViewStyle())

  }
  
  func columns(size: CGSize) -> [GridItem] {
    var cardSize = CGSize(width: 150, height: 180)
    if size.width > 500 && size.height > 500 {
      cardSize = CGSize(width: 240, height: 300)
    }
    return [GridItem(.adaptive(minimum: cardSize.width))]
  }
}

struct CardAddButton: View {
  let size: CGSize
  var body: some View {
    ZStack {
      Color.white
        .frame(width: cardSize(size: size).width,
               height: cardSize(size: size).height)
        .cornerRadius(20)
        .shadow(radius: 5)
      Image(systemName: "plus")
        .font(.title)
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

struct CardView: View {
  let color: Color
  let size: CGSize
  var body: some View {
    color
      .frame(width: cardSize(size: size).width,
             height: cardSize(size: size).height)
      .cornerRadius(20)
      .shadow(radius: 5)
  }

  func cardSize(size: CGSize) -> CGSize {
    var cardSize = CGSize(width: 150, height: 180)
    if size.width > 500 && size.height > 500 {
      cardSize = CGSize(width: 240, height: 300)
    }
    return cardSize
  }
}

struct CardsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CardsListView()
        .environmentObject(Model())
    }
  }
}
