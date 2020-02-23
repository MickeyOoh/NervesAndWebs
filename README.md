Firmware
-----
Rpi2 + GrovePi -- it sends data to the host named display through node.

data
1. picam - camera data 
2. each Grobepi data such as temprature and humudity

grovepi
----
it doesn't work as a original library, so modification is needed.


Display
----
web server 
1. motion Jpeg
2. LiveView 
3. recieve image file from Nerves target

Nerves Module v1.5.3
-----
3つの構成から成る
Platform - カスタマイズされた、最小のBuildrootをもとにしたLinuxで直接BEAM VMにbootする

Framwork - レディトゥゴーのライブラリーモジュールで起動と実行がすばやく行う

Tooling - パワフルなコマンドラインのツールでビルド、更新ゆ、各デバイス設定などを行う




