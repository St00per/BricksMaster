//
//  PresetsTabViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 17/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit
import HMSegmentedControl

enum Categories: Int {
    case presets = 0
    case banks = 1
    
    
    func title() -> String {
        switch self {
        case .presets:
            return "Presets"
        case .banks:
            return "Banks"
        
        }
    }
    
    static func sections() -> [String] {
        return [Categories.presets.title(), Categories.banks.title()]
    }
}

class PresetsTabViewController: UIViewController {
    
   
    var currentFootswitch: Footswitch?
    
    @IBOutlet weak var segmentedContainer: UIView!
    var segmentControl: HMSegmentedControl?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        createSegmentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        segmentControl?.frame = segmentedContainer.bounds
    }
    
    private func createSegmentView() {
        self.view.layoutIfNeeded()
        guard let segmentView = HMSegmentedControl(sectionTitles: Categories.sections()) else {
            return
        }
        
        segmentView.frame = segmentedContainer.bounds
        segmentView.segmentWidthStyle = .fixed
        segmentView.backgroundColor = UIColor.white
        segmentView.selectionIndicatorColor = UIColor(hexString: "90B5E1")
        segmentView.selectionIndicatorLocation = .down
        segmentView.selectionIndicatorHeight = 4
        segmentView.selectionStyle = .fullWidthStripe
        segmentView.addTarget(self, action: #selector(segmentChanged(segment:)), for: UIControl.Event.valueChanged)
        
        segmentedContainer.addSubview(segmentView)
        
        segmentControl = segmentView
    }
    
    @objc func segmentChanged(segment: HMSegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        if segment.selectedSegmentIndex == 1 {
            scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
        }
    }

}

