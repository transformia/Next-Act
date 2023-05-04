//
//  ContentView.swift
//  Next Act
//
//  Created by Michael Frisk on 2023-05-04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView {            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ListView(list: 0)
                .tabItem {
                    Label("Inbox", systemImage: "tray")
                }
            
            ListView(list: 1)
                .tabItem {
                    Label("Now", systemImage: "scope")
                }
            
            ListView(list: 2)
                .tabItem {
                    Label("Next", systemImage: "terminal.fill")
                }
            
            ListView(list: 3)
                .tabItem {
                    Label("Someday", systemImage: "text.append")
                }
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newTask = Task(context: viewContext)
//            newTask.createddate = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { tasks[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
