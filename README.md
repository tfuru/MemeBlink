# JINS MEME SDK を使った Swift プロジェクト

Swift で JINS MEME SDK 使うサンプルと 手順を書いたメモ

## サンプル プロジェクト

 瞬き回数をカウントするサンプル

## 手順

1, MemeBlink/MEME デレクトリに MEMELib.framework ファイルをコピーする

JINS MEME SDK は下サイトからダウンロードできます。

https://developers.jins.com/ja/sdks/ios/

2, プロジェクトの Embedded Binarys に MEMELib.framework を追加する

3, Uses Bluetooth LE accessories設定をする

ターゲット設定 Capabilities -> Backend Modes の Uses Bluetooth LE accessories にチェックを入れる

4, BridgingHeader を利用する

プロジェクト ${ProductModuleName}-Bridging-Header.h ファイルを追加
```
#define JINS_MEME_APP_ID @“JINS MEME アプリ登録で発行されるアプリID"
#define JINS_MEME_CLIENT_SECRET @“JINS MEME アプリ登録で発行されるアプリSecret"
//JINS MEM Lib を インポート
#import <MEMELib/MEMELib.h>
```
5, AppDelegate  didFinishLaunchingWithOptions に MEMELibアプリ認証とSDK認証を行うコードを追加

```
例) //MEME Lib を初期化
MEMELib.setAppClientId(JINS_MEME_APP_ID,clientSecret:JINS_MEME_CLIENT_SECRET);
```

6, ViewController viewDidLoad に MEMELib初期設定コードを追加
```
ViewController に MEMELibDelegate 追加

//MEMELib にデリゲート設定
MEMELib.sharedInstance().delegate = self;
 
//centralManagerEnabled プロパティの値の変化を監視
MEMELib.sharedInstance().addObserver(self,forKeyPath:"centralManagerEnabled",options:.New,context:nil);

….. 以下省略 サンプルプロジェクトを参照してください。
```
