import Observation
import SwiftUI

@Observable
final class Sheet {
  var items = taskNames.map { name in
    Item(dueAt: .init(timeIntervalSinceNow: -.random(in: 100_000 ... 400_000)), order: .random(in: 0 ... 256), name: name, completedAt: nil)
  }.sorted {
    $0.order > $1.order
  }
}

struct EditSheetView: View {
  var sheet = Sheet()
  func move(from source: IndexSet, to destination: Int) {
    // move the data here
    print(source, destination)
  }

  var body: some View {
    NavigationStack {
      List {
        ForEach(sheet.items) { item in
          HStack(content: {
            Text(item.name)
            Spacer()
            Text("\(item.order)").font(.caption).fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
          })
        }.onMove(perform: move)
      }.listStyle(.inset)
        .navigationTitle("23-06-09")
        .toolbar(content: {
          ToolbarItem(placement: .status) {
            Button {} label: {
              Text("Start New Sheet")
            }
          }
        })
    }
  }
}

#Preview {
  EditSheetView()
}
