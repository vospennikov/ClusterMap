//
//  ClusterAnnotationView.swift
//  Example-AppKit
//
//  Created by Mikhail Vospennikov on 03.09.2023.
//

import MapKit

final class ClusterAnnotationView: MKAnnotationView {
    lazy var countLabel: NSTextField = {
        let label = NSTextField()
        label.isBezeled = false
        label.isEditable = false
        label.isSelectable = false
        label.maximumNumberOfLines = 1
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .white
        label.alignment = .center
        addSubview(label)
        return label
    }()

    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let annotation = annotation as? ClusterAnnotation {
            configure(annotation)
        }
    }

    func configure(_ annotation: ClusterAnnotation) {
        countLabel.stringValue = "\(annotation.memberAnnotations.count)"
        updateLayout()
    }

    var backgroundColor: NSColor? {
        get {
            guard let layer, let backgroundColor = layer.backgroundColor else { return nil }
            return NSColor(cgColor: backgroundColor)
        }
        set {
            layer?.backgroundColor = newValue?.cgColor
        }
    }

    private func updateLayout() {
        updateFrameSize()
        placeLabelToCenter()
        drawBackground()
    }

    private func updateFrameSize() {
        countLabel.sizeToFit()
        let maxLength = max(countLabel.bounds.width, countLabel.bounds.height)
        frame.size = CGSize(width: maxLength, height: maxLength)
    }

    private func placeLabelToCenter() {
        countLabel.frame.origin.x = bounds.width / 2 - countLabel.bounds.width / 2
        countLabel.frame.origin.y = bounds.height / 2 - countLabel.bounds.height / 2
    }

    private func drawBackground() {
        layer?.cornerRadius = frame.width / 2
        layer?.masksToBounds = true
        layer?.borderColor = NSColor.white.cgColor
        layer?.borderWidth = 1.5
    }
}
