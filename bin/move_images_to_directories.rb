#!/usr/bin/env ruby
require 'trollop'
require 'panasonic_serial_image_processor'

module PanasonicSerialImageProcessor
	class ImageMover
		attr_reader :source, :destination, :dry_run
		def initialize(source, destination, dry_run=true)
			raise ArgumentError, "#{source} doesn't exist" unless File.exists?(source)
			raise ArgumentError, "#{destination} doesn't exist" unless File.exists?(destination)
			@source = source
			@destination = destination
			@dry_run = dry_run
		end

		def self.parse_options
			opts = Trollop::options do
				opt :source, "Where Images are located", :default => '~camera/serial-images/'
				opt :destination, "Desination Directory", :default => '~camera/days/'
				opt :test, "Dry-run", :default => true
			end
			opts
		end

		def create_directory(timestamp)
			directory_name = timestamp.to_date.to_s
			date_directory = File.join(destination, directory_name)
			puts "mkdir #{date_directory}" unless (dry_run || File.exists?(date_directory) )
			Dir.mkdir(date_directory) unless File.exists?(date_directory) || dry_run
			date_directory
		end

		def move_image(original_name)
			source_name = File.join(source, original_name)
			timestamp = Utility::parse_timestamp_from_filename(original_name)
			date_directory = create_directory(timestamp)
			new_filename = Utility::create_filename_from_timestamp(timestamp)
			#raise ArgumentError, "#{original_name} and #{new_filename} must match" unless original_name == new_filename
			destination_name = File.join(date_directory, new_filename)
			puts "mv #{source_name} #{destination_name}"
			File.rename(source_name, destination_name) unless dry_run
		end

		def move_images
			images = Dir.entries(source)
			images = images.sort
			images.each do |image|
				unless File.directory?(File.join(source, image))
					move_image(image)
				end
			end
		end
	end
end

options = PanasonicSerialImageProcessor::ImageMover.parse_options
image_mover = PanasonicSerialImageProcessor::ImageMover.new(options[:source], options[:destination], options[:test])
image_mover.move_images


