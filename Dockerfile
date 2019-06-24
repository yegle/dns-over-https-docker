FROM golang:stretch as build_env
ARG SOURCE_BRANCH
ENV SOURCE_BRANCH=${SOURCE_BRANCH:-v2.0.1}

RUN git clone https://github.com/m13253/dns-over-https

WORKDIR /go/dns-over-https/doh-server
RUN git checkout ${SOURCE_BRANCH}
RUN go build .
RUN strip -s doh-server

FROM gcr.io/distroless/base

COPY --from=build_env /go/dns-over-https/doh-server/doh-server /bin/doh-server

WORKDIR /

ENTRYPOINT ["/bin/doh-server"]
