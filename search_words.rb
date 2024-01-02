require 'pathname'

def count_files_with_same_content(folder_path)
  content_counts = Hash.new(0)
  Pathname.glob("#{folder_path}/**/*").each do |file_path| # search all files within the directory
    next unless file_path.file? # skip if its not a files

    content = File.binread(file_path) # read the content
    content_counts[content] += 1 # Increments the count of files with the same content in the content_counts hash.
  end

  most_common_content, count = content_counts.max_by { |_, v| v } # Finds the most common content and its count using max_by on the content_counts hash
  [most_common_content, count] # return the array
end

folder_path = ARGV[0] || '/default/path/to/folder'
content, count = count_files_with_same_content(folder_path)

puts "#{content} : #{count}"
