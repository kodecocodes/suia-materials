///// Copyright (c) 2022 Kodeco LLC
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

struct AddHistoryView: View {
  @Binding var addMode: Bool
  @State private var exerciseDate = Date()

  var body: some View {
    VStack {
      ZStack {
        Text("Add Exercise")
          .font(.title)
        Button("Done") {
          addMode = false
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
      }
      ButtonsView(date: $exerciseDate)
      DatePicker(
        "Choose Date",
        selection: $exerciseDate,
        in: ...Date(),
        displayedComponents: .date)
      .datePickerStyle(.graphical)
    }
    .padding()
  }
}

struct ButtonsView: View {
  @EnvironmentObject var history: HistoryStore
  @Binding var date: Date

  var body: some View {
    HStack {
      ForEach(Exercise.exercises.indices, id: \.self) { index in
        let exerciseName = Exercise.exercises[index].exerciseName
        Button(exerciseName) {
          history.addExercise(date: date, exerciseName: exerciseName)
        }
      }
    }
    .buttonStyle(EmbossedButtonStyle(buttonScale: 1.5))
  }
}

struct AddHistoryView_Previews: PreviewProvider {
  static var previews: some View {
    AddHistoryView(addMode: .constant(true))
      .environmentObject(HistoryStore(preview: true))
  }
}
