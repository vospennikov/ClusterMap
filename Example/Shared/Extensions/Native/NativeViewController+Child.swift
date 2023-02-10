//
//  NativeViewController+Child.swift
//  Example
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//



extension NativeViewController {
    func add(_ child: NativeViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
