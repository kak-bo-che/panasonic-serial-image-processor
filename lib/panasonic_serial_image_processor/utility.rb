require 'date'
require 'time'
require 'solar_noon'
module PanasonicSerialImageProcessor
	class Utility
		SECONDS_IN_DAY = 60*60*24
		MILLISECOND = 1000

		def self.parse_timestamp_from_filename(name)
			if /image(\d+)s(\d+).jpg/ =~ name
				date =  /image(\d+s\d+).jpg/.match(name)[1]
				DateTime.strptime(date, '%Y%m%ds%H%M%S%L')
			elsif /image(\d{8})(\d{9}).jpg/ =~ name
				date = /image(\d{8}\d{9}).jpg/.match(name)[1]
				DateTime.strptime(date, '%Y%m%d%H%M%S%L')
			else
				raise ArgumentError, "#{name} is invalid"
			end
		end

		def self.create_filename_from_timestamp(timestamp)
			'image' + timestamp.strftime('%Y%m%ds%H%M%S%L') + '.jpg'
		end

		def self.calculate_solar_noon(date)
			date.solar_noon(-106.6).to_time.getlocal
		end

		def self.create_matcher_from_timestamp(date)
			date_s = date.strftime('%Y%m%ds%H%M')
			last_minute = date_s[-1].to_i
			previous_minute = (last_minute + 8) % 9
			next_minute = (last_minute + 1) % 9
			variable_minutes = '[' + previous_minute.to_s + last_minute.to_s + next_minute.to_s + ']'
			Regexp.new('image' + date_s[0...-1] + variable_minutes + '\d{5}\.jpg')
		end
	end
end