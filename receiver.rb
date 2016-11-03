#!/usr/bin/env ruby
#encoding: utf-8

require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
x = ch.fanout("logs")
q  = ch.queue('', exclusive: true)

q.bind(x)

puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"
begin
  q.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"

    sleep body.count('.').to_i
    puts " [x] Done"
    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  ch.close
  conn.close
end
