//
//  CalendarHeader.swift
//  DayChecker
//
//  Created by 백상휘 on 1/6/26.
//

import SwiftUI

struct CalendarHeader: View {
    @StateObject var viewModel: CalendarViewModel
    var actionLeft: () -> Void {
        viewModel.goPrevMonth
    }
    var actionRight: () -> Void {
        viewModel.goNextMonth
    }
    var body: some View {
        HStack {
            HeaderButton.direction(.left, action: actionLeft)
            Text(viewModel.headerDateFormat.string(from: viewModel.date))
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
            HeaderButton.direction(.right, action: actionRight)
        }
    }
}

private enum Direction {
    case left, right
    var imageName: String {
        switch self {
        case .left:
            return "arrowshape.left.fill"
        case .right:
            return "arrowshape.right.fill"
        }
    }
}

private struct HeaderButton: View {
    let imageName: String
    let actionHandler: () -> Void
    var body: some View {
        Button { actionHandler() } label: {
            Image(systemName: imageName)
        }
        .buttonStyle(ArrowButtonStyle())
    }
    
    static func direction(_ direction: Direction, action: @escaping () -> Void) -> Self {
        return .init(imageName: direction.imageName, actionHandler: action)
    }
}

private struct ArrowButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        let baseView = configuration.label
            .font(.caption)
            .padding(.vertical, 9)
            .padding(.horizontal, 15)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
        
        if #available(iOS 26.0, *) {
            // iOS 18 이상: Liquid Glass 효과 사용
            return AnyView(
                baseView
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 11))
                    .glassEffectTransition(.materialize)
            )
        } else {
            // iOS 18 미만: 그림자 효과 사용
            return AnyView(
                baseView
                    .background(Color.gray.opacity(0.05).shadow(color: .gray, radius: 4, x: 0, y: 2))
                    .clipShape(Capsule())
            )
        }
    }
}

#Preview {
    CalendarHeader(viewModel: .init())
}
