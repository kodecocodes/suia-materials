/// Copyright (c) 2025 Kodeco Inc.
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

var initialCards: [Card] { [
  Card(backgroundColor: .random1, elements: initialElements),
  Card(backgroundColor: .random2),
  Card(backgroundColor: .random3),
  Card(backgroundColor: .random4),
  Card(backgroundColor: .random5),
  Card(backgroundColor: .random6),
  Card(backgroundColor: .random7),
  Card(backgroundColor: .random8)
] }

var initialElements: [CardElement] { [
  ImageElement(
    transform: Transform(
      size: CGSize(width: 750, height: 540),
      offset: CGSize(width: -150, height: -600)),
    uiImage: UIImage(named: "giraffe3")),
  ImageElement(
    transform: Transform(
      size: CGSize(width: 950, height: 675),
      offset: CGSize(width: -300, height: 425)),
    uiImage: UIImage(named: "giraffe2")),
  ImageElement(
    transform: Transform(
      size: CGSize(width: 625, height: 450),
      offset: CGSize(width: 300, height: 405)),
    uiImage: UIImage(named: "giraffe1")),
  TextElement(
    transform: Transform(
      size: Settings.defaultElementSize * 1.1,
      offset: CGSize(width: 0, height: -175)),
    text: "Giraffes!!!",
    textColor: .black)
] }
