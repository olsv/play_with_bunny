#!/usr/bin/env ruby
#encoding: utf-8

require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
q  = ch.queue('hello_queue', durable: true)
ch.prefetch(1)

puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"
begin
  q.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"

    sleep body.count('.').to_i
    puts " [x] Done"
    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  conn.close
end
