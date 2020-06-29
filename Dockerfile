FROM golang:alpine as builder
WORKDIR /app
RUN  /bin/sed -i 's,http://dl-cdn.alpinelinux.org,https://mirrors.aliyun.com,g' /etc/apk/repositories
RUN apk add --no-cache git
COPY . /app/
ENV  GO111MODULE=on
ENV  GOPROXY=https://goproxy.cn
RUN go build

FROM alpine
COPY --from=builder /app/sql2slack ./
RUN echo $PWD
ENTRYPOINT ["./sql2slack"]
