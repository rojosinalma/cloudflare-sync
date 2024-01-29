require 'cloudflare'
require 'yaml'

config = YAML.load_file(File.join(__dir__, '../dns_records.yml'))

zone_identifier = ENV['CLOUDFLARE_ZONE_IDENTIFIER']
api_token = ENV['CLOUDFLARE_API_TOKEN']

cf   = Cloudflare.connect(token: api_token)
zone = cf.zones.find_by_id(zone_identifier)

config['records'].each do |record|
  existing_record = zone.dns_records.find_by_name(record['name'])
  if existing_record
    # Update the existing record
    existing_record.content = record['content']
    existing_record.ttl = record['ttl']
    existing_record.proxied = record['proxied']
    existing_record.save
  else
    # Create a new record
    zone.dns_records.post(record['type'], record['name'], record['content'], ttl: record['ttl'], proxied: record['proxied'])
  end
end

puts "DNS records have been updated successfully."
