//
//  TaskView.swift
//  Next Act
//
//  Created by Michael Frisk on 2023-05-04.
//

import SwiftUI

struct TaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.order, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task> // to be able to change the order of the task
    
    let task: Task
    
    @State private var name = ""
    
    @FocusState private var focused: Bool
    
    @State private var showTaskDetails = false
    
    var body: some View {
        HStack {
            TextField("", text: $name, axis: .vertical)
                .focused($focused)
                .foregroundColor(task.completed ? .gray : nil)
                .strikethrough(task.completed)
                .onAppear {
                    name = task.name ?? ""
                    if name == "" {
                        focused = true // focus on the task when it is created
                    }
                }
                .onChange(of: name) { _ in
                    task.name = name
                    PersistenceController.shared.save()
                }
        }
        .swipeActions(edge: .leading) {
            Button { // complete this item
                task.modifieddate = Date()
                task.completed.toggle()
                PersistenceController.shared.save()
            } label: {
                Label("Complete", systemImage: "checkmark")
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing) { // move the task to another list
            
            if task.list != 1 {
                // Move the task to Now:
                Button {
                    task.list = 1
                    task.order = (tasks.first?.order ?? 0) - 1 // set the order of the task to the first task's order minus 1
                    task.modifieddate = Date()
                    PersistenceController.shared.save() // save the item
                } label: {
                    Label("Now", systemImage: "scope")
                }
                .tint(.green)
            }
            
            if task.list != 2 {
                // Move the task to Next:
                Button {
                    task.list = 2
                    task.order = (tasks.first?.order ?? 0) - 1 // set the order of the task to the first task's order minus 1
                    task.modifieddate = Date()
                    PersistenceController.shared.save() // save the item
                } label: {
                    Label("Next", systemImage: "terminal.fill")
                }
                .tint(.blue)
            }
            
            if task.list != 3 {
                // Move the task to Someday:
                Button {
                    task.list = 3
                    task.order = (tasks.first?.order ?? 0) - 1 // set the order of the task to the first task's order minus 1
                    task.modifieddate = Date()
                    PersistenceController.shared.save() // save the item
                } label: {
                    Label("Someday", systemImage: "text.append")
                }
                .tint(.brown)
            }
            
            if task.list != 0 {
                // Toggle Waiting for on the task:
                Button {
//                    task.waitingfor.toggle()
                    task.modifieddate = Date()
                    PersistenceController.shared.save() // save the item
                } label: {
                    Label("Waiting", systemImage: "stopwatch")
                }
                .tint(.gray)
            }
            
            // Edit the task details:
            Button {
                showTaskDetails = true
            } label: {
                Label("Details", systemImage: "gear")
            }
            
        }
        .sheet(isPresented: $showTaskDetails) {
            TaskDetailsView(task: task)
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: Task())
    }
}
