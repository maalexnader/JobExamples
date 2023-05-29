import SwiftUI

struct TextStyle: ViewModifier {
    let style: Style

    func body(content: Content) -> some View {
        let scaledFont = UIFontMetrics.default.scaledFont(for: style.font)
        return content
            .font(Font(scaledFont))
            .ifLet(style.lineSpacing) {
                $0.lineSpacing($1)
            }
            .ifLet(style.kerning) {
                $0.kerning($1)
            }
    }

    enum Style {
        case heading1
        case heading2
        case heading3
        case heading4
        case body
        case caption
        case subtitle

        var font: UIFont {
            switch self {
            case .heading1:
                return .systemFont(ofSize: 28, weight: .semibold)
            case .heading2:
                return .systemFont(ofSize: 24, weight: .semibold)
            case .heading3:
                return .systemFont(ofSize: 20, weight: .semibold)
            case .heading4:
                return .systemFont(ofSize: 16, weight: .medium)
            case .body:
                return .systemFont(ofSize: 16, weight: .regular)
            case .caption:
                return .systemFont(ofSize: 14, weight: .medium)
            case .subtitle:
                return .systemFont(ofSize: 12, weight: .medium)
            }
        }

        var lineSpacing: CGFloat? {
            switch self {
            case .heading1:
                return nil
            case .heading2:
                return nil
            case .heading3:
                return nil
            case .heading4:
                return nil
            case .body:
                return 1.375
            case .caption:
                return 1.429
            case .subtitle:
                return 1.67
            }
        }

        var kerning: CGFloat? {
            switch self {
            case .heading1:
                return nil
            case .heading2:
                return nil
            case .heading3:
                return nil
            case .heading4:
                return nil
            case .body:
                return nil
            case .caption:
                return nil
            case .subtitle:
                return nil
            }
        }
    }
}

extension View {
    func style(_ style: TextStyle.Style) -> some View {
        self.modifier(TextStyle(style: style))
    }
}
