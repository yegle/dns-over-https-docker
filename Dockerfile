FROM golang:stretch as build_env

RUN git clone https://github.com/m13253/dns-over-https

WORKDIR /go/dns-over-https/doh-server
RUN go build .

FROM gcr.io/distroless/base

COPY --from=build_env /go/dns-over-https/doh-server/doh-server /bin/doh-server

ENTRYPOINT ["/bin/doh-server"]
