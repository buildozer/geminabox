# Simple Gem in a Box server configured to authenticate 
# against a GitHub organization

FROM ruby:2.2-onbuild
MAINTAINER Peter Verhage <peter@egeniq.com>

RUN mkdir /usr/src/app/data

COPY config/ /usr/src/app/
COPY lib/ /usr/src/app/lib/

EXPOSE 443/tcp
VOLUME ["/usr/src/app/data"]
ENTRYPOINT ["bundle", "exec", "rackup"]
CMD ["config.ru"]
