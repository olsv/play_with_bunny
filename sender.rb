#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'
require 'yaml'
RACK_ENV ||= :development

conn = Bunny.new(YAML.load_file('config/rabbitmq.yml')[RACK_ENV.to_sym])
conn.start

ch = conn.create_channel
x = ch.fanout('logs')

msg = ARGV.empty? ? 'Hello world!' : ARGV.join(' ')

x.publish(msg)
puts " [x] Sent '#{msg}'"

conn.close
