require 'rubygems'
require 'bundler'

Bundler.require

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require './pai_sho_app'
run PaiShoApp
