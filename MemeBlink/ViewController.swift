//
//  ViewController.swift
//  MemeBlink
//
//  Created by 古川信行 on 2015/04/18.
//  Copyright (c) 2015年 古川信行. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MEMELibDelegate {

    //Find & Connect ボタン
    @IBOutlet weak var btnFindAndConnect: UIButton!
    
    //瞬き回数
    var blinkCnt = 0;
    
    //瞬き検知した回数を表示
    @IBOutlet weak var lblBlinkCnt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Find & Connect ボタン を 使用不可に設定
        //MEMELibの認証が成功してから有効にする
        btnFindAndConnect.enabled = false;
        
        //MEMELib にデリゲート設定
        MEMELib.sharedInstance().delegate = self;
        //centralManagerEnabled プロパティの値の変化を監視
        MEMELib.sharedInstance().addObserver(self,forKeyPath:"centralManagerEnabled",options:.New,context:nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //プロパティ監視メッセージの受信
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        println("observeValueForKeyPath \(keyPath)");
        if keyPath == "centralManagerEnabled"{
            // centralManagerEnabled に変化があった
        }
        
    }
    
    //Find & Connect ボタン クリック時
    @IBAction func clickBtnFindAndConnect(sender: AnyObject) {
        //TODO: 認証成功したら(memeAppAuthorized デリゲートのレスポンスが成功時) MEME検索が可能
        
        //MEMEデバイススキャン 開始
        MEMELib.sharedInstance().startScanningPeripherals();
    }
    
    // MARK: MEMELib Delegates ----------
    
    //認証結果を受け取るデリゲート
    func memeAppAuthorized(status:MEMEStatus){
        println("memeAppAuthorized \(status)");
        //TODO: 認証成功したらMEME検索が可能
        //Find & Connect ボタン を 使用可能に設定
        btnFindAndConnect.enabled = true;
    }
    
    //スキャン結果受信デリゲート
    func memePeripheralFound(peripheral:CBPeripheral){
        println("memePeripheralFound");
        
        //TODO デモ用に見つかったMEMEに接続
        // 本来はリスト等に追加して選択させたりする必要がある。
        let status = MEMELib.sharedInstance().connectPeripheral(peripheral);
        println("connectPeripheral status:\(status)");
    }
    
    //JINS MEMEへの接続完了を受け取るデリゲート
    func memePeripheralConnected(peripheral:CBPeripheral){
        println("memePeripheralConnected");

        // Set Data Mode to Standard Mode
        MEMELib.sharedInstance().changeDataMode(MEME_COM_REALTIME);
    }
    
    //リアルタイムモードのデータを受け取るデリゲート
    func memeRealTimeModeDataReceived(data:MEMERealTimeData){
        println("memeRealTimeModeDataReceived \(data)");
        
        //まばたきの強さを検知したら瞬き回数を加算
        // MEMERealTimeData のパラメータについては SDK同封の api_ios_meme_realtime_data.html 等を参照
        if data.blinkStrength > 0 {
            self.blinkCnt++;
            lblBlinkCnt.text = String(format:"%d",self.blinkCnt);
        }
    }
    
    //JINS MEMEとの切断を受け取るデリゲート
    func memePeripheralDisconnected(peripheral:CBPeripheral){
        println("memePeripheralDisconnected");
    }


}

