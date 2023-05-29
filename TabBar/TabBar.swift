import SwiftUI

struct TabBar: View {
    @State var items: [Item]
    @Binding var selected: Item

    var body: some View {
        VStack {
            HStack {
                ForEach(items) { item in
                    Button(action: {
                        guard !item.isCreate else { return }
                        selected = item
                    }) {
                        ItemContainer(item: item, selectedItem: $selected)
                            .frame(maxWidth: item.isCreate ? 64 : .infinity)
                            .if(item.isCreate) { view in
                                view.offset(y: -8)
                            }
                    }
                }
            }
            .frame(height: 50)
            Spacer()
        }
        .background(TabBarFillShape().fill(Color.neutral))
        .overlay(TabBarBorderShape().stroke(Color.black.opacity(0.25), lineWidth: 0.5))
        .frame(height: 84)
    }

    func handleSelection(selectedItem: Item) {
        if !selectedItem.isCreate {
            selected = selectedItem
        } else {
            print("haha")
        }
    }
}
