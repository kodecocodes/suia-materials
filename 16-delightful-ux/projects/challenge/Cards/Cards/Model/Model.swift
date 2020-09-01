/// Copyright (c) 2020 Razeware LLC
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

class Model: ObservableObject {
  @Published var cards: [Card] = []
  
  init(defaultData: Bool = false) {
    // Elements' UIImages are loaded when the card is selected
    cards = load()
    if defaultData {
        cards = initialCards
    }
  }
  
  // MARK: - Update card data
  func index(for card: Card) -> Int? {
    cards.firstIndex(where: { $0.id == card.id } )
  }
  
  func addCard() {
    let card = Card(backgroundColor: Color.randomColor())
    cards.append(card)
    card.save()
  }
  
  func remove(_ card: Card) {
    if let index = index(for: card) {
      for element in cards[index].elements {
        cards[index].remove(element)
      }
      UIImage.remove(name: "\(card.id)")
      let url = Settings.documentURL(name: "\(card.id).rwcard")
      try? FileManager.default.removeItem(at: url)
      cards.remove(at: index)
    }
  }
}

// MARK: - File I/O

extension Model {
  func load() -> [Card] {
    var cards: [Card] = []
    let path = Settings.documentsDirectory.path
    let fileManager = FileManager.default
    guard let enumerator = fileManager.enumerator(atPath: path),
          let files = enumerator.allObjects as? [String]
    else { return cards }
    let cardFiles = files.filter { $0.contains(".rwcard") }
    for cardFile in cardFiles {
      let decoder = JSONDecoder()
      do {
        let path = path + "/" + cardFile
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let card = try decoder.decode(Card.self, from: data)
        cards.append(card)
      } catch {
        print(error.localizedDescription)
        try? fileManager.removeItem(at: URL(fileURLWithPath: path))
      }
    }
    return cards
  }
}
