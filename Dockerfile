FROM alpine as builder
RUN apk add --no-cache gcc musl-dev openssl-dev make
ARG VERSION=5.55
RUN wget -O - https://www.stunnel.org/downloads/stunnel-${VERSION}.tar.gz | tar xzf - \
 && cd /stunnel-${VERSION} \
 && ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
 && make \
 && make install DESTDIR=/stunnel-bin

FROM alpine
RUN apk add --no-cache openssl
COPY --from=builder /stunnel-bin/etc/stunnel /etc/stunnel
COPY --from=builder /stunnel-bin/usr/bin/stunnel /usr/bin/stunnel
COPY --from=builder /stunnel-bin/usr/lib/stunnel /usr/lib/stunnel
ENTRYPOINT [ "/usr/bin/stunnel" ]
