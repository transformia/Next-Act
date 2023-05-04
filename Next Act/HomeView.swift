//
//  HomeView.swift
//  Next Act
//
//  Created by Michael Frisk on 2023-05-04.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    ProjectsView()
                } label: {
                    Text("Projects")
                }
                NavigationLink {
                    TagsView()
                } label: {
                    Text("Tags")
                }
//                NavigationLink {
//                    ListView(list: "Completed")
//                } label: {
//                    Text("Completed tasks")
//                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
