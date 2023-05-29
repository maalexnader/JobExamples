struct TextEditorElement: View {
    @State private var textWrapper: String

    @State var placeholder: String
    @Binding var text: String?

    init(text: Binding<String?>, placeholder: String) {
        self._text = text
        self.textWrapper = text.wrappedValue ?? ""
        self.placeholder = placeholder
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                SwiftUI.TextField(
                    LocalizedStringKey(placeholder),
                    text: $textWrapper,
                    axis: .vertical
                )
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
                .style(.heading4)
                .foregroundColor(.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 13)
                Spacer()
            }
        }
        .background(Color.background)
        .cornerRadius(23)
        .onChange(of: textWrapper) { newValue in
            guard !newValue.isEmpty else {
                text = nil
                return
            }
            text = newValue
        }
    }
}
