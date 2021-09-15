FROM actionml/harness-sdk

WORKDIR /app

ADD . /tmp
ADD ./entrypoint.sh /app

# RUN cd /tmp && \
#     ./make dist && \
#     cp -a ./auth-server/target/universal/stage/* /app/ && \
#     cd /app && \
#     rm -R /tmp/*

RUN cd /tmp && \
    make dist && \
    cp -a ./auth-server/target/universal/stage/* /app/ && \
    cd /app && \
    rm -R /tmp/*

ENTRYPOINT ["/app/entrypoint.sh"]
