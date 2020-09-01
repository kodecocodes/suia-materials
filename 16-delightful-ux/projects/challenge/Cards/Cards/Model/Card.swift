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

struct Card: Identifiable {
  var id = UUID().uuidString
  var name = "Untitled"
  var backgroundColor: Color
  var image: UIImage?
  var elements: [Element] = []

  func index(for element: Element) -> Int? {
    elements.firstIndex(where: { $0.id == element.id } )
  }

  // MARK: - Load elements
  mutating func loadScreenshot() {
    if let image = UIImage.load(uuid: id) {
      self.image = image
    }
  }
  
  mutating func loadElements() {
    for (index, element) in elements.enumerated() {
      if let clipShapeIndex = elements[index].clipShapeIndex {
        elements[index].clipShape = clipShapes[clipShapeIndex]
      }
      if let imageName = element.imageFilename {
        let image = UIImage.load(uuid: imageName)
        elements[index].image = image
      }
    }
  }

  // MARK: - Remove element
  
  mutating func remove(_ element: Element) {
    if let index = index(for: element) {
      UIImage.remove(name: element.imageFilename)
      elements.remove(at: index)
    }
    save()
  }
  
  // MARK: - Add element
  
  mutating func addElement(image: UIImage, offset: CGSize = .zero) {
    let uuid = image.save()
    var transform = Transform()
    transform.size = image.initialSize()
    transform.offset = offset
    transform.offset.height -= transform.size.height / 2
    let element = Element(transform: transform,
                          image: image,
                          imageFilename: uuid,
                          elementType: .image)
    elements.append(element)
    save()
  }
  
  mutating func addTextElement(_ element: Element) {
    let element = Element(transform: Transform(),
                          text: element.text,
                          textColor: element.textColor,
                          elementType: .text)
    elements.append(element)
    save()
  }
  
  // MARK: - Update element
  
  mutating func update(_ element: Element,
                       textElement: Element) {
    if let index = index(for: element) {
      elements[index].text = textElement.text
      elements[index].textColor = textElement.textColor
    }
    save()
  }
  
  mutating func update(_ element: Element,
                       transform: Transform) {
    if let index = index(for: element) {
      elements[index].transform = transform
    }
    save()
  }
  
  mutating func update(_ element: Element,
                       shapeIndex: Int) {
    if let index = index(for: element) {
      elements[index].clipShape = clipShapes[shapeIndex]
      elements[index].clipShapeIndex = shapeIndex
    }
    save()
  }
}

extension Card: Codable {
  
  enum CodingKeys: CodingKey {
    case id, name, backgroundColor, elementsData
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    let color = backgroundColor.colorComponents()
    try container.encode(color, forKey: .backgroundColor)
    try container.encode(name, forKey: .name)
    let elementsData = elements.map { $0.data }
    try container.encode(elementsData, forKey: .elementsData)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    let color = try container.decode([CGFloat].self, forKey: .backgroundColor)
    backgroundColor = Color.color(components: color)
    let elementsData = try container.decode([Element.ElementData].self, forKey: .elementsData)
    elements = elementsData.map {
      $0.element
    }
  }
}

// MARK: - File I/O

extension Card {
  func save() {
    var data: Data?
    do {
      let encoder = JSONEncoder()
      data = try encoder.encode(self)
      let url = Settings.documentURL(name: "\(id).rwcard")
      try data?.write(to: url)
    } catch {
      print(error.localizedDescription)
    }
  }

}
