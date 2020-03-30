//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jae Paek on 3/29/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordButton.isEnabled = false;
    }
    
    // MARK: - Configure which button should be enabled
    func configureUI(_ isRecording: Bool) {
        if(isRecording) {
            recordLabel.text = "Recording in progress"
            stopRecordButton.isEnabled = true
            recordButton.isEnabled = false
        }
        else {
            recordButton.isEnabled = true
            stopRecordButton.isEnabled = false
            recordLabel.text = "Tap to Record"
        }
    }
    
    // MARK: - Start recording audio until stop button is pressed
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(true)

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: - Stop recording audio and segue into the play screen
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

