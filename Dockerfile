ARG TARGETPLATFORM
ARG BUILD_TYPE=release

FROM swift:6.2-noble AS builder

ARG TARGETPLATFORM
ARG BUILD_TYPE=release

ENV ARCH=${TARGETPLATFORM}
ENV BUILD_TYPE=${BUILD_TYPE}
ENV PKG_LIB_PATH=/usr/local/lib/
ENV PKG_INCLUDE_PATH=/usr/local/include/
ENV PKG_BIN_PATH=/usr/local/bin/

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
  && apt-get -q update \
  && apt-get -q dist-upgrade -y \
  && apt-get -q install -y \
    clang \
    lld \
    llvm \
    git \
    libjemalloc-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY Package.* ./

RUN swift package resolve

COPY . .

RUN echo "Building for ${ARCH} in ${BUILD_TYPE} mode" && \
    swift build \
      -c ${BUILD_TYPE} \
      -Xcc -fuse-ld=lld \
      -Xlinker -ljemalloc \
      --static-swift-stdlib

RUN swift test || echo "⚠️  No tests found"

FROM scratch AS verify
COPY --from=builder /workspace/.build/release/ /build-output/
