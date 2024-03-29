Cloudflare DNS Record Manager
---

This Ruby application automates the management of DNS records on Cloudflare. It reads DNS record configurations from a YAML file and updates the records on Cloudflare using the Cloudflare API.

## Description

The application is designed to be simple and easy to use. It allows you to define your DNS record configurations in a YAML file and then updates those records on Cloudflare accordingly. This can be particularly useful for batch updates or automating DNS record management.

## Requirements

- Ruby environment (Ruby 2.5 or later is recommended)
- `cloudflare` gem for interacting with the Cloudflare API
- Cloudflare account with an API token
- YAML file with DNS record configurations

## Setup

1. Clone the repository to your local machine.
2. Install the required Ruby gem by running `bundle install`.
3. Create a `.env` file in the root directory with your Cloudflare credentials:

   ```
   CLOUDFLARE_ZONE_IDENTIFIER=your_zone_identifier
   CLOUDFLARE_API_TOKEN=your_api_token
   ```

4. Define your DNS records in a `dns_records.yml` file placed in the root directory.

## Usage

To run the application locally, execute:

```bash
ruby cloudflare-sync/update_dns.rb
```

To run the application using Docker, first build the image:

```bash
docker build -t cloudflare-sync .
```

Then, run the container:

```bash
docker run -v $(pwd)/dns_records.yml:/app/dns_records.yml --env-file .env cloudflare-dns-manager
```

Alternatively, you can use Docker Compose:

```bash
docker-compose up --build
```

## Contributing

Contributions to this project are welcome. Please ensure that any pull requests are well-documented and include relevant updates to the README if necessary.
