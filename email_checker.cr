require "socket"
require "option_parser"

server = "example.com"
account = "mailvalid"
email = ""
domain = ""
mx_server = ""
mx_port = 25

OptionParser.parse do |parser|
  parser.banner = "Email address checking tool."

  parser.on "-v", "--version", "Show version" do
    puts "version 0.1"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.on "-s SENDER", "--sender=SENDER", "Sender email for checking. Default is <mailvalid@example.com>" do |sender|
    server = get_domain(sender)
    account = get_account(email)
  end

  parser.on "-e ADDR", "--email=ADDR", "Email address for check" do |addr|
    puts "Checking address: <#{email = addr}>"
    domain = get_domain(email)
    puts "MX is: #{mx_server = get_mx(domain)}"
    puts "Start checking."
    request_mx(email, mx_server, mx_port, server, account)
    puts "Done."
    exit
  end
end

def request_mx(email, mx_server, mx_port, server, account)
  result = false
  TCPSocket.open(mx_server, mx_port) do |client|
    client << "\n"
    puts response = client.gets
    break unless response.to_s.starts_with?("220")
    puts request = "HELO #{server}\n"
    client << request
    puts response = client.gets
    break unless response.to_s.starts_with?("250")
    puts request = "MAIL FROM: <#{account}@#{server}>\n"
    client << request
    puts response = client.gets
    break unless response.to_s.starts_with?("250")
    puts request = "RCPT TO: <#{email}>\n"
    client << request
    puts response = client.gets
    result = response.to_s.starts_with?("250")
    puts "Email <#{email}> is #{ result ? "" : "in" }valid."
  end
  result
end

def get_domain(email)
  email.split("@").last
end

def get_account(email)
  email.split("@").first
end

def get_mx(domain)
  resp = `dig mx #{domain} +short`
  resp.lines.first.split().last
end
