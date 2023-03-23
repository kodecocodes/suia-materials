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

protocol CardElement {
  var id: UUID { get }
  var transform: Transform { get set }
}

extension CardElement {
  func index(in array: [CardElement]) -> Int? {
    array.firstIndex { $0.id == id }
  }
}

struct ImageElement: CardElement {
  let id = UUID()
  var transform = Transform()
  var frameIndex: Int?
  var uiImage: UIImage?
  var imageFilename: String?

  var image: Image {
    Image(
      uiImage: uiImage ??
        UIImage(named: "error-image") ??
        UIImage())
  }
}

extension ImageElement: Codable {
  enum CodingKeys: CodingKey {
    case transform, imageFilename, frameIndex
  }

  init(from decoder: Decoder) throws {
    let container = try decoder
      .container(keyedBy: CodingKeys.self)
    transform = try container
      .decode(Transform.self, forKey: .transform)
    frameIndex = try container
      .decodeIfPresent(Int.self, forKey: .frameIndex)
    imageFilename = try container.decodeIfPresent(
      String.self,
      forKey: .imageFilename)
    if let imageFilename {
      uiImage = UIImage.load(uuidString: imageFilename)
    } else {
      uiImage = UIImage.errorImage
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(transform, forKey: .transform)
    try container.encode(frameIndex, forKey: .frameIndex)
    try container.encode(imageFilename, forKey: .imageFilename)
  }
}

struct TextElement: CardElement {
  let id = UUID()
  var transform = Transform()
  var text = ""
  var textColor = Color.black
  var textFont = "Gill Sans"
}

extension TextElement: Codable {
  enum CodingKeys: CodingKey {
    case transform, text, textColor, textFont
  }

  init(from decoder: Decoder) throws {
    let container = try decoder
      .container(keyedBy: CodingKeys.self)
    transform = try container
      .decode(Transform.self, forKey: .transform)
    text = try container
      .decode(String.self, forKey: .text)
    let components = try container.decode([CGFloat].self, forKey: .textColor)
    textColor = Color.color(components: components)
    textFont = try container
      .decode(String.self, forKey: .textFont)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(transform, forKey: .transform)
    try container.encode(text, forKey: .text)
    let components = textColor.colorComponents()
    try container.encode(components, forKey: .textColor)
    try container.encode(textFont, forKey: .textFont)
  }
}
