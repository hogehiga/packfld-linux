#!/usr/bin/ruby
# coding: utf-8

###### このプログラムについて ######
# Packfld(http://www.vector.co.jp/soft/win95/util/se311425.html)にインスパイアされて作られたものです。
# 適当な一分割あたりのサイズとディレクトリを指定すると、そのディレクトリ直下のディレクトリとファイルのリストを、いくつかのファイルに分割して書き出します。
# 1つのファイルに載っているディレクトリとファイルの合計容量は、指定した一分割あたりのサイズに収まるようになっています。
# サイズの大きいディレクトリを、分割して光ディスクにバックアップするときに便利だと思います。


require 'securerandom'
require 'optparse'

#####メソッド#####
# 使い方を表示する。
def usage
  STDERR.puts "usage: #{File.basename($0)} -i input_directory -s div_size_in_byte [-x exclude]"
  STDERR.puts "tips: files and directories in exclude is not considerd on this program"
  STDERR.puts "example of exclude: cat exclude"
  STDERR.puts "/some/dir/will/be/excluded"
  STDERR.puts "/some/file/will/be/excluded"
  STDERR.puts ""
  STDERR.puts "warning: This script make many files in current directory."
end

# dirのサブディレクトリを含めたディスク使用量を取得する。移植性が低いが、他に方法がわからなかった
def dir_size(dir)
  `du -bs \"#{dir}\" | awk '{print $1}'`.chomp
end


#####メイン#####
params = ARGV.getopts('i:s:x:').inject({}) { |hash, (k, v)| hash[k.to_sym] = v; hash }
if params[:i].nil? || params[:s].nil?
  usage
  exit 1
end

unless Dir.exist? params[:i]
  STDERR.puts "Directory #{params[:i]} not exists."
  exit 1
end

div_size = params[:s].to_i
div_size.freeze
if div_size == 0
  STDERR.puts "div_size_in_byte must be greater than 0."
  exit 1
end


# 指定されたディレクトリ直下のファイルとディレクトリ及びそのディスク使用量を取得
path_and_size = []
entries = Dir::entries(params[:i])
entries.delete('.')
entries.delete('..')
unless params[:x].nil?
  File.foreach(params[:x]) do |l|
    entries.delete(l.chomp)
  end
end
entries.map! {|e| e = "#{params[:i]}/#{e}"}
size_check_passed = true
entries.each do |entry|
  ent_size = dir_size(entry).to_i
  if ent_size > div_size
    STDERR.puts "div_size_in_byte(#{div_size}) must be greater than size of directory #{entry} (size is #{ent_size})."
    size_check_passed = false
  end
  path_and_size.push({ path: entry, size: ent_size })
end

unless size_check_passed
  exit 1
end

# ビンパッキング問題を解く(WikipediaのアルゴリズムB)
bins = []
path_and_size.each do |entry|
  ent_size = entry[:size].to_i
  min_bin = bins.select { |b| b[:left_space] >= ent_size }.min_by { |b| b[:left_space] }
  if min_bin.nil?
    bins.push({ entries: [entry], left_space: div_size - ent_size})
  else
    min_bin[:entries].push(entry)
    min_bin[:left_space] -= ent_size
  end
end

# 結果をファイルに書き出す
f = SecureRandom.uuid
bins.each_with_index do |bin, i|
  arr = []
  bin[:entries].each do |ent|
    arr.push("\"#{ent[:path]}\"")
  end
  File.write("packed-files-#{f}-#{i}", arr.join("\n") + "\n")
end
