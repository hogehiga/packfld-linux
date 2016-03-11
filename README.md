# packfld-linux

## 注意
このソフトウェアの開発は中止されました。代わりに <https://github.com/jgoerzen/datapacker> を使って下さい。

## これは何?
Packfld(<http://www.vector.co.jp/soft/win95/util/se311425.html>)のLinux版です。
あるディレクトリ内のディレクトリやファイルを、指定した容量以下になるように分割し、そのパスのリストを出力します。
ビンパッキング問題の解法による振り分けのみが実装されています。

## 実行例
Ruby 2.0.0p481でのみ動作確認しています。

```
-> % packfld-linux.rb -i /usr/bin -s 37956760
-> % ls
packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-0  packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-3  packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-6
packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-1  packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-4  packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-7
packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-2  packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-5
-> % head packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-0
"/usr/bin/pnmcut"
"/usr/bin/vfnmz"
"/usr/bin/mesg"
"/usr/bin/montage"
"/usr/bin/gresource"
"/usr/bin/mkpasswd"
"/usr/bin/linkicc"
"/usr/bin/namei"
"/usr/bin/emacs24"
"/usr/bin/kde-mv"
-> % cat packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-0 | xargs du -sb | awk '{sum += $1}END{print sum}'
37911405
-> % cat packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-1 | xargs du -sb | awk '{sum += $1}END{print sum}'
37956760
-> % cat packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-2 | xargs du -sb | awk '{sum += $1}END{print sum}'
37956760
-> % cat packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-3 | xargs du -sb | awk '{sum += $1}END{print sum}'
37956760
-> % cat packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-4 | xargs du -sb | awk '{sum += $1}END{print sum}'
33480272
-> % cat packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-5 | xargs du -sb | awk '{sum += $1}END{print sum}'
37794303
-> % cat packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-6 | xargs du -sb | awk '{sum += $1}END{print sum}'
37956760
-> % cat packed-files-a29ecc16-3c8a-4963-9989-d39e23de7340-7 | xargs du -sb | awk '{sum += $1}END{print sum}'
26487180
-> % 
```

## ライセンス
リポジトリ内にあるLICENSEファイルを参照して下さい。
