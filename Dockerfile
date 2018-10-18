FROM alpine
RUN apk add --no-cache stunnel
ENTRYPOINT [ "/usr/bin/stunnel" ]
