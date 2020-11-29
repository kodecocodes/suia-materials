import SwiftUI

struct StateArray: View {
  @State var myThings: Store
  @State var showAddThing = false

  var body: some View {
    VStack {
      ForEach(myThings.things, id: \.self) { thing in
        Text(thing)
      }
      Spacer()
      Button("Show Add Thing") {
        showAddThing = true
      }
      .sheet(isPresented: $showAddThing) {
        AddThing(someThings: $myThings)
      }
    }
  }
}

struct AddThing: View {
  @Binding var someThings: Store
  var body: some View {
    Button("Add thing") {
      someThings.things.append("nothing")
    }
  }
}

struct Store {
  var things: [String]
}

struct StateArray_Previews: PreviewProvider {
  static var previews: some View {
    StateArray(myThings: Store(things: ["thing"]))
  }
}
