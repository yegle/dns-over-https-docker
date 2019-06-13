ARG VERSION=2.0.1

FROM golang:stretch as build_env
ARG VERSION

RUN curl -O -J -L https://github.com/m13253/dns-over-https/archive/v${VERSION}.tar.gz
RUN tar xvf dns-over-https-${VERSION}.tar.gz

WORKDIR /go/dns-over-https-${VERSION}/doh-server
RUN go build .

FROM gcr.io/distroless/base
ARG VERSION

COPY --from=build_env /go/dns-over-https-${VERSION}/doh-server/doh-server /bin/doh-server

WORKDIR /

ENTRYPOINT ["/bin/doh-server"]
