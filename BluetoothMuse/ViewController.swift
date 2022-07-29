//
//  ViewController.swift
//  BluetoothMuse
//
//  Created by Yamini Dharmasala on 7/12/22.
//

import UIKit
import XvMuse

class ViewController: UIViewController, XvMuseDelegate {
    func didReceiveUpdate(from eeg: XvMuseEEG) {
        let leftForeheadDelta:Double = eeg.leftForehead.delta.decibel
        print(leftForeheadDelta)
    }
    
    func didReceiveUpdate(from ppg: XvMusePPG) {
        let ppgData:Int = ppg.sensors.capacity
        print(ppgData)
    }
    
    func didReceive(ppgHeartEvent: XvMusePPGHeartEvent) {}
    
    func didReceiveUpdate(from accelerometer: XvMuseAccelerometer) {}
    
    func didReceiveUpdate(from battery: XvMuseBattery) {}
    
    func didReceive(commandResponse: [String : Any]) {}
    
    func museIsConnecting() {}
    
    func museDidConnect() {}
    
    func museDidDisconnect() {}
    
    func museLostConnection() {}
    
    
    let muse:XvMuse = XvMuse(deviceUUID: "36821D86-BD54-5AD9-D8CB-5EF1EA11FBB8")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
   
    
   
    
    @IBAction func connectButton(_ sender: Any) {
        print("Connecting Bluetooth")
        muse.bluetooth.connect()
    }
    
    @IBAction func disconnectButton(_ sender: Any) {
        print("Disconnecting Bluetooth")
        muse.bluetooth.disconnect()
    }
    
    
    @IBAction func startStreamButton(_ sender: Any) {
        print("Start Streaming")
        muse.delegate = self
        muse.bluetooth.startStreaming()
    }
    

    @IBAction func pauseStreamButtom(_ sender: Any) {
        print("Pause Streaming")
        muse.bluetooth.pauseStreaming()
    }
    
    
    
}

