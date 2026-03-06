//
//  CustomLocationCoordinator.swift
//  Places
//

import Foundation

final class CustomLocationCoordinator: CustomLocationRouting {
    private weak var saver: CustomLocationSaving?
    private let onDismiss: () -> Void

    init(saver: CustomLocationSaving, onDismiss: @escaping () -> Void) {
        self.saver = saver
        self.onDismiss = onDismiss
    }

    func start() -> CustomLocationViewModel {
        CustomLocationViewModel(saver: saver, router: self)
    }

    func trigger(_ route: CustomLocationRouteTrigger) {
        switch route {
        case .dismiss:
            onDismiss()
        }
    }
}
