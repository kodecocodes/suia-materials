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

struct Card: Identifiable {
  var id = UUID()
  var backgroundColor: Color = .yellow
  var elements: [CardElement] = []

  mutating func addElement(uiImage: UIImage) {
    let imageFilename = uiImage.save()
    let element = ImageElement(
      uiImage: uiImage,
      imageFilename: imageFilename)
    elements.append(element)
    save()
  }

  mutating func addElement(text: TextElement) {
    elements.append(text)
  }

  mutating func addElements(from transfer: [CustomTransfer]) {
    for element in transfer {
      if let text = element.text {
        addElement(text: TextElement(text: text))
      } else if let image = element.image {
        addElement(uiImage: image)
      }
    }
  }

  mutating func remove(_ element: CardElement) {
    if let element = element as? ImageElement {
      UIImage.remove(name: element.imageFilename)
    }
    if let index = element.index(in: elements) {
      elements.remove(at: index)
    }
    save()
  }

  mutating func update(_ element: CardElement?, frameIndex: Int) {
    if let element = element as? ImageElement,
      let index = element.index(in: elements) {
        var newElement = element
        newElement.frameIndex = frameIndex
        elements[index] = newElement
    }
  }

  func save() {
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let data = try encoder.encode(self)
      let filename = "\(id).rwcard"
      let url = URL.documentsDirectory
        .appendingPathComponent(filename)
      try data.write(to: url)
    } catch {
      print(error.localizedDescription)
    }
  }
}

extension Card: Codable {
  enum CodingKeys: CodingKey {
    case id, backgroundColor, imageElements, textElements
  }

  init(from decoder: Decoder) throws {
    let container = try decoder
      .container(keyedBy: CodingKeys.self)
    let id = try container.decode(String.self, forKey: .id)
    self.id = UUID(uuidString: id) ?? UUID()
    elements += try container.decode(
      [ImageElement].self, forKey: .imageElements)
    elements += try container.decode([TextElement].self, forKey: .textElements)
    let components = try container.decode([CGFloat].self, forKey: .backgroundColor)
    backgroundColor = Color.color(components: components)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id.uuidString, forKey: .id)
    let imageElements: [ImageElement] =
      elements.compactMap { $0 as? ImageElement }
    try container.encode(imageElements, forKey: .imageElements)
    let textElements: [TextElement] =
      elements.compactMap { $0 as? TextElement }
    try container.encode(textElements, forKey: .textElements)
    let components = backgroundColor.colorComponents()
    try container.encode(components, forKey: .backgroundColor)
  }
}
