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
import Charts

struct BarChartWeekView: View {
  @EnvironmentObject var history: HistoryStore
  @State private var weekData: [ExerciseDay] = []

  var body: some View {
    Chart(weekData) { day in
      ForEach(Exercise.names, id: \.self) { name in
        BarMark(
          x: .value("Date", day.date, unit: .day),
          y: .value("Total Count", day.countExercise(exercise: name)))
        .foregroundStyle(by: .value("Exercise", name))
      }
    }
    .chartForegroundStyleScale([
      "Burpee": Color("chart-burpee"),
      "Squat": Color("chart-squat"),
      "Step Up": Color("chart-step-up"),
      "Sun Salute": Color("chart-sun-salute")
    ])
    .padding()
    .onAppear {
      let firstDate = history.exerciseDays.first?.date ?? Date()
      let dates = firstDate.previousSevenDays
      weekData = dates.map { date in
        // swiftlint:disable:next trailing_closure
        history.exerciseDays.first(
          where: { $0.date.isSameDay(as: date) })
        ?? ExerciseDay(date: date)
      }
    }
  }
}

struct BarChartWeekView_Previews: PreviewProvider {
  static var previews: some View {
    BarChartWeekView()
      .environmentObject(HistoryStore(preview: true))
  }
}
