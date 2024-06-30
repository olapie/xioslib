//
//  File.swift
//  
//
//  Created by Justin Tan on 10/23/20.
//

import UIKit
import AVKit
import Photos

public protocol PhotoCameraControllerDelegate: NSObjectProtocol {
    func didCapturePhoto(_ controller: PhotoCameraController, data: Data)
}

open class PhotoCameraController: UIViewController, PreviewViewDelegate {
    private var preview: PreviewView!
    private var toolbar: UIView!
    private var closeButton: UIButton!
    private var captureButton: UIButton!
    private var switchButton: UIButton!
    private var camera: PhotoCamera!
    private var originNavigationBarHidden = true
    // TOFIX: has issue with SwiftUI
    public weak var delegate: PhotoCameraControllerDelegate?
//    public var delegate: PhotoCameraControllerDelegate?
    
    deinit {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupToolbar()
        configure()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    open override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camera?.start()
        originNavigationBarHidden = self.navigationController?.isNavigationBarHidden ?? true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
}
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        camera?.stop()
        self.navigationController?.setNavigationBarHidden(originNavigationBarHidden, animated: animated)
    }
    
    private func setupToolbar() {
        self.toolbar = UIView()
        self.toolbar.backgroundColor = .black
        self.view.addSubview(toolbar)
        self.toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.toolbar.heightAnchor.constraint(equalToConstant: 88)
        self.toolbar.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        self.toolbar.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        self.toolbar.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)
        
        let margins = self.toolbar.layoutMarginsGuide
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular, scale: .medium)
        
        self.closeButton = UIButton()
        self.closeButton.tintColor = .lightGray
        self.closeButton.setImage(UIImage(systemName: "chevron.down.circle", withConfiguration: config), for: .normal)
        self.closeButton.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        self.toolbar.addSubview(self.closeButton)
        self.closeButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.closeButton.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        let captureConfig = UIImage.SymbolConfiguration(pointSize: 72, weight: .regular, scale: .large)
        captureButton = UIButton()
        captureButton.tintColor = .green
        captureButton.setImage(UIImage(systemName: "circle.dashed.inset.fill", withConfiguration: captureConfig), for: .normal)
        captureButton.addTarget(self, action: #selector(onCapture), for: .touchUpInside)
        toolbar.addSubview(captureButton)
        self.captureButton.translatesAutoresizingMaskIntoConstraints = false
        self.captureButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        self.captureButton.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        self.captureButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        self.captureButton.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        switchButton = UIButton()
        switchButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera", withConfiguration: config), for: .normal)
        switchButton.tintColor = .lightGray
        switchButton.addTarget(self, action: #selector(onSwitch), for: .touchUpInside)
        toolbar.addSubview(switchButton)
        self.switchButton.translatesAutoresizingMaskIntoConstraints = false
        self.switchButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20).isActive = true
        self.switchButton.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        self.switchButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.switchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        preview = PreviewView()
        preview.delegate = self
        let previewLayer = preview.layer as! AVCaptureVideoPreviewLayer
        previewLayer.videoGravity = .resizeAspectFill
        self.view.addSubview(preview)
        self.preview.translatesAutoresizingMaskIntoConstraints = false
        self.preview.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        self.preview.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        self.preview.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        self.preview.bottomAnchor.constraint(equalTo: self.toolbar.layoutMarginsGuide.topAnchor).isActive = true
    }
    
    private func configure() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            if AVCaptureDevice.getDefaultVideoDevice() == nil {
                let alertController = UIAlertController(title: Translate("CameraUnavailable"), message: nil, preferredStyle: .alert)
                self.show(alertController, sender: nil)
                return
            }
            camera = PhotoCamera()
            preview.session = camera.session
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.camera = PhotoCamera()
                        self.preview.session = self.camera.session
                        return
                    }
                    self.openCameraSettings()
                }
            })
        default:
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.openCameraSettings()
            }
        }
    }
    
    private func openCameraSettings() {
        let c = UIAlertController(title: Translate("CameraPermissionAlertTitle"), message: "", preferredStyle: .alert)
        c.addAction(UIAlertAction(title: Translate("Cancel"), style: .cancel, handler: nil))
        c.addAction(UIAlertAction(title: Translate("Settings"), style: .`default`, handler: {_ in openSystemSettings()}))
        self.present(c, animated: true, completion: nil)
    }
    
    @objc private func onClose() {
        self.preview.isHidden = true
        guard let navigationController = self.navigationController else {
            dismiss(animated: true, completion: nil)
            return
        }
        if navigationController.viewControllers.count == 1 && navigationController.topViewController == self {
            dismiss(animated: true, completion: nil)
            return
        }
        navigationController.popViewController(animated: true)
    }
    
    @objc private func onCapture() {
        self.captureButton.isEnabled = false
        self.camera.capture { (data, error) in
            self.captureButton.isEnabled = true
            if let err = error {
                let alertController = UIAlertController(title: err.localizedDescription, message: nil, preferredStyle: .alert)
                self.show(alertController, sender: nil)
                return
            }
            self.delegate?.didCapturePhoto(self, data: data!)
        }
    }
    
    @objc private func onSwitch() {
        self.camera?.switchDevice()
    }
    
    func previewDidTap(_ devicePoint: CGPoint, layerPoint: CGPoint) {
        if self.camera.focus(devicePoint) {
            self.preview.animateFocusAt(layerPoint)
        }
    }
}
