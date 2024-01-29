require 'sinatra'
require 'yaml'
require 'json'
require 'logger'

logger = Logger.new(STDOUT)

post '/add-subdomain' do
  content_type :json

  main_domain = ENV['MAIN_DOMAIN']

  # Parse the incoming JSON payload
  begin
    payload   = JSON.parse(request.body.read)
    subdomain = payload['subdomain']
    logger.info("Received request to add subdomain: #{subdomain}")
  rescue JSON::ParserError
    logger.error('Invalid JSON payload')
    status 400
    return { error: 'Invalid JSON payload' }.to_json
  end

  # Validate the subdomain format
  unless subdomain && subdomain.match?(/\A[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\z/i)
    status 422
    return { error: 'Invalid subdomain format' }.to_json
  end

  # Load the existing DNS records from the YAML file
  dns_records_path = File.join(__dir__, '../dns_records.yml')
  dns_records      = YAML.load_file(dns_records_path)

  # Append the new subdomain to the DNS records
  dns_records['records'] << {
    'type'    => 'A',
    'name'    => "#{subdomain}.#{main_domain}",
    'content' => '123.123.123.123', # Replace with the desired IP address
    'ttl'     => 1800,
    'proxied' => true
  }

  # Save the updated DNS records back to the YAML file
  File.open(dns_records_path, 'w') { |file| file.write(dns_records.to_yaml) }

  # Call the script to update Cloudflare
  system("ruby cloudflare-sync/update_dns.rb")

  status 200
  logger.info("Subdomain added successfully: #{subdomain}.#{main_domain}")
  { message: 'Subdomain added and Cloudflare DNS records updated.' }.to_json
end
