FROM golang:1.19 as builder

WORKDIR /app

#Decidi copiar todos os arquivos no começo, ao invés de copiar go mod, go sum e os outros em 
#seguida.
COPY go.* ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /go-mongo-crud-rest-api

FROM alpine:latest

RUN apk --no-cache add ca-certificates

COPY --from=builder /go-mongo-crud-rest-api /go-mongo-crud-rest-api

EXPOSE 9080

CMD ["/go-mongo-crud-rest-api"]