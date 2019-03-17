//
//  ViewController.swift
//  The Light
//
//  Created by student5 on 1/26/19.
//  Copyright © 2019 Hannah Leland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // UI object outlets
    @IBOutlet weak var buttonView: UIButton!
    @IBOutlet weak var flashlightButton: UIButton!
    @IBOutlet weak var colorsButton: UIButton!
    
    // app mode variable
    var mode = 0
    
    // color variables
    var lightOn = false
    var randomColor = UIColor.black
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    } // end viewDidLoad
    
    
    
    /////////////////
    // UI Actions //
    ////////////////
    
    @IBAction func openFlashlight(_ sender: UIButton) {
        mode = 0
        flashlightButton.backgroundColor = UIColor(hex: "D5D5D5")
        colorsButton.backgroundColor = UIColor(hex: "EBEBEB")
        buttonView.backgroundColor = .black
        buttonView.setTitleColor(.white, for: .normal)
        buttonView.setTitle("Off", for: .normal)
    } // end func openFlashlight
    
    @IBAction func openColors(_ sender: UIButton) {
        mode = 1
        colorsButton.backgroundColor = UIColor(hex: "D5D5D5")
        flashlightButton.backgroundColor = UIColor(hex: "EBEBEB")
        buttonView.backgroundColor = .white
        buttonView.setTitleColor(.black, for: .normal)
        buttonView.setTitle("#FFFFFF", for: .normal)
    } // end func openColors
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if(mode == 0) {
            flashLightSwitch()
        } else {
            colorSwitch()
        }
    } // end buttonPressed
    
    
    
    //////////////////////////
    // UI Outlet Functions //
    ////////////////////////
    
    func flashLightSwitch() {
        lightOn = !lightOn
        switch lightOn {
        case true:
            buttonView.backgroundColor = .white
            buttonView.setTitle("On", for: .normal)
            buttonView.setTitleColor(.black, for: .normal)
        case false:
            buttonView.backgroundColor = .black
            buttonView.setTitleColor(.white, for: .normal)
            buttonView.setTitle("Off", for: .normal)
        }
    } // end flashLightSwitch
    
    func colorSwitch() {
        randomColor = UIColor.random()
        buttonView.backgroundColor = randomColor
        buttonView.setTitleColor(.black, for: .normal)
        buttonView.setTitle("#\(randomColor.toHex ?? "FFFFFF")", for: .normal)
    } // end colorSwitch
    
} // end ViewController



////////////////////////////////
// Extensions & Calculations //
//////////////////////////////

// generates random UIColor using RGB float
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static func random() -> UIColor {
        return UIColor(rgb: Int(CGFloat(arc4random()) / CGFloat(UINT32_MAX) * 0xFFFFFF))
    }
    
} // end first UIColor extenstion

// generates UIColor from color hex code
extension UIColor {
    
    // MARK: - Initialization
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.characters.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - Computed Properties
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

