//
//  ViewController.swift
//  ClockNumberProblem
//
//  Created by Paul Bryan on 11/1/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var clockView: ClockFace!
    @IBOutlet weak var clockWidthConstraint: NSLayoutConstraint!
    
    
    var maxWidth: CGFloat {
        return min(view.bounds.width, view.bounds.height)
    }
    
    var isPortrait: Bool {
        return view.bounds.width < view.bounds.height
    }
    
    let small: CGFloat = 150
    let large: CGFloat = 300
    var sizeToUse: CGFloat {
        return isPortrait ? small : large
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        clockWidthConstraint.constant = sizeToUse
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        clockView.setNeedsDisplay()
    }
}

