#!/usr/bin/env ruby
#encoding: utf-8

require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
x = ch.fanout("logs")

msg = ARGV.empty? ? "Hello world!" : ARGV.join(" ")

x.publish(msg)
puts " [x] Sent '#{msg}'"

conn.close
