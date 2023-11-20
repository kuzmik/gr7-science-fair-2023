#!ruby
# frozen_string_literal: true

require 'chunky_png'
require 'csv'
require 'pry'

def average_rgb(image_path)
  image = ChunkyPNG::Image.from_file(image_path)

  total_r = total_g = total_b = pixel_count = 0

  image.height.times do |y|
    image.width.times do |x|
      pixel = image[x, y]

      # Ignore transparent pixels
      next if ChunkyPNG::Color.a(pixel).zero?

      total_r += ChunkyPNG::Color.r(pixel)
      total_g += ChunkyPNG::Color.g(pixel)
      total_b += ChunkyPNG::Color.b(pixel)

      pixel_count += 1
    end
  end

  # Calculate average RGB values
  average_r = total_r.to_f / pixel_count
  average_g = total_g.to_f / pixel_count
  average_b = total_b.to_f / pixel_count

  # Convert RGB to Hex
  hex = ChunkyPNG::Color.to_hex(ChunkyPNG::Color.rgb(average_r.round, average_g.round, average_b.round))[0..6]

  [hex, average_r.round, average_g.round, average_b.round]
end

def process_images_in_directory(directory_path)
  results = []

  Dir.glob(File.join(directory_path, '*.png')).sort.each do |image_path|
    hex, r, g, b = average_rgb(image_path)
    results << { name: File.basename(image_path, '.*'), hex: hex, red: r, green: g, blue: b }
  end

  results
end

def load_or_process_results(results_path)
  serialized_file = 'serialized_data.dat'

  if File.exist?(serialized_file)
    write_csv deserialize_data(serialized_file)
  else
    csv_data = process_results(results_path)
    serialize_data(csv_data, serialized_file)
    csv_data
  end
end

def process_results(results_path)
  csv_data = []

  Dir.glob(File.join(results_path, '*')).sort.each do |subdirectory|
    day, trial = File.basename(subdirectory).split('-')

    images_data = process_images_in_directory(subdirectory)
    row_data = [trial, day]
    images_data.each do |image_info|
      row_data << image_info.reject { |x| x == :name }
    end

    csv_data << row_data
  end

  csv_data.sort!

  write_csv(csv_data)

  csv_data
end

def write_csv(csv_data)
  CSV.open('output.csv', 'w') do |csv|
    header = ['Trial', 'Day', 'RGB', 'Control', 'Distilled Water', 'Salt', 'Aspirin', '7 Up', 'Bleach', 'Vinegar',
              'Sugar', 'Plant Food']

    csv << header
    csv_data.each do |row_data|
      row = [row_data[0], row_data[1]]
      vals = row_data[2..]

      row2 = (row.dup << ['HEX'] << vals.map { |x| x[:hex] }).flatten
      csv << row2

      row3 = (row.dup << ['Red'] << vals.map { |x| x[:red] }).flatten
      csv << row3

      row4 = (row.dup << ['Green'] << vals.map { |x| x[:green] }).flatten
      csv << row4

      row5 = (row.dup << ['Blue'] << vals.map { |x| x[:blue] }).flatten
      csv << row5
    end
  end
end

# YEAH I KNOW, WHATEVER MAN. THIS IS QUICK AND DIRTY
def serialize_data(data, filename)
  File.open(filename, 'wb') do |file|
    Marshal.dump(data, file)
  end
end

# YEAH I KNOW, WHATEVER MAN. THIS IS QUICK AND DIRTY
def deserialize_data(filename)
  File.open(filename, 'rb') do |file|
    Marshal.load(file)
  end
end

load_or_process_results('results')
