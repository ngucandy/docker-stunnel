FROM alpine as builder
RUN apk add --no-cache gcc musl-dev openssl-dev make
ARG VERSION=5.56
RUN wget -O - ftp://ftp.stunnel.org/stunnel/archive/5.x/stunnel-${VERSION}.tar.gz | tar xzf - \
 && cd /stunnel-${VERSION} \
 && ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
 && make \
 && make install DESTDIR=/stunnel-bin

FROM alpine
RUN apk update && \
    apk add --no-cache bash openssl ca-certificates
    
COPY --from=builder /stunnel-bin/etc/stunnel /etc/stunnel
COPY --from=builder /stunnel-bin/usr/bin/stunnel /usr/bin/stunnel
COPY --from=builder /stunnel-bin/usr/lib/stunnel /usr/lib/stunnel
ENTRYPOINT [ "/usr/bin/stunnel" ]
