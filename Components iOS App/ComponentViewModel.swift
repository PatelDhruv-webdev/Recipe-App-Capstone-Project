import SwiftUI

class ComponentViewModel: ObservableObject {
    @Published private(set) var components: [Component] = [
        // Section 1: Text Input/Output
        Component(title: "Text", icon: "textformat", type: .textInputOutput),
        Component(title: "Label", icon: "tag", type: .textInputOutput),
        Component(title: "TextField", icon: "rectangle.and.pencil.and.ellipsis", type: .textInputOutput),
        Component(title: "SecureField", icon: "lock", type: .textInputOutput),
        Component(title: "TextArea", icon: "square.and.pencil", type: .textInputOutput),
        Component(title: "Image", icon: "photo", type: .textInputOutput),
        
        // Section 2: Controls
        Component(title: "Button", icon: "square.and.arrow.down", type: .control),
        Component(title: "Menu", icon: "line.horizontal.3", type: .control),
        Component(title: "Link", icon: "link", type: .control),
        Component(title: "Slider", icon: "slider.horizontal.3", type: .control),
        Component(title: "Stepper", icon: "plus.forwardslash.minus", type: .control), // Updated icon
        Component(title: "Toggle", icon: "switch.2", type: .control),
        Component(title: "Picker", icon: "rectangle.3.offgrid.fill", type: .control),
        Component(title: "DatePicker", icon: "calendar", type: .control),
        Component(title: "ColorPicker", icon: "eyedropper.full", type: .control),
        Component(title: "ProgressView", icon: "clock", type: .control),
        
        // Section 3: Container Views
        Component(title: "HStack", icon: "rectangle.stack", type: .containerView),
        Component(title: "VStack", icon: "rectangle.stack", type: .containerView),
        Component(title: "ZStack", icon: "rectangle.stack", type: .containerView),
        Component(title: "Form", icon: "doc.plaintext", type: .containerView),
        Component(title: "NavigationView", icon: "arrowshape.turn.up.right", type: .containerView),
        Component(title: "Alerts", icon: "exclamationmark.triangle", type: .containerView),
        Component(title: "Sheets", icon: "doc.on.doc", type: .containerView),
        
        // Section 4: List
        Component(title: "Plain", icon: "list.bullet", type: .list),
        Component(title: "Inset", icon: "list.dash", type: .list),
        Component(title: "Grouped", icon: "list.number", type: .list),
        Component(title: "Inset Grouped", icon: "list.bullet.indent", type: .list),
        Component(title: "Sidebar", icon: "sidebar.left", type: .list)
    ]
}
