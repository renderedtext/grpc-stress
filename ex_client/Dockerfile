FROM renderedtext/elixir:1.5.0-v2


ENV TERM=xterm
ENV MIX_ENV=prod

COPY mix* ./
COPY config/ config/

USER root
RUN mix do local.hex --force, local.rebar --force, deps.get, compile; \
    chown dev.dev -R ../

COPY lib lib/
COPY test test/

RUN chown dev.dev -R lib test

USER dev
RUN mix compile

CMD elixir --sname ex_client -S mix run --no-halt

