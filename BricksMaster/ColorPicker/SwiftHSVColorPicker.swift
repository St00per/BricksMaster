//
//  SwiftHSVColorPicker.swift
//  SwiftHSVColorPicker
//
//  Created by johankasperi on 2015-08-20.
//

import UIKit

protocol GradientRingDelegate {
    func updateGradientRingColor(color: UIColor)
}

open class SwiftHSVColorPicker: UIView, ColorWheelDelegate, BrightnessViewDelegate {
    var colorWheel: ColorWheel!
    var brightnessView: BrightnessView!
    var selectedColorView: SelectedColorView!
    var delegate: GradientRingDelegate!
    open var color: UIColor!
    var hue: CGFloat = 1.0
    var saturation: CGFloat = 1.0
    var brightness: CGFloat = 1.0
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open func setViewColor(_ color: UIColor) {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.color = color
        setup()
    }
    
    func setup() {
        // Remove all subviews
        let views = self.subviews
        for view in views {
            view.removeFromSuperview()
        }
        
        let selectedColorViewHeight: CGFloat = 34.0
        let brightnessViewHeight: CGFloat = 26.0
        
        // let color wheel get the maximum size that is not overflow from the frame for both width and height
        let colorWheelSize = min(self.bounds.width, self.bounds.height - selectedColorViewHeight - brightnessViewHeight)
        // let the all the subviews stay in the middle of universe horizontally
        let centeredX = (self.bounds.width - colorWheelSize) / 2.0
        
        // Init SelectedColorView subview
        if self.bounds.width == 250 {
            //narrow screen configuration(iPhone 6)
            selectedColorView = SelectedColorView(frame: CGRect(x: self.bounds.width, y: self.bounds.height - 180, width: 34, height: selectedColorViewHeight), color: self.color)
        }
        
        if self.bounds.width == 299 {
            //wide screen configuration(iPhone 8s)
            selectedColorView = SelectedColorView(frame: CGRect(x: self.bounds.width - 20, y: self.bounds.height - 250, width: 34, height: selectedColorViewHeight), color: self.color)
        }
        
        if self.bounds.width > 299 {
            //narrow screen configuration(iPhone X)
            selectedColorView = SelectedColorView(frame: CGRect(x: self.bounds.width - 50, y: self.bounds.height - 330, width: 34, height: selectedColorViewHeight), color: self.color)
        }
        
        selectedColorView.layer.cornerRadius = selectedColorView.frame.width/2
        // Add selectedColorView as a subview of this view
        self.addSubview(selectedColorView)
        
        // Init new ColorWheel subview
        colorWheel = ColorWheel(frame: CGRect(x: 30, y: 70, width: colorWheelSize, height: colorWheelSize), color: self.color)
        colorWheel.delegate = self
        colorWheel.dropShadow()
        // Add colorWheel as a subview of this view
        self.addSubview(colorWheel)
        
        // Init new BrightnessView subview
//        brightnessView = BrightnessView(frame: CGRect(x: centeredX, y: colorWheel.frame.maxY, width: colorWheelSize, height: brightnessViewHeight), color: self.color)
//        brightnessView.delegate = self
//        // Add brightnessView as a subview of this view
//        self.addSubview(brightnessView)
    }
    
    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        //brightnessView.setViewColor(self.color)
        selectedColorView.setViewColor(self.color)
        delegate.updateGradientRingColor(color: self.color)
    }
    
    func brightnessSelected(_ brightness: CGFloat) {
        self.brightness = brightness
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        //colorWheel.setViewBrightness(brightness)
        selectedColorView.setViewColor(self.color)
    }
}
