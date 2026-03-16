//
//  ShimmerEffect.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 14/03/26.
//

import SwiftUI

struct ShimmerEffect: ViewModifier {
    
    /// Base tint keeps placeholders visible between passes.
    var baseTint: Color = .secondary.opacity(0.18)
    /// Bright streak colour.
    var highlight: Color = .white.opacity(0.65)
    /// How wide the bright band is relative to the longest side.
    var bandRatio: CGFloat = 0.45
    /// Seconds per pass; lower is faster.
    var speed: TimeInterval = 2
    /// A slight tilt keeps movement from feeling robotic.
    var angle: Angle = .degrees(18)
    
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    let width = proxy.size.width
                    let height = proxy.size.height
                    let bandWidth = max(width, height) * bandRatio
                    
                    // Push start far left and end far right to avoid clipping at trailing edge.
                    let span = (width * 2.5) + bandWidth
                    let xOffset = -(span * 0.6) + (span * phase)
                    
                    LinearGradient(
                        colors: [baseTint, highlight, baseTint],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: bandWidth * 2.5, height: height * 2.8)
                    .offset(x: xOffset)
                    .clipped()
                }
            }
            .background(baseTint)
            .mask(content)
            .onAppear {
                phase = 0
                withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    /// Adds a shimmering placeholder pass with tweakable feel.
    func shimmering(
        baseTint: Color = .secondary.opacity(0.18),
        highlight: Color = .white.opacity(0.65),
        bandRatio: CGFloat = 0.45,
        speed: TimeInterval = 2,
        angle: Angle = .degrees(18)
    ) -> some View {
        modifier(
            ShimmerEffect(
                baseTint: baseTint,
                highlight: highlight,
                bandRatio: bandRatio,
                speed: speed,
                angle: angle
            )
        )
    }
}
