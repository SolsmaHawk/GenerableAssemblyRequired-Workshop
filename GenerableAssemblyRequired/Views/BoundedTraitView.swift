//
//  BoundedTraitView.swift
//  ConversationManager
//
//  Created by John Solsma on 8/1/25.
//

import SwiftUI

struct BoundedTraitView: View {
    let trait: BoundedPersonalityTrait.PartiallyGenerated
    @State private var animatedValue: Double = 0.0
    @State private var timer: Timer?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let emoji = trait.emoji {
                    Text(emoji)
                }
                if let traitName = trait.traitName {
                    Text(traitName)
                        .bold()
                }
                if let traitMeasuredValue = trait.measuredValue, let traitMaxValue = trait.maxValue {
                    Text("\(traitMeasuredValue)/\(traitMaxValue)")
                }
            }
            .font(.subheadline)
            if let target = trait.measuredValue,
               let max = trait.maxValue {
                ProgressView(value: animatedValue, total: Double(max))
                    .progressViewStyle(.linear)
                    .onAppear {
                        animateToTarget(Double(target))
                    }
            }
        }
    }
}

extension BoundedTraitView {

    private func animateToTarget(_ target: Double) {
        timer?.invalidate()
        animatedValue = 0
        let steps = 30
        let duration = 0.5
        let stepTime = duration / Double(steps)
        let stepSize = target / Double(steps)
        var currentStep = 0
        timer = Timer.scheduledTimer(withTimeInterval: stepTime, repeats: true) { t in
            if currentStep >= steps {
                t.invalidate()
                animatedValue = target 
                return
            }
            currentStep += 1
            animatedValue += stepSize
        }
    }

}
