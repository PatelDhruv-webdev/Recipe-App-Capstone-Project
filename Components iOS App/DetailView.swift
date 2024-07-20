import SwiftUI
import SafariServices

struct DetailView: View {
    let component: Component
    @State private var showSafari = false

    var body: some View {
        VStack {
            Text("Component: \(component.title)")
                .font(.largeTitle)
                .padding()

            // Example usage for each component type
            componentExample(for: component)

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showSafari.toggle()
                }) {
                    Image(systemName: "doc.text") // Updated to match the required icon
                }
            }
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: URL(string: "https://developer.apple.com/documentation/swiftui/\(component.title.lowercased())")!)
        }
    }
    
    @ViewBuilder
    private func componentExample(for component: Component) -> some View {
        switch component.title {
        case "Text":
            Text("This is an example of a Text view.")
        case "Label":
            Label("This is a label", systemImage: "tag")
        case "TextField":
            TextField("Enter text", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        case "SecureField":
            SecureField("Enter password", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        case "TextArea":
            TextEditor(text: .constant("This is a text editor"))
                .padding()
                .border(Color.gray, width: 1)
        case "Image":
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
        case "Button":
            Button(action: {}) {
                Text("Press Me")
            }
            .padding()
        case "Menu":
            Menu("Menu") {
                Button("Option 1", action: {})
                Button("Option 2", action: {})
            }
            .padding()
        case "Link":
            Link("Apple", destination: URL(string: "https://www.apple.com")!)
                .padding()
        case "Slider":
            Slider(value: .constant(0.5))
                .padding()
        case "Stepper":
            Stepper("Stepper", value: .constant(0))
                .padding()
        case "Toggle":
            Toggle("Toggle", isOn: .constant(true))
                .padding()
        case "Picker":
            Picker("Picker", selection: .constant(1)) {
                Text("Option 1").tag(1)
                Text("Option 2").tag(2)
            }
            .padding()
        case "DatePicker":
            DatePicker("Select Date", selection: .constant(Date()))
                .padding()
        case "ColorPicker":
            ColorPicker("Pick a Color", selection: .constant(.blue))
                .padding()
        case "ProgressView":
            ProgressView()
                .padding()
        case "HStack":
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<20) { index in
                        Text("Item \(index)")
                            .padding()
                            .border(Color.gray)
                    }
                }
            }
            .padding()
        case "VStack":
            ScrollView(.vertical) {
                VStack {
                    ForEach(0..<20) { index in
                        Text("Item \(index)")
                            .padding()
                            .border(Color.gray)
                    }
                }
            }
            .padding()
        case "ZStack":
            ZStack {
                Color.blue
                Text("ZStack Example")
                    .foregroundColor(.white)
            }
            .frame(height: 200)
            .padding()
        case "Form":
            Form {
                Text("Form Item 1")
                Text("Form Item 2")
            }
            .padding()
        case "NavigationView":
            NavigationView {
                Text("Inside NavigationView")
            }
            .padding()
        case "Alerts":
            Text("Alert Example")
                .padding()
                .onTapGesture {
                    showAlert()
                }
        case "Sheets":
            Text("Sheet Example")
                .padding()
                .onTapGesture {
                    showSheet()
                }
        case "Plain":
            List {
                Text("Plain List Item 1")
                Text("Plain List Item 2")
            }
            .padding()
        case "Inset":
            List {
                Text("Inset List Item 1")
                Text("Inset List Item 2")
            }
            .listStyle(InsetListStyle())
            .padding()
        case "Grouped":
            List {
                Text("Grouped List Item 1")
                Text("Grouped List Item 2")
            }
            .listStyle(GroupedListStyle())
            .padding()
        case "Inset Grouped":
            List {
                Text("Inset Grouped List Item 1")
                Text("Inset Grouped List Item 2")
            }
            .listStyle(InsetGroupedListStyle())
            .padding()
        case "Sidebar":
            List {
                Text("Sidebar Item 1")
                Text("Sidebar Item 2")
            }
            .listStyle(SidebarListStyle())
            .padding()
        default:
            Text("Component example not available.")
        }
    }
    
    private func showAlert() {
        // Implement alert presentation
    }

    private func showSheet() {
        // Implement sheet presentation
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(component: Component(title: "Text", icon: "textformat", type: .textInputOutput))
    }
}
