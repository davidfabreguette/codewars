class String
  
  # - @return [String]
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  # - @return [String]
  def pluralize
    "#{self}s" # simply adds an "s" at the end for now !
  end
end
