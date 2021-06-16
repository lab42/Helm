FROM golang:alpine as build

ARG version

RUN apk add --no-cache gcc musl-dev curl tar upx git ca-certificates
RUN git clone https://github.com/helm/helm.git

WORKDIR /go/helm/cmd/helm
RUN git checkout tags/${version} -b ${version}
RUN go get

WORKDIR /go/helm
RUN go build -a -ldflags '-linkmode external -extldflags "-static" -w' -o /bin/helm ./cmd/helm
RUN upx -9 -q /bin/helm

# Kubectl
WORKDIR /bin
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    upx -9 -q kubectl


FROM busybox as helm
LABEL org.opencontainers.image.source https://github.com/lab42/Helm

COPY --from=build /etc/ssl/certs /etc/ssl/certs
COPY --from=build /bin/helm /bin/
COPY --from=build /bin/kubectl /bin/
COPY entrypoint /entrypoint
RUN chmod +x /entrypoint
ENTRYPOINT [ "/entrypoint" ]
