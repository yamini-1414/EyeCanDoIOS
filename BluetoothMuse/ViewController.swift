//
//  ViewController.swift
//  BluetoothMuse
//
//  Created by Yamini Dharmasala on 7/12/22.
//

import UIKit
import XvMuse
import Charts

class ViewController: UIViewController, XvMuseDelegate, ChartViewDelegate {
    var data1:[Double] = []
    var data2: [Double] = []
    var data3: [Double] = []
    var data4: [Double] = []
    let muse:XvMuse = XvMuse(deviceUUID: "36821D86-BD54-5AD9-D8CB-5EF1EA11FBB8")
    var myCustomBins:[Int]? = nil
    
    @IBOutlet weak var chartView: LineChartView!
    
    
    func didReceiveUpdate(from eeg: XvMuseEEG) {
        data1.append(contentsOf: eeg.TP9.getDecibelSlice(fromBinRange: myCustomBins!))
        data2.append(contentsOf:eeg.FP1.getDecibelSlice(fromBinRange: myCustomBins!))
        data3.append(contentsOf: eeg.FP2.getDecibelSlice(fromBinRange: myCustomBins!))
        data4.append(contentsOf: eeg.TP10.getDecibelSlice(fromBinRange: myCustomBins!))
        //print(eeg.TP9.getDecibelSlice(fromBinRange: myCustomBins!))
    
    }
    
    func didReceiveUpdate(from ppg: XvMusePPG) {}
    
    func didReceive(ppgHeartEvent: XvMusePPGHeartEvent) {}
    
    func didReceiveUpdate(from accelerometer: XvMuseAccelerometer) {}
    
    func didReceiveUpdate(from battery: XvMuseBattery) {}
    
    func didReceive(commandResponse: [String : Any]) {}
    
    func museIsConnecting() {}
    
    func museDidConnect() {}
    
    func museDidDisconnect() {}
    
    func museLostConnection() {}
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.muse.delegate = self
        self.chartView.delegate = self
        myCustomBins = muse.eeg.getBins(fromFrequencyRange: [7.5, 45.0])
        view.addSubview(chartView)
        setCharData()
       }
    
    
    func setCharData(){
        let charDataset1: LineChartDataSet = LineChartDataSet(entries:[ChartDataEntry](), label: "TP9")
        charDataset1.drawCirclesEnabled = false
        charDataset1.setColor(UIColor.blue)
        
        
        let charDataset2: LineChartDataSet = LineChartDataSet(entries:[ChartDataEntry](), label: "FP1")
        charDataset2.drawCirclesEnabled = false
        charDataset2.setColor(UIColor.green)
        
        
        let charDataset3: LineChartDataSet = LineChartDataSet(entries:[ChartDataEntry](), label: "FP2")
        charDataset3.drawCirclesEnabled = false
        charDataset3.setColor(UIColor.red)
        
        
        let charDataset4: LineChartDataSet = LineChartDataSet(entries:[ChartDataEntry](), label: "TP10")
        charDataset4.drawCirclesEnabled = false
        charDataset4.setColor(UIColor.orange)
        
        
        let charData = LineChartData(dataSets: [charDataset1, charDataset2, charDataset3, charDataset4])
        chartView.data = charData
        chartView.xAxis.labelPosition = .bottom
    }
    var k:Int=0
    @objc func updateData(){
        if (data1.count > 0 && k<data1.count){
        let val1 = (data1[k]*10).rounded() / 10
        let val2 = (data2[k]*10).rounded()/10
        let val3 = (data3[k]*10).rounded()/10
        let val4 = (data4[k]*10).rounded()/10
        let newEntry1 = ChartDataEntry(x:Double(k), y:val1)
        let newEntry2 = ChartDataEntry(x:Double(k), y:val2)
        let newEntry3 = ChartDataEntry(x:Double(k), y:val3)
        let newEntry4 = ChartDataEntry(x:Double(k), y:val4)
        chartView.data?.appendEntry(newEntry1, toDataSet: 0)
        chartView.data?.appendEntry(newEntry2, toDataSet: 1)
        chartView.data?.appendEntry(newEntry3, toDataSet: 2)
        chartView.data?.appendEntry(newEntry4, toDataSet: 3)
        while ((chartView.data?[0].entryCount)! > 60){
            let _ = chartView.data?[0].removeFirst()
            let _ = chartView.data?[1].removeFirst()
            let _ = chartView.data?[2].removeFirst()
            let _ = chartView.data?[3].removeFirst()
        }
        for startIdx in 1..<(chartView.data?[0].entryCount)! {
            chartView.data?[0].entryForIndex(startIdx - 1)!.x = Double(startIdx);
            chartView.data?[1].entryForIndex(startIdx - 1)!.x = Double(startIdx);
            chartView.data?[2].entryForIndex(startIdx - 1)!.x = Double(startIdx);
            chartView.data?[3].entryForIndex(startIdx - 1)!.x = Double(startIdx);
        }
        self.chartView.notifyDataSetChanged()
        self.chartView.moveViewToX(Double(CGFloat.greatestFiniteMagnitude))
        k = k + 1
        }
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
        muse.bluetooth.startStreaming()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    
    
    @IBAction func pauseStreamButtom(_ sender: Any) {
        print("Pause Streaming")
        muse.bluetooth.pauseStreaming()
    }
    
    
    
}

