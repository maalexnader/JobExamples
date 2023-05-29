import SwiftUI

struct OtpElement: View {
      @Binding var otp: String
      @State var first: Int?
      @State var second: Int?
      @State var third: Int?
      @State var fourth: Int?
      @State var fifth: Int?
      @FocusState private var isInFocus: Bool

      var body: some View {
          ZStack {
              SwiftUI.TextField("", text: $otp)
                  .keyboardType(.numberPad)
                  .focused($isInFocus)
                  .opacity(0)
              HStack(spacing: 16) {
                  UI.DigitFieldElement(value: first)
                  UI.DigitFieldElement(value: second)
                  UI.DigitFieldElement(value: third)
                  UI.DigitFieldElement(value: fourth)
                  UI.DigitFieldElement(value: fifth)
              }
              .contextMenu {
                  Button(
                      "Paste",
                      action: {
                          otp = UIPasteboard.general.string ?? ""
                      }
                  )
              }
          }
          .onAppear {
              delay(0.3, action: { isInFocus = true })
          }
          .onChange(of: otp) { newValue in
              if newValue.count > 4 {
                  otp = String(newValue.prefix(5))
              }

              if let firstDigit = otp.first {
                  first = Int(String(firstDigit))
              } else {
                  first = nil
              }

              if let secondDigit = otp.dropFirst(1).first {
                  second = Int(String(secondDigit))
              } else {
                  second = nil
              }

              if let thirdDigit = otp.dropFirst(2).first {
                  third = Int(String(thirdDigit))
              } else {
                  third = nil
              }

              if let fourthDigit = otp.dropFirst(3).first {
                  fourth = Int(String(fourthDigit))
              } else {
                  fourth = nil
              }

              if let fifthDigit = otp.dropFirst(4).first {
                  fifth = Int(String(fifthDigit))
              } else {
                  fifth = nil
              }
          }
      }
  }

struct DigitFieldElement: View {
    var value: Int?

    var body: some View {
        Text(value?.description ?? "_")
            .style(.heading1)
            .foregroundColor(.text)
            .padding(.top, 15)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
            .background(Color.background)
            .cornerRadius(8)
    }
}
