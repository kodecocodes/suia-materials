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

// ResizableView is a view that allows resizing, rotation
// and repositioning of the view within the parent view
// Each gesture performs the provided update closure

typealias ResizableUpdate = (Transform) -> Void

/**
 - **Parameters:**
 - **transform**: `Transform`. The position, rotation and scale of the view
 - **update**: `ResizableUpdate`. A closure that does something with an updated transform
 - **content**: `Content` a generic. The content of the view, eg Photo or text
 */
struct ResizableView<Content>: View where Content: View{
  let content: Content
  var updateMethod: ResizableUpdate

  let id: UUID?

  @State private var isSelected: Bool = false
  @State private var previousOffset: CGSize = .zero
  @State private var offset: CGSize = .zero
  @State private var previousRotation: Angle = .zero
  @State private var rotation: Angle = .zero
  @State private var scale: CGFloat = 1.0
  @State private var previousScale: CGFloat = 1.0
  @State private var size: CGSize = .zero
  
  
  init(
    id: UUID?,
       transform: Transform,
       update: @escaping ResizableUpdate,
       @ViewBuilder content: @escaping() -> Content) {
    self.content = content()
    self.updateMethod = update
    self._scale = State(initialValue: transform.scale)
    self._rotation = State(initialValue: transform.rotation)
    self._offset = State(initialValue: transform.offset)
    self._previousOffset = State(initialValue: transform.offset)
    self._size = State(initialValue: transform.size)
    self.id = id
  }

  var body: some View {
    let rotationGesture = RotationGesture()
      .onChanged { value in
        rotation += value - previousRotation
        previousRotation = value
      }
      .onEnded { _ in
        previousRotation = .zero
        update()
      }
    let scaleGesture = MagnificationGesture()
      .onChanged { value in
        scale *= value / previousScale
        previousScale = value
      }
      .onEnded { value in
        scale *= value / previousScale
        size.width *= self.scale
        size.height *= self.scale
        scale = 1.0
        previousScale = 1.0
        update()
      }
    
    let dragGesture = DragGesture()
      .onChanged { value in
        offset = value.translation + previousOffset
      }
      .onEnded { value in
        offset = value.translation + previousOffset
        previousOffset = offset
        update()
      }
 
    return content
      .frame(width: size.width,
             height: size.height)
      .rotationEffect(rotation)
      .scaleEffect(scale)
      .offset(offset)
      .gesture(dragGesture)
      .gesture(SimultaneousGesture(rotationGesture, scaleGesture))
  }
  
  func update() {
    let transform = Transform(size: size, scale: scale,
                              rotation: rotation, offset: offset)
    updateMethod(transform)
  }
}

