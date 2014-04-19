#!/usr/bin/env ruby
require 'trollop'
require 'date'
require 'time'
require 'find'
require 'fileutils'
require 'pry-nav'
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
		def get_noon_file(directory)
			date = DateTime.parse(directory)
			solar_noon = Utility::calculate_solar_noon(date)
			file_regexp = Utility.create_matcher_from_timestamp(solar_noon)

			Find.find(File.join(source, directory)) do |path|
				return path if path =~ file_regexp
			end
			rescue ArgumentError
				puts "not a Date: #{directory}"
		end

		def copy_image(original_path)
			puts "cp #{original_path} #{destination}"
			FileUtils.cp(original_path, destination) unless dry_run
		end

		def copy_images
			directories = Dir.entries(source)
			directories = directories.sort
			directories.each do |directory|
				noon_file = get_noon_file(directory)
				copy_image(noon_file) if noon_file
			end
		end
	end
end

options = PanasonicSerialImageProcessor::ImageMover.parse_options
image_mover = PanasonicSerialImageProcessor::ImageMover.new(options[:source], options[:destination], options[:test])
image_mover.copy_images