//
//  CameraViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {

    // Capture Session
    var captureSession = AVCaptureSession()

    // Capture Device
    var captureDevice: AVCaptureDevice?

    // Capture Output
    var captureOutput = AVCaptureMovieFileOutput()

    // Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?

    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()

    private let recordButton = RecordButton()

    private var previewLayer: AVPlayerLayer?

    var recordedVideoURL: URL?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(cameraView)
        view.addSubview(recordButton)
        setUpCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 80
        recordButton.frame = CGRect(x: (view.width-size)/2,
                                    y: view.height - view.safeAreaInsets.bottom - size - 5,
                                    width: size,
                                    height: size)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }

    @objc private func didTapRecord() {
        if captureOutput.isRecording {
            // stop recording
            recordButton.toggle(for: .notRecording)
            captureOutput.stopRecording()
            HapticsManager.shared.vibrateForSelection()
        } else {
            guard var url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else {
                return
            }

            HapticsManager.shared.vibrateForSelection()

            url.appendPathComponent("video.mov")

            recordButton.toggle(for: .recording)

            try? FileManager.default.removeItem(at: url)

            captureOutput.startRecording(to: url,
                                         recordingDelegate: self)
        }
    }

    @objc private func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        } else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .black
            tabBarController?.tabBar.tintColor = .white
            tabBarController?.tabBar.standardAppearance = appearance
            tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance

        } else {
            tabBarController?.tabBar.tintColor = .white
            tabBarController?.tabBar.backgroundColor = .black
        }

    }

    private func setUpCamera() {
        // Add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }

        }

        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }

        }

        // update session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        // configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds

        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }

        // Enable camera start
        captureSession.startRunning()
    }

}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {

        guard error == nil else {
            let alert = UIAlertController(title: "Woops",
                                          message: "Something went wrong when recording your video",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        recordedVideoURL = outputFileURL

        if UserDefaults.standard.bool(forKey: "save_video") {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))

        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        guard let previewLayer = previewLayer else {
            return
        }
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }

    @objc private func didTapNext() {
        guard let url = recordedVideoURL else {
            return
        }

        HapticsManager.shared.vibrateForSelection()
        // Push caption controller
        let vc = CaptionViewController(videoURL: url)
        navigationController?.pushViewController(vc, animated: true)

    }

}
