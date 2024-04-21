network namspace
TCP(Transmission Control Protocol)
IP(Internet Protocol)
TCP/IPにおける階層構造の定義
RFC1122
アプリケーション層
トランスポート層
インターネット層
リンク層

ping -c 3 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=116 time=21.1 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=116 time=15.5 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=116 time=15.6 ms

--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 15.537/17.414/21.129/2.626 ms

icmp

8.8.8.8はGoogleが運用する公開DNSサーバー
IPでの送信単位→パケット（もしくはデータグラム）

コンピューターのIPアドレスを表示
ip address show 
このコマンドを実行して表示されるloやens3などはネットワークインターフェースを表す

ネットワークインタフェースはNICをソフトウェアから使うために抽象化した概念

IPアドレスは必要に応じてネットワークインターフェイスに付与される

ping -c 3 127.0.0.1
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.018 ms
64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.060 ms
64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.061 ms

--- 127.0.0.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2027ms
rtt min/avg/max/mdev = 0.018/0.046/0.061/0.020 ms

pingの通信はIP, ICMPの組み合わせで成り立ってる

Ethernetフレームフォーマット
|プリアンブル（8Byte）|宛先MACアドレス（6Byte）｜送信元MACアドレス（6Byte）｜タイプ（2Byte）｜データ（48Byte）｜FCS（4Byte）

traceroute -n 8.8.8.8

パケットが到達するまでの道のりをみれる
パケットが経由したルータの持っているIPアドレス
ICMPの時間切れメッセージについてるIPアドレスを並べることで、経路を探索する

ホスト：IPアドレスを持ってネットワークにつながってるルータではないコンピュータ

Node: ネートワークにつながったコンピュータの総称

次にパケットを渡す相手はルーティングテーブルで管理する
ルーティングテーブルはインターネットにつながるノードすべてがもっている

ルーティングテーブルの確認
ip route show

10.122.116.0/24→８bit分（2**8 = 256）のIPアドレスをまとめて指定してる


- ネットワークのプロトコルは階層で別れている
- パケットを目的地までとどけるために必要な宛先がIPアドレス

network namesace

ip netns addを使うと新しくNetwork Namespaceを作れる。
`ip netns add <namespace名>`
network namespace 一覧
`ip netns list`
Network Namespaceではコマンドが実行できる
`ip netns exec <namespace名> <コマンド>`
例
`sudo ip netns exec helloworld ip address show`

ネットワーク的にはシステムから独立した領域を作れる
ルーティングテーブルも独立する


veth(Virtual Ethernet Device)  仮想的なネットワークインターフェース
作成したNetwork Namespace同士をつなぎ合わせることができる
vethを作るコマンドは
`ip link add`

sudo ip link add n1-veth0 type veth peer name n2-veth0

vethをNetwork Namespaceの領域に移さないと使うことができない
`ip link set`サブコマンドを使うことでvethインターフェースをNetwork Namespaceに所属させる

sudo ip link set n1-veth0 netns n1
sudo ip link set n2-veth0 netns n2

vethインターフェースにIPアドレスを付与する

ネットワークインターフェースは最初はDOWNしてるため使えない。UPにする必要がある

同じセグメントに属するIPアドレス同士は基本的にルータがなくても通信できる

全部のbitが1のIPアドレスはブロードキャストアドレスと呼ばれる
