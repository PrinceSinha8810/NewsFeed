//
//  ShimmerEffect.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 14/03/26.
//

import SwiftUI

struct ShimmerEffect: ViewModifier {

    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    Rectangle().fill(Color.secondary)
                    
                    LinearGradient(gradient: Gradient(stops: [Gradient.Stop.init(color: .secondary,
                                                                                 location: phase),
                                                              Gradient.Stop(color: .primary.opacity(0.5), location: phase + 0.1),
                                                              Gradient.Stop.init(color: .secondary,
                                                                                 location: phase + 0.2)]),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                    .mask(content)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: phase)
                }
            }
            .onAppear {
                phase = 1.0
            }
    }
}
extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerEffect())
    }
}
