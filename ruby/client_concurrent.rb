require 'bundler/setup'
require 'typhoeus'
require 'json'

host = 'localhost'
log_path = '/home/revant/Documents/SISTER/RPC/NewRPC/var/log'

host = ARGV[0] unless ARGV[0].nil?
log_path = ARGV[1] unless ARGV[1].nil?

category_counter = {}
results = []

hydra = Typhoeus::Hydra.new max_concurrency: 2

Dir.glob "#{log_path}/secure*" do |file|
	log_content = File.read file
	request = Typhoeus::Request.new(
		"http://#{host}:8080/parse_log",
		method: :post,
		body: log_content,
		headers: {'Content-Type' =>'text/plain'}
	)
	request.on_complete do |response|
		if response.success?
			result = JSON.parse response.response_body
			results << result
		else
			puts "Request failed"
		end
	end

	hydra.queue request
end

hydra.run

results.each do |result|
	category_counter.merge!(result){|_key, old, new| old + new}
end

puts category_counter.sort_by{|_key, value| -value}
