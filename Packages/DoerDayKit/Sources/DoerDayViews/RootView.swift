//
//  SwiftUIView.swift
//  
//
//  Created by Leo Dion on 6/9/23.
//

import SwiftUI

struct Item : Identifiable {
  let id : UUID = .init()
  let dueAt : Date?
  let order : Int
  let name : String
  let completedAt : Date?
  
  init(dueAt: Date?, order: Int, name: String, completedAt: Date?) {
    self.dueAt = dueAt
    self.order = order
    self.name = name
    self.completedAt = completedAt
  }
}


struct RootView: View {
  let items = taskNames.map { name in
    Item(dueAt: .init(timeIntervalSinceNow: -.random(in: 100000...400000)), order: .random(in: 0...256), name: name, completedAt: nil)
  }.sorted {
    $0.order > $1.order
  }
    var body: some View {
      TabView {
        NavigationStack {
          List{
            ForEach(items) { item in
              HStack(content: {
                Text(item.name)
                Spacer()
                Text("\(item.order)").font(.caption).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
              })
            }
          }.listStyle(.inset)
          .navigationTitle("23-06-09")
          .toolbar(content: {
            ToolbarItem(placement: .status) {
              Button {
                
              } label: {
                Text("Start New Sheet")
              }
            }
          })
        }
        .tabItem{
          Image(systemName: "calendar")
          Text("This Week")
        }
        Text("Today").tabItem{
          Image(systemName: "sun.dust.fill")
          Text("Today")
        }
        Text("Reports").tabItem{
          Image(systemName: "chart.bar.doc.horizontal")
          Text("Reports")
        }
        Text("Settings").tabItem{
          Image(systemName: "gear")
          Text("Settings")
        }
      }
    }
}

#Preview {
  RootView()
}
