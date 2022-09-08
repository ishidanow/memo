## まとめ

### シェル取得：
- IPC$を利用し、Lookupsidsでユーザ名情報を列挙
- ASREPRoastingにより、Kerberos事前認証を必要としないユーザを発見。TGTハッシュを入手
- TGTハッシュを解析し、t-skid(ドメインユーザ)のクレデンシャル情報取得
- ドメインユーザのクレデンシャル情報を利用し、Kerberoasting実行。サービスアカウントのSevice Ticketハッシュを入手
- Service Ticketハッシュからサービスアカウントのクレデンシャル情報を入手
- サービスアカウントでSMBアクセスし、Domain Adminsグループに属するユーザのクレデンシャル情報を入手
- WinRMによりシェル取得

### 権限昇格：
- DCSyncによりAdministratorのNTLMハッシュを入手
- Pass the HashによりAdministratorアカウントでWinRM接続

## 提供元

https://tryhackme.com/room/vulnnetroasted

## 参考Writeup

https://github.com/r3vshell/write-ups/blob/main/VulnNet-Roasted.md <br>
https://sidchn.github.io/posts/thm-vullnet-roasted/

## ポートスキャン

![image](https://user-images.githubusercontent.com/82632174/189126062-0c76f5b5-7818-41cc-a0e3-0a959523b046.png) <br>
※Kerberosサーバがあることから、Active Directory端末であると推測できる

## SMB Enum：guestユーザー

![image](https://user-images.githubusercontent.com/82632174/189126214-fdd2cfc0-48f3-447d-8598-403354c67935.png) <br>
```
-H：調査対象端末のIPアドレス
-u：ユーザ名
-p：パスワード
```
パスワードなし(guestユーザ)でアクセス可能な共有フォルダを列挙している。<br>
いくつかの共有がRead Onlyでアクセスできることがわかる。<br>

上記の共有にアクセスし、中身を確認する。<br>
![image](https://user-images.githubusercontent.com/82632174/189126450-2167a319-78dc-4a09-addc-177e572cf99f.png) <br>
※Business-xxx.txtというテキストファイルを発見。ローカルにコピーする。<br>
![image](https://user-images.githubusercontent.com/82632174/189126525-d9e022c7-6e6e-47d7-b838-a904c988b926.png) <br>
※同様にEnterprise-xx.txtというテキストファイルを発見<br>

ファイルを確認したところ、何人かのユーザ名情報を取得することできた。<br>
![image](https://user-images.githubusercontent.com/82632174/189126633-47774e8b-07d7-4898-b3d2-24b22c27ccf3.png) <br>
※結果として、これらのユーザ名情報は有用なものではなかった。

## IPC$共有によるアカウント情報の列挙

ターゲット端末のIPC共有に対して匿名でSMBアクセスし、アカウント情報を列挙する<br>
![image](https://user-images.githubusercontent.com/82632174/189126828-fc8b6684-7046-4ada-bc50-b1936e608c47.png) <br>
※いくつかのドメインアカウントを発見 <br>

上記アカウント名を以下のようにusers.txtという名前で保存する。<br>
(今回はRIDが1000以上のもののみ抜粋)<br>
```
WIN-2BO8M1OE1M1$
DnsAdmins
DnsUpdateProxy
enterprise-core-vn
a-whitehat
t-skid
j-goldenhand
j-leet
```

## ASREPRoasting：ドメインアカウントのパスワードクラック

![image](https://user-images.githubusercontent.com/82632174/189127198-73e6fca9-efa8-4184-831f-36ef7b123774.png) <br>
※t-skidがDONT_REQ_PREAUTHフラグ有効なため、パスワードなしにTGT(およびパスワードハッシュ)を取得可能。<br>
![image](https://user-images.githubusercontent.com/82632174/189129727-2b703ae6-7bac-4642-8887-13d6c51febe6.png) <br>
※t-skidのパスワードがtj072889*であることがわかる

## Kerberoasting：サービスアカウントのパスワードクラック

t-skidでアクセスできるSMB共有にはFlag情報はなかったため、より権限の強いと思われるサービスアカウントのクラックを目指す。<br>
※厳密にはa-whitehatというDomain Adminユーザのログイン情報が書かれたファイルがあったがそれは後述<br>
![image](https://user-images.githubusercontent.com/82632174/189129988-9d203a9e-2765-44c2-95f0-04167aa83861.png) <br>
※enterprise-core-vnというサービスアカウントがあることがわかる。<br>
　また上記サービスアカウントのService Ticketを入手することでパスワードハッシュを入手<br>
![image](https://user-images.githubusercontent.com/82632174/189130122-67bf54fb-d268-4957-9147-b5eb8a3569af.png) <br>
※パスワードの解析に成功 <br>

## WinRMによるシェルアクセス：enterprise-core-vn

EvilWinRMのエラーでアクセスできず(wmiexecでアクセスできたがキャプチャ忘れ) <br>
本来はここでFlag①をゲットできる

## WinRMによるシェルアクセス：a-whitehat

![image](https://user-images.githubusercontent.com/82632174/189131186-6a0c0844-1293-4f53-96aa-bffd6221de2d.png) <br>
※a-whitehatユーザでWinRMアクセスに成功

問題文よりDesktopフォルダにフラグがあるとのことなので、移動してファイルを見てみる。<br>
![image](https://user-images.githubusercontent.com/82632174/189131359-cca15351-ede2-4abe-aa50-d6f6d5975946.png) <br>
※ユーザフォルダは「Administrator」と「enterprise-core-vn」しかないことがわかる。<br>
![image](https://user-images.githubusercontent.com/82632174/189131461-cfbce8e8-fce0-4d62-9da6-7048766358a8.png) <br>
※1つ目のフラグを取得成功<br>
![image](https://user-images.githubusercontent.com/82632174/189131558-c56e353d-08b9-434a-b800-c51da6ae65b0.png) <br>
※2つ目のフラグはアクセスに失敗<br>
![image](https://user-images.githubusercontent.com/82632174/189131639-9d2cd20e-c420-4316-95dc-164629ce16ef.png) <br>
※system.txtを取得するにはAdministratorユーザでログインする必要がある<br>

## クレデンシャル情報のダンプ：DCSync

Administratorユーザでログインするためにクレデンシャル情報を収集したい。<br>
a-whitehatがドメイン管理者である場合、SAMデータベースのダンプが行えるため、ユーザ詳細を確認する。<br>
<details>
<summary>参考：DCSyncについて</summary>

⇒DS-Replication-Get-Changes-All および DS-Replication-Get-Changes の権限を持っている場合<br>
 （デフォルトでは DC Administrators や Domain Admins または Enterprise Admin などの高権限グループのメンバーが所持)、<br>
  Active Directoryのデータを複製・管理するためのRPCプロトコルであるMS-DRSRを利用してDCになりすまし、データベースを同期(コピー)することができる。<br>
impacket-secretsdumpはデータベースを不正同期した後、コピーしたデータベースの中身を参照することでクレデンシャル情報をダンプしている。

</details>


![image](https://user-images.githubusercontent.com/82632174/189131962-48edf0d8-a714-41e4-8de8-3404c1253e62.png) <br>
※a-whitehatがドメイン管理者であることがわかる <br>
![image](https://user-images.githubusercontent.com/82632174/189132044-980af517-884c-42c8-ab11-4df56c9ba380.png) <br>
※net userコマンドでも同様にドメイン管理者であると確認可能

![image](https://user-images.githubusercontent.com/82632174/189132151-7a5450fa-4741-4c3f-bcc2-fd96f847d733.png) <br>
![image](https://user-images.githubusercontent.com/82632174/189132184-a2abfe42-4358-4db2-a22e-9ce634444432.png) <br>
※AdministratorユーザのLMハッシュとNTLMハッシュを取得成功 <br>

## WinRMによるシェルアクセス＋Pass the Hash：Administrator

![image](https://user-images.githubusercontent.com/82632174/189132357-fb16f10d-7e10-48f7-9d61-fc1b1eed14bb.png) <br>
※Pass the HashによりAdministratorユーザでログイン



