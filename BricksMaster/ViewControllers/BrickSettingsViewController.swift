//
//  BrickSettingsViewController.swift
//  BricksMaster
//
//  Created by Kirill Shteffen on 23/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import UIKit

class BrickSettingsViewController: UIViewController {

    var currentBrick: Brick?
    var assignedFootswitch: Footswitch?
    var brickImages: [UIImage] = []
    let slider = MTCircularSlider(frame: CGRect(x: 30, y: 0, width: 300, height: 300))
    let colorPicker = SwiftHSVColorPicker(frame: CGRect(x: 30, y: -40, width: 300, height: 300))
    
    @IBOutlet weak var brickName: UITextField!
    
    @IBOutlet var footswitchPicker: UIView!
    
    @IBOutlet weak var colorPickerView: UIView!
    
    
    @IBOutlet weak var brickSettingsView: UIView!
    @IBOutlet weak var assignedFootswitchName: UIButton!
    @IBOutlet weak var footswitchPickerCollectionView: UICollectionView!
    
    
    @IBOutlet weak var brickImageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPicker.setViewColor(UIColor.white)
        colorPicker.delegate = self
        colorPickerView.addSubview(colorPicker)
        сircleSliderConfigure()
        colorPickerView.addSubview(slider)
        fillingBrickImagesArray()
        assignedFootswitch = currentBrick?.assignedFootswitch
        brickName.text = currentBrick?.deviceName
        if assignedFootswitch != nil {
            assignedFootswitchName.setTitle(assignedFootswitch?.name, for: .normal)
        }
    }
    
    @IBAction func showFootswitchPicker(_ sender: UIButton) {
        brickSettingsView.isUserInteractionEnabled = false
        brickSettingsView.alpha = 0.4
        self.view.addSubview(footswitchPicker)
        footswitchPicker.center = self.view.center
        
    }
    
    @IBAction func closeFootswitchPicker(_ sender: UIButton) {
        footswitchPicker.removeFromSuperview()
        brickSettingsView.alpha = 1
        brickSettingsView.isUserInteractionEnabled = true
    }
    
    
    @IBAction func closeBrickSettings(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBrickSettings(_ sender: UIButton) {
        guard let currentBrick = self.currentBrick, let assignedFootswitch = self.assignedFootswitch else { return }
        assignedFootswitch.bricks.append(currentBrick)
        currentBrick.assignedFootswitch = self.assignedFootswitch
        self.dismiss(animated: true, completion: nil)
    }
    
    func сircleSliderConfigure()  {
        
        let attributes = [
            /* Track */
            Attributes.minTrackTint(UIColor.clear.withAlphaComponent(0.01)),
            Attributes.maxTrackTint(UIColor.clear.withAlphaComponent(0.01)),
            Attributes.trackWidth(CGFloat(25)),
            Attributes.trackShadowRadius(CGFloat(0)),
            Attributes.trackShadowDepth(CGFloat(0)),
            Attributes.trackMinAngle(CGFloat(-90)),
            Attributes.trackMaxAngle(CGFloat(270)),
            
            /* Thumb */
            Attributes.hasThumb(true),
            Attributes.thumbTint(UIColor.white),
            Attributes.thumbRadius(15),
            Attributes.thumbShadowRadius(16),
            Attributes.thumbShadowDepth(10)
        ]
        slider.isUserInteractionEnabled = true
        slider.applyAttributes(attributes)
        slider.addTarget(self, action: #selector(brightnessUpdate), for: .valueChanged)
    }
    
    @objc func brightnessUpdate() {
        
        let sliderAngle = slider.getThumbAngle()
        let brightness = (sliderAngle - 1.65)/6.11
        colorPicker.brightnessSelected(brightness)
    }
    
    func fillingBrickImagesArray() {
        brickImages.append(UIImage(named: "pedal_image1")!)
        brickImages.append(UIImage(named: "pedal_image2")!)
        brickImages.append(UIImage(named: "pedal_image3")!)
        brickImages.append(UIImage(named: "pedal_image4")!)
        brickImages.append(UIImage(named: "pedal_image5")!)
        print(brickImages.count)
    }
    
}
extension BrickSettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == footswitchPickerCollectionView {
            return UserDevicesManager.default.userFootswitches.count
        }
        if collectionView == brickImageCollectionView {
            return brickImages.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == footswitchPickerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FootswitchPickerCollectionViewCell", for: indexPath) as? FootswitchPickerCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(footswitch: UserDevicesManager.default.userFootswitches[indexPath.row])
            return cell
        }
        if collectionView == brickImageCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrickImageCollectionViewCell", for: indexPath) as? BrickImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            let currentBrickImage = brickImages[indexPath.row]
            cell.configure(image: currentBrickImage)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == footswitchPickerCollectionView {
            assignedFootswitch = UserDevicesManager.default.userFootswitches[indexPath.row]
            footswitchPicker.removeFromSuperview()
            brickSettingsView.alpha = 1
            brickSettingsView.isUserInteractionEnabled = true
            assignedFootswitchName.setTitle(assignedFootswitch?.name, for: .normal)
            
        }
    }
}
extension BrickSettingsViewController: GradientRingDelegate {
    func updateGradientRingColor(color: UIColor) {
        
    }
    
//    func updateGradientRingColor(color: UIColor) {
//        gradientRing.tintColor = color
//    }
}
