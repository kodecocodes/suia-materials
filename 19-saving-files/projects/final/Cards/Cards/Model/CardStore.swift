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

class CardStore: ObservableObject {
  @Published var cards: [Card] = []
  @Published var selectedElement: CardElement?

  init(defaultData: Bool = false) {
    cards = defaultData ? initialCards : load()
  }

  func index(for card: Card) -> Int? {
    cards.firstIndex { $0.id == card.id }
  }

  func remove(_ card: Card) {
    if let index = index(for: card) {
      cards.remove(at: index)
    }
  }

  func addCard() -> Card {
    let card = Card(backgroundColor: Color.random())
    cards.append(card)
    card.save()
    return card
  }
}

extension CardStore {
  func load() -> [Card] {
    var cards: [Card] = []
    let path = URL.documentsDirectory.path
    guard
      let enumerator = FileManager.default
        .enumerator(atPath: path),
      let files = enumerator.allObjects as? [String]
    else { return cards }
    let cardFiles = files.filter { $0.contains(".rwcard") }
    for cardFile in cardFiles {
      do {
        let path = path + "/" + cardFile
        let data =
          try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        let card = try decoder.decode(Card.self, from: data)
        cards.append(card)
      } catch {
        print("Error: ", error.localizedDescription)
      }
    }
    return cards
  }
}
