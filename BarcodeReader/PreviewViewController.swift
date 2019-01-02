//
//  PreviewViewController.swift
//  BarcodeReader
//
//  Created by berk birkan on 2.01.2019.
//  Copyright © 2019 Turansoft. All rights reserved.
//

import UIKit
import Firebase
import Vision
class PreviewViewController: UIViewController {
    
    var image: UIImage!
    @IBOutlet weak var photo: UIImageView!
    
    var barcodes: [VisionBarcode]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelbutton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func savebutton(_ sender: UIButton) {
        let format = VisionBarcodeFormat.all
        let barcodeOptions = VisionBarcodeDetectorOptions(formats: format)
        
        var vision = Vision.vision()
        let barcodeDetector = vision.barcodeDetector(options: barcodeOptions)
        
        let imagevision = VisionImage(image: image)
        
        barcodeDetector.detect(in: imagevision) { features, error in
            guard error == nil, let features = features, !features.isEmpty else {
                let alert = UIAlertController(title: "Error", message: "Can't read :(", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert,animated: true,completion: nil)
                return print("Cant read error")
            }
            
            
            self.barcodes = features
        }
        
        
        for barcode in barcodes {
            let corners = barcode.cornerPoints
            
            
            let displayValue = barcode.displayValue
            let rawValue = barcode.rawValue
            
            let valueType = barcode.valueType
            switch valueType {
            case .wiFi:
                let ssid = barcode.wifi!.ssid
                let password = barcode.wifi!.password
                let encryptionType = barcode.wifi!.type
                let messagetext = "SSID: " + ssid! + " Pass: " + password!
                let alert = UIAlertController(title: String(encryptionType.rawValue), message: messagetext, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert,animated: true,completion: nil)
                
            case .URL:
                let title = barcode.url!.title
                let url = barcode.url!.url
                let messagetext = url
                let alert = UIAlertController(title: title, message: messagetext, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert,animated: true,completion: nil)
                
            case .phone:
                let phonenumber = barcode.phone?.number
                let messagetext = "Phone Number: " + phonenumber!
                let alert = UIAlertController(title: title, message: messagetext, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert,animated: true,completion: nil)
                
            default:
                let barcodetext = barcode.description
                let messagetext = "Result: " + String(barcodetext)
                let alert = UIAlertController(title: title, message: messagetext, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert,animated: true,completion: nil)
                
                // See API reference for all supported value types
            }
        }
        
    }
}
