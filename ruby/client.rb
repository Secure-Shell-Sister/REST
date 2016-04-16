require 'bundler/setup'
require 'net/http'
require 'json'

host = '127.0.0.1'
log_path = '/home/revant/Documents/SISTER/RPC/NewRPC/var/log'

host = ARGV[0] unless ARGV[0].nil?
log_path = ARGV[1] unless ARGV[1].nil?

category_counter = {}

http = Net::HTTP.new host, 8080
failed_counter = 0
failed_files = []

Dir.glob "#{log_path}/secure*" do |file|
	begin
		log_content = File.read file
		req = Net::HTTP::Post.new('/parse_log', initheader = {'Content-Type' =>'text/plain'})
		req.body = log_content
		result = http.request req
		result = JSON.parse result.body
		category_counter.merge!(result) {|_key, old, new| old + new}
	rescue => e
		f = File.open 'hasil.html', 'w'
		f.write result.body
		f.close

		failed_counter += 1
		failed_files << file
	end
end

puts category_counter.sort_by{|_key, value| -value}

puts "Failed: #{failed_counter}"
puts failed_files
