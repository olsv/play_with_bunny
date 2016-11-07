#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'
require 'yaml'
RACK_ENV ||= :development

conn = Bunny.new(YAML.load_file('config/rabbitmq.yml')[RACK_ENV.to_sym])
conn.start

ch = conn.create_channel
x = ch.fanout('logs')
q = ch.queue('', exclusive: true)

q.bind(x)

puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"
begin
  q.subscribe(manual_ack: true, block: true) do |delivery_info, _props, body|
    puts " [x] Received #{body}"

    sleep body.count('.').to_i
    puts ' [x] Done'
    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  ch.close
  conn.close
end
