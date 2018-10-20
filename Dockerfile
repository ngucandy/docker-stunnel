FROM alpine as builder
RUN apk add --no-cache gcc musl-dev openssl-dev make
ARG VERSION=5.49
RUN wget -O - https://www.stunnel.org/downloads/stunnel-${VERSION}.tar.gz | tar xzf - \
 && mv /stunnel-${VERSION} /stunnel \
 && cd /stunnel \
 && ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
 && make

FROM alpine
RUN apk add --no-cache openssl
COPY --from=builder /stunnel/src/stunnel /usr/bin/stunnel
ENTRYPOINT [ "/usr/bin/stunnel" ]
