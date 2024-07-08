FROM --platform=linux/amd64 cr.yandex/crpsjg1coh47p81vh2lc/k8s-addons/cilium/cilium:v1.12.9 as build

RUN apt update && apt install -y make wget git
RUN wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

WORKDIR /src
COPY . .
WORKDIR /src/daemon
RUN make cilium-agent 

FROM --platform=linux/amd64 cr.yandex/crpsjg1coh47p81vh2lc/k8s-addons/cilium/cilium:v1.12.9 
COPY --from=build /src/daemon/cilium-agent /usr/bin/cilium-agent
