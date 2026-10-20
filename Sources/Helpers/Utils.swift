//
//  Utils.swift
//  ScalingHeaderScrollView
//
//  Created by Alisa Mylnikova on 04.08.2026.
//

import SwiftUI
import UIKit

@MainActor
func snapScrollPosition(in scrollView: UIScrollView?, params: ScalingHeaderParameters) {
    guard let sv = scrollView else { return }
    let extraSpace = params.maxHeight - params.minHeight
    let offset = sv.contentOffset.y
    for i in 0..<params.headerSnappingPositions.count - 1 {
        let first = -params.maxHeight + params.headerSnappingPositions[i] * extraSpace
        let second = -params.maxHeight + params.headerSnappingPositions[i + 1] * extraSpace
        guard offset > first, offset < second else { continue }
        let result = abs(offset - first) < abs(offset - second) ? first : second
        sv.setContentOffset(CGPoint(x: 0, y: result), animated: true)
        return
    }
}

// MARK: -

extension View {

    // contentShape keeps hit-testing in sync with the visual clip: without it, header content
    // centered/bottom-aligned inside a shrunk headerHeight frame still extends its hit area into
    // the overflow that clipped() only hides visually, swallowing touches meant for the list below.
    @ViewBuilder
    func clipped(isClipped: Bool) -> some View {
        if isClipped {
            self.clipped().contentShape(Rectangle())
        } else {
            self
        }
    }
}

// MARK: -

extension EdgeInsets {
    init(_ uiEdgeInsets: UIEdgeInsets) {
        self.init(top: uiEdgeInsets.top, leading: uiEdgeInsets.left, bottom: uiEdgeInsets.bottom, trailing: uiEdgeInsets.right)
    }
}

// GeometryReader's safeAreaInsets can get stuck reporting zero in some navigation/window
// configurations (e.g. observed on the iPhone Duo simulator); UIWindow.safeAreaInsets stays
// accurate and, unlike this view's own safeAreaInsets, isn't inflated by an ancestor nav bar's
// reserved height (which isn't real device safe area).
// Driven by viewDidLayoutSubviews rather than the view's own safeAreaInsetsDidChange: this view
// is a zero-size, non-participating background layer, so ITS OWN safeAreaInsets may never change
// after an early/premature first callback, freezing a stale window reading on devices where the
// real value only settles after layout (unlike Duo, where the real top inset happens to be 0).
final class SafeAreaTrackingViewController: UIViewController {
    var onChange: ((UIEdgeInsets) -> Void)?

    override func loadView() {
        view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        onChange?(view.window?.safeAreaInsets ?? .zero)
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        onChange?(view.window?.safeAreaInsets ?? .zero)
    }
}

struct SafeAreaReader: UIViewControllerRepresentable {
    var onChange: (UIEdgeInsets) -> Void

    func makeUIViewController(context: Context) -> SafeAreaTrackingViewController {
        let controller = SafeAreaTrackingViewController()
        controller.onChange = onChange
        return controller
    }

    func updateUIViewController(_ uiViewController: SafeAreaTrackingViewController, context: Context) {
        uiViewController.onChange = onChange
    }
}
