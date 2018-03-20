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

Rsync は高速で非常に汎用性のあるコピーツールである．
ローカルからリモートシェル経由もしくは rsync デーモンで他のホストへ
（またはその逆方向で）コピーすることができる．
ファイルのコピーの動作のあらゆる側面を制御し非常に柔軟な指定ができるよう，
多くのオプションを提供する．
Rsync はデルタ転送アルゴリズム（delta-transfer algorithm）で有名で，
ソースと宛先で異なったファイルだけを送信することでネットワーク帯域使用量を減らす．
Rsync は copy コマンドの拡張版としてバックアップやミラーリングとして日々広く使われている．

Rsync は

