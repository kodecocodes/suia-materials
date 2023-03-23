/// Copyright (c) 2022 Kodeco LLC
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

struct CountdownView: View {
  let date: Date
  @Binding var timeRemaining: Int
  let size: Double

  var body: some View {
    Text("\(timeRemaining)")
      .font(.system(size: 90, design: .rounded))
      .fontWeight(.heavy)
      .frame(
        minWidth: 180,
        maxWidth: 200,
        minHeight: 180,
        maxHeight: 200)
      .padding()
      .onChange(of: date) { _ in
        timeRemaining -= 1
      }
  }
}

struct TimerView: View {
  @Environment(\.dismiss) var dismiss
  @State private var timeRemaining: Int = 3
  @Binding var timerDone: Bool
  let exerciseName: String

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color("background")
          .ignoresSafeArea()
        let gradient = Gradient(
          stops: [
            Gradient.Stop(color: Color("gradient-top"), location: 0.7),
            Gradient.Stop(color: Color("gradient-bottom"), location: 1.1)
          ])
        Circle()
          .foregroundStyle(gradient)
          .position(
            x: geometry.size.width * 0.5,
            y: -geometry.size.width * 0.2)
        VStack {
          Text(exerciseName)
            .font(.largeTitle)
            .fontWeight(.black)
            .foregroundColor(.white)
            .padding(.top, 20)
          Spacer()
        }
        TimelineView(
          .animation(
            minimumInterval: 1.0,
            paused: timeRemaining <= 0)) { context in
              IndentView {
                CountdownView(
                  date: context.date,
                  timeRemaining: $timeRemaining,
                  size: geometry.size.width)
              }
        }
        .onChange(of: timeRemaining) { _ in
          if timeRemaining < 1 {
            timerDone = true
          }
        }
        VStack {
          Spacer()
          RaisedButton(buttonText: "Done") {
            dismiss()
          }
          .opacity(timerDone ? 1 : 0)
          .padding([.leading, .trailing], 30)
          .padding(.bottom, 60)
          .disabled(!timerDone)
        }
      }
    }
  }
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView(
      timerDone: .constant(false),
      exerciseName: "Step Up")
  }
}
