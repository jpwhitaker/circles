// HapticFeedbackService.swift
import UIKit
import CoreHaptics

class HapticFeedbackService {
    private var hapticEngine: CHHapticEngine?
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .heavy)

    init() {
        prepareHaptics()
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func playHapticFeedback() {
        hapticGenerator.impactOccurred()
    }
}
