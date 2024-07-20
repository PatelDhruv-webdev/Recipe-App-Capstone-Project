import SwiftUI

struct ListView: View {
    @ObservedObject private var viewModel = ComponentViewModel()
    @State private var searchText = ""

    private var filteredComponents: [Component] {
        if searchText.isEmpty {
            return viewModel.components
        } else {
            return viewModel.components.filter { $0.title.contains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Text Input/Output")) {
                    ForEach(filteredComponents.filter { $0.type == .textInputOutput }) { component in
                        NavigationLink(destination: DetailView(component: component)) {
                            HStack {
                                Image(systemName: component.icon)
                                Text(component.title)
                            }
                        }
                    }
                }

                Section(header: Text("Controls")) {
                    ForEach(filteredComponents.filter { $0.type == .control }) { component in
                        NavigationLink(destination: DetailView(component: component)) {
                            HStack {
                                Image(systemName: component.icon)
                                Text(component.title)
                            }
                        }
                    }
                }

                Section(header: Text("Container Views")) {
                    ForEach(filteredComponents.filter { $0.type == .containerView }) { component in
                        NavigationLink(destination: DetailView(component: component)) {
                            HStack {
                                Image(systemName: component.icon)
                                Text(component.title)
                            }
                        }
                    }
                }

                Section(header: Text("List")) {
                    ForEach(filteredComponents.filter { $0.type == .list }) { component in
                        NavigationLink(destination: DetailView(component: component)) {
                            HStack {
                                Image(systemName: component.icon)
                                Text(component.title)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Components")
            .searchable(text: $searchText)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
