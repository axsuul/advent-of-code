require 'digest'

secret = "ckczppom"

(0..10000000).each do |decimal|
  md5 = Digest::MD5.hexdigest(secret + decimal.to_s)

  if md5[0..5] == "000000"
    puts "We found it: #{md5}"
    puts "Using #{decimal}"

    break
  end
end

