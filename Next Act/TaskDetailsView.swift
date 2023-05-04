//
//  TaskDetailsView.swift
//  Next Act
//
//  Created by Michael Frisk on 2023-05-04.
//

import SwiftUI

struct TaskDetailsView: View {
    
    let task: Task
    
    @State private var name = ""
    @State private var list = 0
    @State private var date = Date()
    
    @State private var dateActive = false
    @State private var reminderActive = false
    @State private var hideUntilDate = false
    
    // Define lists:
    let lists = [(0, "Inbox"), (1, "Now"), (2, "Next"), (3, "Someday")]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("", text: $name, axis: .vertical)
                    .onAppear {
                        name = task.name ?? ""
                        dateActive = task.dateactive
                        reminderActive = task.reminderactive
                        date = task.date ?? Date()
                        hideUntilDate = task.hideuntildate
                        list = Int(task.list)
                    }
                    .onChange(of: name) { _ in
                        task.name = name
                        PersistenceController.shared.save()
                    }
                    .onChange(of: date) { _ in
                        task.date = date
                        PersistenceController.shared.save()
                    }
                    .onChange(of: dateActive) { _ in
                        task.dateactive = dateActive
                        PersistenceController.shared.save()
                    }
                    .onChange(of: reminderActive) { _ in
                        task.reminderactive = reminderActive
                        PersistenceController.shared.save()
                    }
                    .onChange(of: hideUntilDate) { _ in
                        task.hideuntildate = hideUntilDate
                        PersistenceController.shared.save()
                    }
                Picker("List", selection: $list) {
                    ForEach(lists, id: \.self.0) {
                        Text($0.1)
                            .tag($0.0)
                    }
                }
                .onChange(of: list) { _ in
                    task.list = Int16(list)
                    PersistenceController.shared.save()
                }
                HStack {
                    Toggle("Date", isOn: $dateActive)
                    Toggle("Reminder", isOn: $reminderActive)
                        .disabled(!dateActive)
                }
                if dateActive {
                    DatePicker("", selection: $date, displayedComponents: reminderActive ? [.date, .hourAndMinute] : .date)
                    Toggle("Hide until date", isOn: $hideUntilDate)
                }
            }
        }
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailsView(task: Task())
    }
}
