FROM golang:1.9 as build
WORKDIR /go/src/github.com/jaegertracing/jaeger/examples/hotrod

COPY vendor                    vendor
COPY examples/hotrod/cmd       cmd
COPY examples/hotrod/pkg       pkg
COPY examples/hotrod/services  services
COPY examples/hotrod/main.go   .

# Run a gofmt and exclude all vendored code.
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o hotrod .

FROM alpine:3.6
WORKDIR /root/

EXPOSE 8080 8081 8082 8083

COPY --from=build /go/src/github.com/jaegertracing/jaeger/examples/hotrod/hotrod    .

COPY examples/hotrod/services/frontend/web_assets web_assets

CMD ["./hotrod", "all"]
