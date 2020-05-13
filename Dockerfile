FROM elixir:1.9.0-alpine AS build

ARG DATABASE_URL
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
ENV DATABASE_URL=${DATABASE_URL}

RUN apk update &&\
  apk add make && \
  apk add build-base


RUN mkdir /app
WORKDIR /app

COPY . .

RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get && \
  mix deps.compile

RUN mix compile
RUN MIX_ENV=prod mix release

FROM alpine:3.9 AS app
RUN apk add --update bash openssl

RUN mkdir /app
WORKDIR /app

RUN chown nobody:nobody /app
USER nobody:nobody

COPY --from=build /app/_build/prod/rel/green_payments /app

ENV HOME=/app

CMD /app/bin/green_payments eval "GreenPayments.Release.migrate()" ; /app/bin/green_payments start
