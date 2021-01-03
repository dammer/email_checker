require "socket"
require "option_parser"

server = "example.com"
account = "mailvalid"
email = ""
domain = ""
mx_server = ""
mx_port = 25
quiet = false

class Logger
  def initialize(@quiet : Bool); end
  def log(line)
    puts line unless @quiet
  end
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

  parser.on "-q", "--quiet", "Show only test email and result, one line" do
    quiet = true
  end

  parser.on "-s SENDER", "--sender=SENDER", "Sender email for checking. Default is <mailvalid@example.com>" do |sender|
    server = get_domain(sender)
    account = get_account(email)
  end

  parser.on "-e ADDR", "--email=ADDR", "Email address for check" do |addr|
    email = addr
    domain = get_domain(email)
    mx_server = get_mx(domain)
  end
end

logger = Logger.new(quiet)
logger.log "Checking address: <#{email}>"
logger.log "MX is: #{mx_server}"
logger.log "Start checking."
result = false

TCPSocket.open(mx_server, mx_port) do |client|
  client << "\n"
  logger.log response = client.gets
  break unless response.to_s.starts_with?("220")
  logger.log request = "HELO #{server}\n"
  client << request
  logger.log response = client.gets
  break unless response.to_s.starts_with?("250")
  logger.log request = "MAIL FROM: <#{account}@#{server}>\n"
  client << request
  logger.log response = client.gets
  break unless response.to_s.starts_with?("250")
  logger.log request = "RCPT TO: <#{email}>\n"
  client << request
  logger.log response = client.gets
  result = response.to_s.starts_with?("250")
  puts "Email <#{email}> is #{ result ? "" : "in" }valid."
  result
end

logger.log "Done."
exit

