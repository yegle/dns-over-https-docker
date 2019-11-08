FROM golang:1.12.8-stretch as build_env
ARG SOURCE_BRANCH
ENV SOURCE_BRANCH=${SOURCE_BRANCH:-v2.1.2}

RUN git clone https://github.com/m13253/dns-over-https

WORKDIR /go/dns-over-https/doh-server
RUN git checkout -b temp ${SOURCE_BRANCH}
RUN CGO_ENABLED=0 go build .
RUN strip -s doh-server
#RUN setcap 'cap_net_bind_service=+ep' doh-server

# Unfortunately copying file from another container during multi-stage build
# won't preserve the extended attributes, thus I can't use the nonroot image,
# and there's no :latest image that I can use.
# Use :debug build for now.
FROM gcr.io/distroless/static-debian10:debug

COPY --from=build_env /go/dns-over-https/doh-server/doh-server /bin/doh-server

WORKDIR /

ENTRYPOINT ["/bin/doh-server"]
