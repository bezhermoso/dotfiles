def make_gemfile
    Gem::Specification.map do |spec|
      "gem \"#{spec.name}\", :version => \"#{spec.version}\""
    end
    #Gem::Specification.to_enum(sym).map{|spec| 
    #"gem \"#{spec.name}\", :version => \"#{spec.version}\""
    #} 
end

print 'source "https://rubygems.org"'
make_gemfile().each do |l|
  print l + "\n"
end
