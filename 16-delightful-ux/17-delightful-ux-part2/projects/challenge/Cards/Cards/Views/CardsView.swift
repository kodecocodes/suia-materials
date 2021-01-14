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

// extracted out CardsListView and SingleCardView
// selected card and whether to show the single card are held
// in the view state environment object as published values,
// so that you don't need to pass them around
// They need to be published so that views redraw when the value changes
// Add button removed

struct CardsView: View {
  @EnvironmentObject var model: Model
  @EnvironmentObject var viewState: ViewState

  var body: some View {
    VStack {
      if viewState.showAllCards {
        ListSelectionView(selection: $viewState.cardListState)
      }
      ZStack {
        switch viewState.cardListState {
        case .list:
          CardsListView()
        case .carousel:
          Carousel()
        }
        VStack {
          Spacer()
          createButton
        }
        if !viewState.showAllCards {
          SingleCardView()
            .transition(.move(edge: .bottom))
            .zIndex(1)
        }
      }
      .background(
        Color("background")
        .edgesIgnoringSafeArea(.all))
    }
  }

  var createButton: some View {
  // 1
    Button(action: {
      viewState.selectedCard = model.addCard()
      viewState.showAllCards = false
      // swiftlint:disable:next multiple_closures_with_trailing_closure
    }) {
      Label("Create New", systemImage: "plus")
        .frame(maxWidth: .infinity)
    }
    .font(.system(size: 16, weight: .bold))
  // 2
    .padding([.top, .bottom], 10)
  // 3
    .background(Color("barColor"))
    .accentColor(.white)
  }
}

struct CardsView_Previews: PreviewProvider {
  static var previews: some View {
    CardsView()
      .environmentObject(Model(defaultData: true))
      .environmentObject(ViewState())
  }
}
