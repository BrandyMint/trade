File.foreach('./db/seeds/categories.txt') do |line|
  Category.find_or_create_by title: line.sub(/\s\(\d+\)/,'')
end
