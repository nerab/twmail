class String
  # http://www.java2s.com/Code/Ruby/String/WordwrappingLinesofText.htm
  def wrap(width = 78)
    gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
  end
end
