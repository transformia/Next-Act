//
//  ListView.swift
//  Next Act
//
//  Created by Michael Frisk on 2023-05-04.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.order, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>
    
    let list: Int // list to display
    
//    enum List: Int {
//        case Inbox = 0
//        case Now = 1
//        case Next = 2
//        case Someday = 3
//    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(tasks.filter({$0.list == list})) { task in
                        TaskView(task: task)
                    }
                    .onMove(perform: moveItem)
                }
                
                Button {
                    for task in tasks {
                        viewContext.delete(task)
                    }
                } label: {
                    Text("Clear all tasks")
                }
                .padding(.bottom, 60)
                
                HStack {
                    addTaskTopButton
                    addTaskBottomButton
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    private func moveItem(at sets:IndexSet, destination: Int) {
        let itemToMove = sets.first!
        
        // If the task is moving down:
        if itemToMove < destination {
            var startIndex = itemToMove + 1
            let endIndex = destination - 1
            var startOrder = tasks[itemToMove].order
            
            // If the item being moved is in the same list as the item above the destination, change the order of all of the items between the task to move and the destination:
            if tasks[itemToMove].list == tasks[destination - 1].list {
                while startIndex <= endIndex {
                    tasks[startIndex].order = startOrder
                    startOrder += 1
                    startIndex += 1
                }
                tasks[itemToMove].order = startOrder // set the moved task's order to its final value
            }
            
            // Else if the item being moved is in a different list from the item above the destination, decrement the order of all of the tasks in the destination list until the one above the destination task, and set the order of the item being moved to the next available one. Don't touch the order of the other tasks from the original list of the item being moved:
            else {
                print("Moving the item into a different list")
                // Update the list of the item:
                tasks[itemToMove].list = tasks[destination - 1].list
                
                var startOrderFound = false // variable showing if I've found the first item of the destination list, or not yet
                while startIndex <= endIndex {
                    if startOrderFound { // if I have already found the first item of the destination list, update the order of the task, and increment the order to prepare for the next item
                        tasks[startIndex].order = startOrder
                        startOrder += 1 // increment the order to prepare for the next item
                    }
                    else if tasks[startIndex].list == tasks[destination - 1].list { // if this item is part of the destination list
                        startOrderFound = true // mark that I have found the first item of the destination list
                        startOrder = tasks[startIndex].order - 1 // set the startOrder to the order of this first item minus one
                        tasks[startIndex].order = startOrder // decrement the order of this first item
                        startOrder += 1 // increment the order to prepare for the next item
                    }
                    // Move on to the next item:
                    startIndex += 1
                }
                tasks[itemToMove].order = startOrder // set the moved task's order to its final value
            }
        }
        
        // Else if the task is moving up:
        else if itemToMove > destination {
            var startIndex = destination
            let endIndex = itemToMove - 1
            var startOrder = tasks[destination].order + 1
            let newOrder = tasks[destination].order
            // Change the order of all tasks between the task to move and the destination - but only if they are in the same list as the destination! There's not point in reordering tasks in the item's original list if the item is changing lists:
            while startIndex <= endIndex {
                if tasks[startIndex].list == tasks[destination].list {
                    tasks[startIndex].order = startOrder
                    startOrder += 1
                }
                startIndex += 1
            }
            tasks[itemToMove].order = newOrder // set the moved task's order to its final value
            
            // If this is viewed from within a project, and the item is moved ABOVE an item from a different list, update the list of the item:
            if tasks[itemToMove].list != tasks[destination].list {
                print("Moving the task into a different list")
                tasks[itemToMove].list = tasks[destination].list
            }
        }
        
        PersistenceController.shared.save() // save the item
    }
    
    var addTaskTopButton: some View {
        Button {
            let impactMed = UIImpactFeedbackGenerator(style: .medium) // haptic feedback
            impactMed.impactOccurred() // haptic feedback
            // Create a new task:
            let task = Task(context: viewContext)
            task.id = UUID()
            task.order = (tasks.first?.order ?? 0) - 1
            task.list = Int16(list)
            task.name = ""
            task.createddate = Date()
            PersistenceController.shared.save()
//            task.list = list
        } label: {
            Image(systemName: "arrow.up")
                .resizable()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .padding(10)
                .background(.green)
                .clipShape(Circle())
        }
        .padding(.bottom, 8)
    }
    
    var addTaskBottomButton: some View {
        Button {
            let impactMed = UIImpactFeedbackGenerator(style: .medium) // haptic feedback
            impactMed.impactOccurred() // haptic feedback
            // Create a new task:
            let task = Task(context: viewContext)
            task.id = UUID()
            task.order = (tasks.last?.order ?? 0) + 1
            task.list = Int16(list)
            task.name = ""
            task.createddate = Date()
            PersistenceController.shared.save()
//            task.list = list
        } label: {
            Image(systemName: "arrow.down")
                .resizable()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .padding(10)
                .background(.green)
                .clipShape(Circle())
        }
        .padding(.bottom, 8)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list: 0)
    }
}
