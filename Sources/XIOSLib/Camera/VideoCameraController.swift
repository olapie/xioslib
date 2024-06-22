//
//  File.swift
//  
//
//  Created by Justin Tan on 10/23/20.
//

import UIKit
import AVKit

public protocol VideoCameraControllerDelegate: NSObjectProtocol {
    func didCaptureVideo(_ controller: VideoCameraController, url: URL)
}

open class VideoCameraController: UIViewController, PreviewViewDelegate, VideoCameraDelegate {
    
    private var preview: PreviewView!
    private var toolbar: UIView!
    private var closeButton: UIButton!
    private var recordButton: UIButton!
    private var switchButton: UIButton!
    private var camera: VideoCamera!
    private var timerLabel: UILabel!
    private weak var timer: Timer?
    // TOFIX: has issue with SwiftUI
//    public weak var delegate: VideoCameraControllerDelegate?
    public var delegate: VideoCameraControllerDelegate?
    private var recordButtonImageConfig: UIImage.SymbolConfiguration!
    private var originNavigationBarHidden = true
    
    deinit {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.recordButtonImageConfig = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular, scale: .large)
        setupToolbar()
        setupTimerLabel()
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
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        camera?.stop()
        timer?.invalidate()
        self.navigationController?.setNavigationBarHidden(originNavigationBarHidden, animated: animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func setupTimerLabel() {
        self.timerLabel = UILabel()
        self.timerLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        self.timerLabel.textColor = .lightText
        self.timerLabel.isHidden = true
        self.timerLabel.textAlignment = .center
        self.view.addSubview(self.timerLabel)
        self.timerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.timerLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 40).isActive = true
        self.timerLabel.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        self.timerLabel.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    private func setupToolbar() {
        self.toolbar = UIView()
        self.toolbar.backgroundColor = .black
        self.view.addSubview(self.toolbar)
        self.toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.toolbar.heightAnchor.constraint(equalToConstant: 88)
        self.toolbar.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        self.toolbar.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        self.toolbar.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)
        
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular, scale: .medium)
        let margins = self.toolbar.layoutMarginsGuide
        self.closeButton = UIButton()
        self.closeButton.tintColor = .lightGray
        self.closeButton.setImage(UIImage(systemName: "chevron.down.circle", withConfiguration: config), for: .normal)
        self.closeButton.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        self.toolbar.addSubview(closeButton)
        self.closeButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.closeButton.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        self.recordButton = UIButton()
        self.recordButton.tintColor = .green
        self.recordButton.setImage(UIImage(systemName: "circle.dashed.inset.fill", withConfiguration: self.recordButtonImageConfig), for: .normal)
        self.recordButton.addTarget(self, action: #selector(onRecord), for: .touchUpInside)
        self.toolbar.addSubview(self.recordButton)
        self.recordButton.translatesAutoresizingMaskIntoConstraints = false
        self.recordButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        self.recordButton.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        self.recordButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        self.recordButton.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        self.switchButton = UIButton()
        self.switchButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera", withConfiguration: config), for: .normal)
        self.switchButton.tintColor = .lightGray
        self.switchButton.addTarget(self, action: #selector(onSwitch), for: .touchUpInside)
        self.toolbar.addSubview(self.switchButton)
        self.switchButton.translatesAutoresizingMaskIntoConstraints = false
        self.switchButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20).isActive = true
        self.switchButton.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        self.switchButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.switchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.preview = PreviewView()
        self.preview.delegate = self
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
            if getDefaultVideoDevice() == nil {
                let alertController = UIAlertController(title: Translate("CameraUnavailable"), message: nil, preferredStyle: .alert)
                self.show(alertController, sender: nil)
                return
            }
            camera = VideoCamera()
            camera.delegate = self
            preview.session = camera.session
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.camera = VideoCamera()
                        self.camera.delegate = self
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
    
    @objc private func onRecord() {
        if self.camera == nil {
            return
        }
        if self.camera.isRecording {
            self.camera.stopRecording()
        } else {
            self.camera.startRecording(self.preview.videoPreviewLayer.connection?.videoOrientation ?? .portrait)
        }
        self.recordButton.isEnabled = false
    }
    
    @objc private func onSwitch() {
        self.camera?.switchDevice()
    }
    
    func previewDidTap(_ devicePoint: CGPoint, layerPoint: CGPoint) {
        guard let camera = self.camera else {
            return
        }
        if camera.focus(devicePoint) {
            self.preview.animateFocusAt(layerPoint)
        }
    }
    
    func didStartRecording() {
        self.recordButton.setImage(UIImage(systemName: "stop.circle", withConfiguration: self.recordButtonImageConfig), for: .normal)
        self.recordButton.isEnabled = true
        var secs = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (t) in
            secs += 1
            let h = secs / 3600
            let m = (secs % 3600) / 60
            let s = secs % 60
            self?.timerLabel.isHidden = false
            self?.timerLabel.text = String(format: "%02d:%02d:%02d", h, m, s)
        })
    }
    
    func didFinishRecording(_ url: URL, err: Error?) {
        self.timer?.invalidate()
        self.timerLabel.isHidden = true
        self.recordButton.setImage(UIImage(systemName: "circle.dashed.inset.fill", withConfiguration: self.recordButtonImageConfig), for: .normal)
        self.recordButton.isEnabled = true
        if err != nil {
            let alertController = UIAlertController(title: err!.localizedDescription, message: nil, preferredStyle: .alert)
            self.show(alertController, sender: nil)
            return
        }
        self.delegate?.didCaptureVideo(self, url: url)
    }
    
    open override var shouldAutorotate: Bool {
        if self.camera == nil {
            return true
        }
        return !self.camera.isRecording
    }
    
}
