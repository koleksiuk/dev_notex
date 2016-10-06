FROM elixir:1.3.2

ENV DEBIAN_FRONTEND=noninteractive

RUN mix local.hex --force

RUN mix local.rebar --force

RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

ENV DB_USERNAME=postgres
ENV DB_PASSWORD=postgres
ENV DB_HOSTNAME=db

WORKDIR /app
ADD . /app
