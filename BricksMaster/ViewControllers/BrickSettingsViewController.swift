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
    var brickImages: [String] = []
    
    let slider = MTCircularSlider(frame: CGRect(x: 55, y: 10, width: 280, height: 280))
    let colorPicker = SwiftHSVColorPicker(frame: CGRect(x: 40, y: -40, width: 300, height: 300))
    
    var pingPinIsOn: Bool = false
    var pingTimer: Timer?
    
    var selectedIndexPAth: IndexPath?
    var selectedImage: String?
    
    @IBOutlet weak var gradientRing: UIImageView!
    
    
    @IBOutlet weak var brickName: UILabel!
    
    
    @IBOutlet var footswitchPicker: UIView!
    
    @IBOutlet weak var colorPickerView: UIView!
    
    
    @IBOutlet weak var brickSettingsView: UIView!
    @IBOutlet weak var assignedFootswitchName: UIButton!
    @IBOutlet weak var footswitchPickerCollectionView: UICollectionView!
    var viewShadow: UIView?
    
    
    @IBOutlet weak var brickImageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = currentBrick?.color {
            colorPicker.setViewColor(color)
            var brightness: CGFloat = 0
            color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
            slider.value = brightness
            gradientRing.tintColor = color
        }
        
        colorPicker.delegate = self
        colorPickerView.addSubview(colorPicker)
        сircleSliderConfigure()
        colorPickerView.addSubview(slider)
        brightnessUpdate()
        
        fillingBrickImagesArray()
        assignedFootswitch = currentBrick?.assignedFootswitch
        brickName.text = currentBrick?.deviceName
        if assignedFootswitch != nil {
            assignedFootswitchName.setTitle(assignedFootswitch?.name, for: .normal)
        }
        footswitchPickerCollectionView.allowsSelection = true
        
        selectedImage = currentBrick?.imageId
        viewShadow = UIView(frame: UIScreen.main.bounds)
        viewShadow?.backgroundColor = UIColor.black
        viewShadow?.alpha = 0.0
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        endPing()
    }
    
    @IBAction func showFootswitchPicker(_ sender: UIButton) {
        if let viewShadow = viewShadow {
            self.view.addSubview(viewShadow)
        }
        brickSettingsView.isUserInteractionEnabled = false
        self.view.addSubview(footswitchPicker)
        footswitchPicker.frame = CGRect(x: 16, y: self.view.bounds.size.height, width: self.view.bounds.size.width - 32, height: 320)
        UIView.animate(withDuration: 0.3, animations: {
            self.viewShadow?.alpha = 0.45
            self.footswitchPicker.frame = CGRect(x: 0, y: self.view.bounds.size.height - 320, width: self.view.bounds.size.width, height: 320)
        }) { (isFinished) in
        }
    }
    
    @IBAction func closeFootswitchPicker(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.footswitchPicker.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: self.view.bounds.size.width, height: 320)
            self.viewShadow?.alpha = 0.0
        }) { (isFinished) in
            self.brickSettingsView.isUserInteractionEnabled = true
            self.footswitchPicker.removeFromSuperview()
            self.viewShadow?.removeFromSuperview()
        }
    }
    
    
    @IBAction func closeBrickSettings(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBrickSettings(_ sender: UIButton) {
        guard let currentBrick = self.currentBrick else { return }
        //assignedFootswitch.bricks.append(currentBrick) - ??
        currentBrick.assignedFootswitch = self.assignedFootswitch
        currentBrick.imageId = selectedImage
        currentBrick.color = colorPicker.color
        if let finded = self.assignedFootswitch?.bricks.firstIndex(where: { (brick) -> Bool in
            return brick.id == currentBrick.id
        }) {
            
        } else {
            currentBrick.assignedFootswitch?.bricks.append(currentBrick)
        }
        
//        currentBrick.save()
//        assignedFootswitch.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startPing() {
        pingPinIsOn = false
        pingTimer = Timer(timeInterval: 0.1, repeats: true, block: { (timer) in
            self.pingPinIsOn = !self.pingPinIsOn
            self.setPingPin(on: self.pingPinIsOn)
        })
        RunLoop.current.add(pingTimer!, forMode: .default)
    }
    
    @IBAction func endPing() {
        setPingPin(on: false)
        pingTimer?.invalidate()
    }
    
    func setPingPin(on: Bool) {
        guard
            let brick = self.currentBrick,
            let peripheralCharacteristic = brick.tx,
            let peripheral = brick.peripheral
            else {
                return
        }
        var dataToWrite = Data()
        dataToWrite.append(0xE7)
        dataToWrite.append(0xF2)
        if on {
            dataToWrite.append(0x01)
        } else {
            dataToWrite.append(0x00)
        }
        println("Blink ...")
        CentralBluetoothManager.default.sendCommand(to: peripheral, characteristic: peripheralCharacteristic, data: dataToWrite)
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
        
        //let sliderAngle = slider.getThumbAngle()
        let brightness = slider.value
            //(sliderAngle - 1.65)/6.11
        colorPicker.brightnessSelected(brightness)
        
    }
    
    func fillingBrickImagesArray() {
        brickImages.append("pedal_image1")
        brickImages.append("pedal_image2")
        brickImages.append("pedal_image3")
        brickImages.append("pedal_image4")
        brickImages.append("pedal_image5")
    }
    
}
extension BrickSettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            cell.configure(footswitch: UserDevicesManager.default.userFootswitches[indexPath.item])
            return cell
        }
        if collectionView == brickImageCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrickImageCollectionViewCell", for: indexPath) as? BrickImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            guard let brickImage = UIImage(named: brickImages[indexPath.item]) else {
                return UICollectionViewCell()
            }
            if brickImages[indexPath.item] == selectedImage {
                cell.isSelected = true
                cell.isHighlighted = true
            } else {
                cell.isSelected = false
            }
                cell.configure(image: brickImage)
                cell.width.constant = indexPath.item == 2 || indexPath.item == 3 ? 49 : 40
                cell.height.constant = 60
           
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == footswitchPickerCollectionView {
            assignedFootswitch = UserDevicesManager.default.userFootswitches[indexPath.row]
            assignedFootswitchName.setTitle(assignedFootswitch?.name, for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.footswitchPicker.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: self.view.bounds.size.width, height: 320)
                self.viewShadow?.alpha = 0.0
            }) { (isFinished) in
                self.brickSettingsView.isUserInteractionEnabled = true
                self.footswitchPicker.removeFromSuperview()
                self.viewShadow?.removeFromSuperview()
            }
        }

        if collectionView == brickImageCollectionView {
            //currentBrick?.imageId = brickImages[indexPath.item]
            selectedImage = brickImages[indexPath.item]
            selectedIndexPAth = indexPath
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == footswitchPickerCollectionView {
            return CGSize(width: collectionView.bounds.width - 32, height: 44)
        }
        if collectionView == brickImageCollectionView {
            return CGSize(width: 50, height: 60)
        }
        return CGSize.zero
    }
}
extension BrickSettingsViewController: GradientRingDelegate {
    func updateGradientRingColor(color: UIColor) {
        gradientRing.tintColor = color
        currentBrick?.color = color
    }
}
