//
//  ConfettiView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct ConfettiView: View {
    @Binding var isEmitting: Bool
    
    var body: some View {
        GeometryReader { proxy in
            _ConfettiUIView(isEmitting: $isEmitting, viewSize: proxy.size)
                .allowsHitTesting(false)
        }
    }
}

private struct _ConfettiUIView: UIViewRepresentable {
    @Binding var isEmitting: Bool
    let viewSize: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.birthRate = 0
        emitter.emitterCells = ConfettiFactory.shared.cells
        
        view.layer.addSublayer(emitter)
        context.coordinator.emitterLayer = emitter
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let emitter = context.coordinator.emitterLayer else { return }
        emitter.emitterPosition = CGPoint(x: viewSize.width / 2, y: -10)
        emitter.emitterSize = CGSize(width: viewSize.width, height: 1)
        emitter.birthRate = isEmitting ? 1 : 0
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var emitterLayer: CAEmitterLayer?
    }
}

private enum ConfettiShape {
    case rectangle
    case ribbon
}

private final class ConfettiFactory {
    static let shared = ConfettiFactory()
    private init() { }
    
    private let colors: [UIColor] = [
        UIColor(red: 0.95, green: 0.40, blue: 0.27, alpha: 1),
        UIColor(red: 1.00, green: 0.78, blue: 0.36, alpha: 1),
        UIColor(red: 0.48, green: 0.78, blue: 0.64, alpha: 1),
        UIColor(red: 0.30, green: 0.76, blue: 0.85, alpha: 1),
        UIColor(red: 0.58, green: 0.39, blue: 0.55, alpha: 1)
    ]
    
    private let shapes: [ConfettiShape] = [.rectangle, .ribbon]
    
    lazy var cells: [CAEmitterCell] = {
        colors.flatMap { color in
            shapes.map { shape in
                createCell(color: color, shape: shape)
            }
        }
    }()
    
    private func createCell(color: UIColor, shape: ConfettiShape) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = generateImage(for: shape, with: color)?.cgImage
        cell.birthRate = 10
        cell.lifetime = 7
        cell.lifetimeRange = 2
        cell.velocity = 350
        cell.velocityRange = 80
        cell.yAcceleration = 980
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 4
        cell.spinRange = 6 * .pi
        cell.scale = 0.1
        cell.scaleRange = 0.05
        cell.scaleSpeed = -0.02
        return cell
    }
    
    private func generateImage(for shape: ConfettiShape, with color: UIColor) -> UIImage? {
        let size: CGSize
        let path: UIBezierPath
        
        switch shape {
        case .rectangle:
            size = CGSize(width: 20, height: 13)
            path = UIBezierPath(rect: CGRect(origin: .zero, size: size))
        case .ribbon:
            size = CGSize(width: 15, height: 25)
            path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: size.height / 2))
            path.addCurve(to: CGPoint(x: size.width, y: size.height / 2),
                          controlPoint1: CGPoint(x: size.width / 4, y: 0),
                          controlPoint2: CGPoint(x: 3 * size.width / 4, y: size.height))
        }
        
        return UIGraphicsImageRenderer(size: size).image { ctx in
            color.setFill()
            path.fill()
        }
    }
}


#Preview {
    @Previewable @State var showConfetti = false
    
    ZStack {
        VStack {
            Button("🎉") {
                showConfetti = true
            }
        }
        ConfettiView(isEmitting: $showConfetti)
    }
    .onChange(of: showConfetti) { _, newValue in
        if newValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showConfetti = false
            }
        }
    }
}
