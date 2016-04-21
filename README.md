Gem in a Box
============
Dockerized Gem in a Box server secured using SSL and optional GitHub organization authentication.

When the environment variable `GITHUB_ORGANIZATION` is set, users need to login with their GitHub
username plus a [personal access token](https://github.com/settings/tokens).

Environment variables:

* `GITHUB_ORGANIZATION`: Only members of this organization will have access (optional).

* `REDIS_URL`: Redis server to cache GitHub authentication (required when organization is set).

* `SSL_CERTIFICATE`: SSL certificate path (use a volume to mount the certificate files).

* `SSL_INTERMEDIATE_CERTIFICATE_X`: Intermediate certificate path where X can be 1, 2 or 3 (optional).

* `SSL_PRIVATE_KEY`: SSL private key path.

* `SSL_PASSPHRASE`: Private key passphrase.

You can use the [docker-compose.yml](docker-compose.yml) file as a base.

Credits:

* Authentication based on [colstrom/docker-rubygems-server](https://github.com/colstrom/docker-rubygems-server).