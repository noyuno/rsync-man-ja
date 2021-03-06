% rsync(1)
%
% March 2018

# 名前

rsync - 高速，多目的，リモート（とローカル）のファイルコピーツール

# 書式

ローカル:  rsync [OPTION...] SRC... [DEST]

リモートシェル経由でのアクセス:

~~~
Pull: rsync [OPTION...] [USER@]HOST:SRC... [DEST]
Push: rsync [OPTION...] SRC... [USER@]HOST:DEST
~~~

rsync デーモン経由でのアクセス:

~~~
Pull: rsync [OPTION...] [USER@]HOST::SRC... [DEST]
      rsync [OPTION...] rsync://[USER@]HOST[:PORT]/SRC... [DEST]
Push: rsync [OPTION...] SRC... [USER@]HOST::DEST
      rsync [OPTION...] SRC... rsync://[USER@]HOST[:PORT]/DEST
~~~

一つだけの SRC 引数かつ DEST 未指定で SRC を一覧表示する（コピー前に便利）．

# 説明

rsync は高速で非常に汎用性のあるコピーツールである．
ローカルからリモートシェル経由もしくは rsync デーモンで他のホストへ
（またはその逆方向で）コピーすることができる．
ファイルのコピーの動作のあらゆる側面を制御し非常に柔軟な指定ができるよう，
多くのオプションを提供する．
rsync はデルタ転送アルゴリズム（delta-transfer algorithm）で有名で，
ソースと宛先で異なったファイルだけを送信することでネットワーク帯域使用量を減らす．
rsync は copy コマンドの拡張版としてバックアップやミラーリングとして日々広く使われている．

rsync は（既定では）「クイックチェック」アルゴリズムを使用して，転送する必要のある
サイズや最終変更時刻が変更されたファイルを探す．
クイックチェックでファイルのデータを更新する必要がないと判断された場合は，
（オプションによって要求された）属性の変更については宛先ファイルに対して直接行われる．

rsync のいくつかの追加の機能は:

- リンク，デバイス，所有者，グループ，およびパーミッションのコピーのサポート
- GNU tar に似た exclude および exclude-from オプション
- CVS が無視するファイルを無視する「CVS 除外モード」
- ssh や rsh を含む透過的なリモートシェルが利用可能
- スーパーユーザ権限を必要としない
- レイテンシコストを最小限に抑えるためのファイル転送のパイプライン化
- （ミラーリングに最適な）匿名または認証された rsync デーモンのサポート

# 一般

rsync はローカルとリモートホストでファイルを相互にコピーしたり，
このホストでローカルにコピーする
（しかし，2つのリモートホスト間でのファイルのコピーはサポートしていない）．

rsync がリモートシステムにアクセスするには，2つの方法がある: 
(1) （ssh や rsh のような）リモートシェルプログラムでトランスポート，
(2) rsync デーモンにTCPで直接接続する．
ソースまたは宛先パスにホスト指定のあとにコロン（:）区切り文字が1つ含まれているときは，
常にリモートシェル転送が使われる．
ダブルコロン（::）区切り文字が含まれているとき，または rsync:// URLが指定されているときは，
rsync デーモンに直接接続する
（後者のルールの例外は「リモートシェル接続での rsync デーモンの特徴」を参照）．

特殊なケースとして，単一のソース arg が宛先なしに指定されたときは，
"ls -l" と同様の書式で出力される．

当然，ソースパスおよび宛先パスのいずれにもリモートホストを指定していないときは，
コピーはローカルで発生する（**----list-only** オプションを参照）．

rsync はローカル側を「クライアント」，リモート側を「サーバ」と呼ぶ．
「サーバ」と rsync デーモンを混同しないこと．
デーモンは常にサーバだが，サーバはデーモンまたはリモートシェル生成プロセスのいずれかになる．

# 設定

インストール方法は README を参照すること．

インストールが完了したら，（rsync デーモンモードプロトコルを使用してアクセスできることと同様に）
リモートシェルを介してアクセスできる任意のマシンに rsync を使用できる．
リモート転送の場合，最新の rsync は通信に ssh を使用するが，
既定で rsh や remsh などの別のリモートシェルを使用するよう設定されている可能性がある．

**-e** コマンドラインオプションを使用するか， 
RSYNC_RSH 環境変数を設定して任意のリモートシェルを指定することもできる．

rsync はソースと宛先のマシンの両方にインストールする必要がある．

# 使用方法

rsync は rcp と同じ方法で使用する．
ソースと宛先を指定する必要があるが，そのうち1つはリモートになることがある．

おそらく，構文を説明する最良の方法はいくつかの例だろう．

~~~
rsync -t *.c foo:src/
~~~

これは，カレントディレクトリのパターン \*.c に一致するすべてのファイルを
マシン foo のディレクトリ src に転送する．
ファイルのいずれかがすでにリモートシステムに存在する場合，
rsync リモート更新プロトコル（remote-update protocol）を使用して
データの差分のみを送信してファイルを更新する．
コマンドラインでのワイルドカード（\*.c）を使ったファイルリストの展開は，
（他のすべての POSIX スタイルのプログラムとまったく同じように）
rsync を実行する前にシェルによって処理され，rsync 自体は取り扱わないことに注意すること．

~~~
rsync -avz foo:src/bar /data/tmp
~~~

これは， foo マシンの src/bar ディレクトリからローカルマシン上の /data/tmp/bar
ディレクトリにすべてのファイルを再帰的に転送する．
ファイルは，シンボリックリンク，デバイス，属性，パーミッション，所有権などが
確実に保持される「アーカイブ」モードで転送される．
さらに，転送時にはデータ部のサイズを縮小するために圧縮される．

~~~
rsync -avz foo:src/bar/ /data/tmp
~~~

ソース上の末尾にスラッシュをつけると，この動作が変わり，
宛先に追加のディレクトリレベルが作成されなくなる．
この / の扱いは，「名前によるディレクトリのコピー」とは対照的に，
「このディレクトリの内容をコピーする」という意味で考えることができるが，
どちらの場合においても含まれるディレクトリの属性は宛先に転送される．
つまり，次の各コマンドは /dest/foo の属性を含めて同じ方法でコピーする．

~~~
rsync -av /src/foo /dest
rsync -av /src/foo/ /dest/foo
~~~

