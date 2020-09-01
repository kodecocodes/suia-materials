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

struct CardScrollView: View {
  @EnvironmentObject var model: Model
  @Binding var isPresented: Bool
  @Binding var selectedIndex: Int
  let size: CGSize
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns(size: size),
                spacing: 30) {
        CardThumbView(isButton: true,
                      card: nil,
                      size: size)
          .onTapGesture {
            model.addCard()
            selectedIndex = model.cards.count - 1
            withAnimation {
              isPresented.toggle()
            }
          }
        ForEach(0..<model.cards.count, id: \.self) { index in
          CardThumbView(isButton: false,
                        card: model.cards[index],
                        size: size)
            .onTapGesture {
              selectedIndex = index
              withAnimation {
                isPresented.toggle()
              }
            }
            .contextMenu {
              Button(action: {
                model.remove(model.cards[index])
              }) {
                Label("Delete", systemImage: "trash")
              }
            }
        }
      }
      .padding()
    }
  }
  
  func columns(size: CGSize) -> [GridItem] {
    var cardSize = CGSize(width: 150, height: 180)
    if size.width > 500 && size.height > 500 {
      cardSize = CGSize(width: 240, height: 300)
    }
    return [GridItem(.adaptive(minimum: cardSize.width))]
  }
}

struct CardScrollView_Previews: PreviewProvider {
  @State static private var isPresented = false
  @State static private var selectedIndex = 0
  @Namespace static var namespace
  static var previews: some View {
    CardScrollView(isPresented: $isPresented,
                   selectedIndex: $selectedIndex,
                   size: CGSize(width: 400, height: 700))
  }
}
