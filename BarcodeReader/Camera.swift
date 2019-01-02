//
//  Camera.swift
//  BarcodeReader
//
//  Created by berk birkan on 2.01.2019.
//  Copyright © 2019 Turansoft. All rights reserved.
//

import AVFoundation
import UIKit

class Camera: UIViewController{
    
    var captureSession = AVCaptureSession()
    var backcamera: AVCaptureDevice?
    var frontcamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput:AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image:UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
    }
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }
    
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == AVCaptureDevice.Position.back{
                backcamera=device
            }else if device.position == AVCaptureDevice.Position.front{
                frontcamera=device
            }
            
        }
        currentCamera=backcamera
        
        
    }
    
    func setupInputOutput(){
        do{
            let capturedeviceinput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(capturedeviceinput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            
            captureSession.addOutput(photoOutput!)
            
        }catch{
            print(error)
        }
        
        
    }
    
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        
        
    }
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    
    
    
    @IBAction func takephoto(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        //performSegue(withIdentifier: "showphoto", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showphoto"{
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
        }
    }
    
    
}



extension Camera: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,didFinishProcessingPhoto photo: AVCapturePhoto,error:Error?){
        if let imagedata = photo.fileDataRepresentation(){
            print(imagedata)
            image = UIImage(data: imagedata)
            performSegue(withIdentifier: "showphoto", sender: nil)
        }else{
            print("erro")
        }
        
    }
}
