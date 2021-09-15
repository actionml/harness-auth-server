FROM actionml/harness-sdk


ARG version
ARG GIT_HASH
ARG DATE_BUILD
ARG BRANCH
ENV BRANCH=${BRANCH}
ENV GIT_HASH=${GIT_HASH}
ENV DATE_BUILD=${DATE_BUILD}

WORKDIR /app

ADD . /tmp
ADD ./entrypoint.sh /app


RUN cd /tmp && \
    make dist && \
    cp -a ./auth-server/target/universal/stage/* /app/ && \
    cd /app && \
    rm -R /tmp/*

ENTRYPOINT ["/app/entrypoint.sh"]
