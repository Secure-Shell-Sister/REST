require 'bundler/setup'
require 'sinatra'
require 'json'

configure do
	set :logging, true
	set :server, :puma
	set :port, 8080
	set :bind, '0.0.0.0'
	log_path = '/home/revant/Documents/SISTER/RPC/NewRPC/var/log'
	log_path = ARGV[0] unless ARGV[0].nil?
	file_list = []

	Dir.glob "#{log_path}/secure*" do |file|
		file_list << file
	end

	set :log_file_list, file_list
end
$mathcer = Regexp.compile /\[\d+\]: (.+?) (for|from)/


post '/parse_log' do
	log = request.body
	result = parse_log(log)
	#puts result

	content_type :json
	result
end

get '/log/:number' do |log_number|
	file_list = settings.log_file_list
	parse_log File.read(file_list[log_number])
end

def parse_log(log)
	begin
		result = Hash.new
		result['Unidentified'] = 0
		log.each_line do |line|
			match = $mathcer.match line
			key_string = nil
			if match.nil?
				key_string = 'Unidentified'
			elsif match[2] == 'for'
				key_string = match[1]
			else
				space = match[1].rindex ' '
				if space.nil?
					key_string = match[1]
				else
					key_string = match[1][0..(space - 1)]
				end
			end

			if result.include? key_string
				result[key_string] += 1
			else
				result[key_string] = 1
			end
		end
	rescue => e
		#puts e.message
		#puts $!
		puts e.backtrace.join("\n\t")
	end

	return result.to_json
end
