# Dynu DDNS Updater (Docker) 🌐🐋

This repository provides a **docker compose** service that provides periodic update requests for the DDNS records of your [www.dynu.com](https://www.dynu.com/) account.

The service is designed to be lightweight, convenient and straightforward.
In particular, the docker image is based on alpine linux with no additional packages installed (with a size of 7.05 MB),
it is easily configurable through just a single dotenv file, and provides meaningful logs and argument validation.

## Usage

In order to use this service, move inside the directory in which you want to store the `docker-compose.yml` file and download the necessary files.

Download with `wget`:

> $ wget https://raw.githubusercontent.com/iamryusei/dynu-ddns-updater/master/docker-compose.yml \
> $ wget https://raw.githubusercontent.com/iamryusei/dynu-ddns-updater/master/properties.env

Download with `curl`:

> $ curl https://raw.githubusercontent.com/iamryusei/dynu-ddns-updater/master/docker-compose.yml -o docker-compose.yml \
> $ curl https://raw.githubusercontent.com/iamryusei/dynu-ddns-updater/master/properties.env -o properties.env

Now edit the `properties.env` file (which is already provided with generic default values)
using your favourite text editor, and replace the necessary properties with the desired values.
You can find more information about this in the [configuration](#configuration) paragraph.

Finally, issue the following command to start the service:

> $ docker compose up -d

Since the service is configured with the restart policy `unless-stopped`, the service will be automatically started after each system reboot.

You may inspect the logs with the following command:

> $ docker compose logs -f

And finally, stop the service with the following command:

> $ docker compose down

## Configuration

The docker image is configured during the startup of the container through various environment variables,
which may be conveniently found in the `properties.env` file.

For more details about `DYNU_*` variables, and how to use them in order to determine which DDNS records to update, please refer to dynu's [official documentation](https://www.dynu.com/en-US/DynamicDNS/IP-Update-Protocol) about the IP update protocol.

| Property                  | Required | Default | Description                                                                                           |
|---------------------------|----------|---------|-------------------------------------------------------------------------------------------------------|
| CROND_INTERVAL_MINUTES    | no       | `10`    | Interval between each DDNS IP update request in minutes. Valid values are from `1` to `999`.          |
| CROND_LOG_LEVEL           | no       | `8`     | Verbosity level for crond logs. A lower value means more verbosity. Valid values are from `0` to `8`. |
|                           |          |         |                                                                                                       |
| DYNU_DDNS_GROUP           | no       |         | The `group` parameter for the DDNS IP update request.                                                 |
| DYNU_DDNS_HOSTNAME        | no       |         | The `hostname` parameter for the DDNS IP update request.                                              |
| DYNU_DDNS_ALIAS           | no       |         | The `alias` parameter for the DDNS IP update request. When specified, `DYNU_DDNS_HOSTNAME` becomes a madnatory property. |
| DYNU_DDNS_IPV4            | no       |         | The `myip` parameter for the DDNS IP update request. If not specified, the public IP address of the client will be used. Use `no` to explicitly disablle IPv4 updates. |
| DYNU_DDNS_IPV6            | no       |         | The `myipv6` parameter for the DDNS IP update request. If not specified, the public IP address of the client will be used (if available). Use `no` to explicitly disablle IPv6 updates. |
| DYNU_AUTH_USERNAME        | no       |         | The `username` parameter for the DDNS IP update request. |
| DYNU_AUTH_PASSWORD_SHA256 | yes      |         | The `password` parameter for the DDNS IP update request. **Do not** use the password of your administrative account. Instead, read dynu's [official page](https://www.dynu.com/en-US/DynamicDNS/IP-Update-Protocol) on how to create a dedicated password for DDNS IP update requests only. |
