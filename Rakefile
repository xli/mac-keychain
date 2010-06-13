
require 'rubygems'
require 'echoe'

Echoe.new('mac-keychain', '0.0.1') do |p|
  p.description     = "Mac-Keychain -- Ruby interface to Mac OSX Keychain"
  p.url             = "https://github.com/xli/mac-keychain"
  p.author          = "Li Xiao"
  p.email           = "iam@li-xiao.com"
  p.ignore_pattern  = ["*.gemspec", 'lib/Security.bridgesupport']
  p.development_dependencies = ['rake', 'echoe']
  p.test_pattern    = "test/test_*.rb"
  p.rdoc_options    = %w(--main README.rdoc --inline-source --line-numbers --charset UTF-8)
  p.extension_pattern = "ext/**/rakefile"
end

namespace :generate do
  task :bridge do
    puts "generating lib/Security.bridgesupport"
    puts %x[gen_bridge_metadata -f Security -o lib/Security.bridgesupport]
  end
end