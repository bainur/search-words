require 'pathname'

def validate_folder_path(folder_path)
  unless folder_path
    puts 'Error: Please provide a folder path. Example : /home/bainur/'
    exit(1)
  end

  folder_path = File.expand_path(folder_path)

  unless File.directory?(folder_path)
    puts 'Error: The specified path is not a valid directory.'
    exit(1)
  end

  folder_path
end

def count_files_with_same_content(folder_path) 
  folder_path = validate_folder_path(folder_path)  # Validate and expand the folder path
  content_counts = Hash.new { |hash, key| hash[key] = { count: 0, content: nil } } # Initialize a hash to store content counts along with content itself
  chunk_size = 4096 # Adjust as needed

  Pathname.glob("#{folder_path}/**/*").each do |file_path|# Iterate over all files in the specified directory and its subdirectories
    next unless file_path.file? # Skip if the current item is not a file

    content = ''
    File.open(file_path, 'rb') do |file|
      while chunk = file.read(chunk_size) # use chunk so it wont use memory too high for big filesize
        content << chunk
      end
    end
    content_counts[content][:count] += 1 # Increment the count of files with the same content in the hash
    content_counts[content][:content] ||= content
  end
  most_common_content = content_counts.max_by { |_, v| v[:count] } # Find the most common content and its count using max_by on the content_counts hash
  puts "#{most_common_content[1][:content]} : #{most_common_content[1][:count]}"
end

# Get the folder path from command line argument
folder_path = ARGV[0]

# Call the function with the specified folder path
count_files_with_same_content(folder_path)