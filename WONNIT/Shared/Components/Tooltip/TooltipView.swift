//
//  TooltipView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import SwiftUI

enum PointerPlacement {
    case top, bottom, leading, trailing
}

struct TooltipView<Content: View>: View {
    let pointerPlacement: PointerPlacement
    let content: () -> Content
    let backgroundColor: Color
    
    @State private var bounce = false
    
    init(
        pointerPlacement: PointerPlacement,
        backgroundColor: Color = .grey900,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.pointerPlacement = pointerPlacement
        self.backgroundColor = backgroundColor
        self.content = content
    }
    
    var body: some View {
        tooltipLayout
            .offset(bounceOffset)
            .animation(
                .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                value: bounce
            )
            .onAppear {
                bounce = true
            }
    }

    @ViewBuilder
    private var tooltipLayout: some View {
        switch pointerPlacement {
        case .top:
            VStack(spacing: 0) {
                pointer
                tooltipBody
            }
        case .bottom:
            VStack(spacing: 0) {
                tooltipBody
                pointer
            }
        case .leading:
            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    pointer
                    tooltipBody
                }
            }
            
        case .trailing:
            ZStack(alignment: .trailing) {
                HStack(spacing: 0) {
                    tooltipBody
                    pointer
                }
            }
        }
    }

    // MARK: - Tooltip Body

    private var tooltipBody: some View {
        content()
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
            )
    }

    // MARK: - Pointer

    private var pointer: some View {
        Triangle()
            .fill(backgroundColor)
            .frame(width: 12, height: 8)
            .rotationEffect(rotationAngle(for: pointerPlacement))
            .offset(x: pointerOffsetX, y: 0)
    }
    
    private var pointerOffsetX: CGFloat {
        switch pointerPlacement {
        case .leading: return 2.5
        case .trailing: return -2.5
        default: return 0
        }
    }

    private func rotationAngle(for placement: PointerPlacement) -> Angle {
        switch placement {
        case .top: return .zero
        case .bottom: return .degrees(180)
        case .leading: return .degrees(-90)
        case .trailing: return .degrees(90)
        }
    }
    
    // MARK: - Bounce
    private var bounceOffset: CGSize {
        switch pointerPlacement {
        case .top: return CGSize(width: 0, height: bounce ? 0 : -2)
        case .bottom: return CGSize(width: 0, height: bounce ? 0 : 2)
        case .leading: return CGSize(width: bounce ? 0 : 2, height: 0)
        case .trailing: return CGSize(width: bounce ? 0 : -2, height: 0)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        TooltipView(pointerPlacement: .top) {
            Text("Tooltip")
                .body_05(.grey100)
        }

        TooltipView(pointerPlacement: .bottom) {
            Text("Tooltip")
                .body_05(.grey100)
        }

        TooltipView(pointerPlacement: .leading) {
            Text("Tooltip")
                .body_05(.grey100)
        }

        TooltipView(pointerPlacement: .trailing) {
            Text("Tooltip")
                .body_05(.grey100)
        }
    }
    .padding()
}
