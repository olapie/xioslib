//
//  File.swift
//  
//
//  Created by Justin Tan on 10/26/20.
//

import UIKit
import AVFAudio
import AVFoundation

public protocol AudioViewControllerDelegate: NSObjectProtocol {
    func didCaptureAudio(_ controller: AudioViewController, url: URL, elapse: Int64)
}

open class AudioViewController: UIViewController {
    private var recordButton: UIButton!
    private var stopButton: UIButton!
    private var timerLabel: UILabel!
    private var titleLabel: UILabel!
    private weak var timer: Timer?
    private var startAt: Date!
    
    private var session: AVAudioSession!
    private var recorder: AVAudioRecorder!
    private var originNavigationBarHidden = false
    
    public var delegate: AudioViewControllerDelegate?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        let config = UIImage.SymbolConfiguration(pointSize: 120, weight: .bold, scale: .large)
        self.recordButton = UIButton()
        self.recordButton.setImage(UIImage(systemName: "mic.circle.fill", withConfiguration: config), for: .normal)
        self.recordButton.tintColor = .green
        self.recordButton.addTarget(self, action: #selector(onRecord), for: .touchUpInside)
        self.view.addSubview(self.recordButton)
        self.recordButton.translatesAutoresizingMaskIntoConstraints = false
        self.recordButton.centerEqualToSuperview()
        self.recordButton.sizeEqualTo(120, 120)
        
        self.stopButton = UIButton()
        self.stopButton.setImage(UIImage(systemName: "stop.circle", withConfiguration: config), for: .normal)
        self.stopButton.tintColor = .green
        self.stopButton.addTarget(self, action: #selector(onStop), for: .touchUpInside)
        self.view.addSubview(self.stopButton)
        self.recordButton.edgesEqualToSuperview()
        self.stopButton.isHidden = true
        
        self.timerLabel = UILabel()
        self.timerLabel.textColor = .lightText
        self.timerLabel.text = "00:00:00"
        self.timerLabel.textAlignment = .center
        self.timerLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        self.timerLabel.isHidden = true
        self.view.addSubview(self.timerLabel)
        self.timerLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.timerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        self.timerLabel.centerEqualToSuperview()
        self.timerLabel.bottomAnchor.constraint(equalTo: self.recordButton.topAnchor, constant: -30).isActive = true
        
        self.titleLabel = UILabel()
        self.titleLabel.textColor = .lightText
        self.titleLabel.text = Translate("AudioRecording")
        self.titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        self.titleLabel.textAlignment = .center
        self.titleLabel.isHidden = true
        self.view.addSubview(self.titleLabel)
        self.titleLabel.widthEqualToSuperview()
        self.titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.recordButton.bottomAnchor, constant: 30).isActive = true
                
        let smallConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold, scale: .large)
        let closeButton = UIButton()
        closeButton.tintColor = .lightGray
        closeButton.setImage(UIImage(systemName: "xmark.circle", withConfiguration: smallConfig), for: .normal)
        closeButton.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        self.view.addSubview(closeButton)
        closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        closeButton.sizeEqualTo(44, 44)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        
        originNavigationBarHidden = self.navigationController?.isNavigationBarHidden ?? true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        
        onStop()
        self.navigationController?.setNavigationBarHidden(originNavigationBarHidden, animated: animated)
    }
    
    
    @objc private func onRecord() {
        self.recorder = nil
        
        let session = AVAudioSession.sharedInstance()
        if session.recordPermission == .granted {
            startRecording()
            return
        }
        
        do{
            try session.setCategory(.playAndRecord, mode: .default, policy: .default, options:[ .allowBluetoothA2DP,.allowAirPlay,.allowBluetooth])
            session.requestRecordPermission { hasPermission in
                DispatchQueue.main.async {
                    if hasPermission{
                        self.startRecording()
                        return
                    }
                    self.onClose()
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        openAudioSettings()
                    }
                }
            }
        }
        catch{
            let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
            self.show(alertController, sender: nil)
        }
    }
    
    @objc private func onStop() {
        stopRecording()
    }
    
    @objc private func onClose() {
        stopRecording()
        
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
    
    private func startRecording() {
        let settings = [
            AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey:12000,
            AVNumberOfChannelsKey:1,
            AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
        ]
        var basename = UUID().uuidString.appending("aac")
        let path = (NSTemporaryDirectory() as NSString).appendingPathComponent(basename)
        let url = URL(fileURLWithPath: path)
        do {
            self.recorder = try AVAudioRecorder(url: url, settings: settings)
            self.recorder.record()
            
            self.titleLabel.isHidden = false
            self.stopButton.isHidden = false
            self.recordButton.isHidden = true
            self.timerLabel.text = "00:00:00"
            self.timerLabel.isHidden = false
            
            startTimer()
        } catch {
            let alertController = UIAlertController(title: Translate("\(error)"), message: nil, preferredStyle: .alert)
            self.show(alertController, sender: nil)
        }
    }
    
    private func stopRecording() {
        self.titleLabel.isHidden = true
        self.stopButton.isHidden = true
        self.recordButton.isHidden = false
        self.timerLabel.isHidden = true
        self.timerLabel.text = "00:00:00"
        let elapse = endTimer()
        guard let recorder = self.recorder else {
            return
        }
        if !recorder.isRecording {
            return
        }
        recorder.stop()
        let path = recorder.url.absoluteString
        print("audio path: " + path)
        self.delegate?.didCaptureAudio(self, url: recorder.url, elapse: Int64(elapse))
    }
    
    private func startTimer() {
        _ = endTimer()
        var clock = Int64(0);
        self.startAt = Date()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] t in
            guard let strongSelf = self else {
                return
            }
            clock += 1
            strongSelf.timerLabel.text = String(format: "%02d:%02d:%02d", clock / 3600, (clock % 3600) / 60, clock % 60)
        }
    }
    
    private func endTimer() -> TimeInterval {
        if self.timer == nil {
            return 0
        }
        self.timer?.invalidate()
        self.timer = nil
        return Date().timeIntervalSince(startAt)
    }
}
