/// Copyright (c) 2021 Razeware LLC
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

struct TimerView: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var timerDone: Bool
  @State private var timeRemaining = 3 // 30
  let exerciseName: String
  let timer = Timer.publish(
    every: 1,
    on: .main,
    in: .common)
    .autoconnect()


  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color("background")
          .edgesIgnoringSafeArea(.all)
        circle(size: geometry.size)
          .overlay(
            GradientBackground()
              .mask(circle(size: geometry.size))
          )
        VStack {
          Text(exerciseName)
            .font(.largeTitle)
            .fontWeight(.black)
            .foregroundColor(.white)
            .padding(.top, 20)
          Spacer()
          IndentView {
            timerText
          }
          Spacer()
          RaisedButton(buttonText: "Done") {
            presentationMode.wrappedValue.dismiss()
          }
          .opacity(timerDone ? 1 : 0)
          .padding([.leading, .trailing], 30)
          .padding(.bottom, 60)
          .disabled(!timerDone)
        }
        .onAppear {
          timerDone = false
        }
      }
    }
  }

  var timerText: some View {
    Text("\(timeRemaining)")
      .font(.system(size: 90, design: .rounded))
      .fontWeight(.heavy)
      .frame(
        minWidth: 180,
        maxWidth: 200,
        minHeight: 180,
        maxHeight: 200)
      .padding()
      .onReceive(timer) { _ in
        if self.timeRemaining > 0 {
          self.timeRemaining -= 1
        } else {
          timerDone = true
        }
      }
  }

  func circle(size: CGSize) -> some View {
    Circle()
      .frame(
        width: size.width,
        height: size.height)
      .position(
        x: size.width * 0.5,
        y: -size.width * 0.2)
  }
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView(
      timerDone: .constant(false),
      exerciseName: "Step Up")
  }
}
