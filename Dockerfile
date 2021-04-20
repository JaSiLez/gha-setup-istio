FROM alpine:3.10

ENV HELM3_VERSION 3.1.2
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${HELM3_VERSION}-linux-amd64.tar.gz"

RUN apk --update --no-cache add curl ca-certificates
RUN cd /bin && curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && chmod 755 kubectl

# Install Helm3
RUN curl -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64

COPY values_charts/* /values_charts/
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
