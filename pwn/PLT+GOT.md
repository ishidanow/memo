## PLT, GOTとは

ライブラリ関数を呼び出す際の仕組み。<br>
PLTがライブラリ関数のアドレスを解決し、GOTに解決したアドレスをキャッシュする。

関数が一度も呼び出されてない時は、GOTにはPLTの2行目にある命令のアドレス(アドレス解決処理)が格納されており、<br>
関数が一度呼び出されると、外部ライブラリの該当関数のアドレスがGOTに格納される。

## PLT, GOTのアドレス検索

### objdumpで見る場合

#### intelマイコン向けバイナリの場合：
`objdump -d -M intel [バイナリファイル] | grep "@plt>:" -A1` <br>
![image](https://user-images.githubusercontent.com/82632174/189111798-dd2e4400-6545-47be-b895-28f36ae48e22.png) <br>

#### ARMマイコン向けバイナリの場合
`arm-none-eabi-objdump -m arm -D [ELFファイル] | grep "@plt>:" -A1` <br>

### gdbで見る場合
手順①：gdbを起動

手順②：plt, gotアドレスを表示
`plt`
![image](https://user-images.githubusercontent.com/82632174/189112077-5cd421a9-273a-4fdf-8f5e-22be8bb41a74.png) <br>
※PLTとGOTのアドレスが表示されている

