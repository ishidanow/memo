## TryHackMeとは

脆弱性を含んだ仮想マシンをコンテナ化して提供しているサイト。

## TryHackMeへのアクセス

OpenVPNを使用してVPN接続する必要がある。

### 手順①：以下のサイトからconfigファイルをダウンロードする<br>
https://tryhackme.com/access?o=vpn
	
### 手順②：VPN接続する<br>
```
sudo apt install openvpn
sudo openvpn [configファイル]
```
![image](https://user-images.githubusercontent.com/82632174/188641890-5b4fbb89-11d3-42f2-a5ab-5f179135e226.png) <br>
※Initialization Sequence Completedと表示されればOK

接続用のConfigファイルを以下のURLからダウンロードする必要があるが、
接続先のサーバの調子(？)が悪いと接続できない場合がある。

![image](https://user-images.githubusercontent.com/82632174/188642070-7133743c-ee8d-479a-95c4-d62ac31ea959.png) <br>

その場合は、VPN Serverを変更し、ページを更新し、Configファイルをダウンロードし直し、OpenVPNに登録しなおすことで
正常にVPN接続できるようになる。

参考：
VPN接続不良のトラブルシューティングは以下のリポジトリのスクリプトを実行することで実施可能。<br>
https://github.com/tryhackme/openvpn-troubleshooting


### 手順③：TryHackMeのサイトにログインする
![image](https://user-images.githubusercontent.com/82632174/188642258-90d5adf5-65bd-47d9-bb7b-6cac8791617c.png) <br>


### 手順④：VPN接続できていることを確認する
![image](https://user-images.githubusercontent.com/82632174/188642361-bf02f5b0-d363-4533-b51e-d764a9411357.png) <br>
右上のユーザーアイコンマークをクリックし「Access」を押すことでVPN接続情報を確認できる。
上記のようにIPが振られていればOK。

## ルームの検索

### 手順①：「Learn」-「Search」でルーム検索画面を表示する<br>
![image](https://user-images.githubusercontent.com/82632174/188642584-2b7fdab3-e800-462e-b8f6-00533d338ff2.png) <br>
※「Show」欄を「All」から「Free Only」に変更することで無課金でもできるルームのみ表示可能

## 攻撃対象マシンの起動

![image](https://user-images.githubusercontent.com/82632174/188642747-3f83fd77-e6bf-49dc-9fd5-651adfee67ff.png) <br>
※ルームに入り、「Start Machine」をクリックすると攻撃対象マシンが起動し、IPアドレス等が上部に表示される。<br>
　IPアドレスが「Shown in XXs」となっている場合は、表示されている時間待てばIPアドレスが表示される。








