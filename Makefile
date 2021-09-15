.DEFAULT_GOAL := build
.PHONY: sbt clean clean-dist build dist publish-local

HARNESS_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SBT_URL ?= https://raw.githubusercontent.com/sbt/sbt/v1.5.5/sbt
SBT_DIR ?= $(HARNESS_ROOT)/sbt
SBT ?= $(SBT_DIR)/sbt
DIST ?= dist

VERSION := $(shell grep ^version build.sbt | grep -o '".*"' | sed 's/"//g')
# Enforce version of Scala set in build.sbt (specificly passed to sbt later!)
SCALA_VERSION := $(shell grep ^scalaVersion build.sbt | grep -o '".*"' | sed 's/"//g')

# Install sbtx locally
sbt:
ifeq ($(SBT),$(HARNESS_ROOT)/sbt/sbt)
	@ SBT_DIR="$$(dirname $(SBT))" && mkdir -p $$SBT_DIR && cd $$SBT_DIR && \
	[ -x sbt ] || ( echo "Installing sbt extras locally (from $(SBT_URL))"; \
		which curl &> /dev/null && ( curl \-#SL -o sbt \
			$(SBT_URL) && chmod 0755 sbt || exit 1; ) || \
			( which wget &>/dev/null && wget -O sbt $(SBT_URL) && chmod 0755 sbt; ) \
	)
endif


build: sbt
	$(SBT) authServer/universal:stage

publish-local: build
	$(SBT) harnessAuthCommon/publish-local

clean: sbt
	$(SBT) clean

dist: clean clean-dist build
	mkdir -p $(DIST) && cd $(DIST) && mkdir bin conf logs lib
	cp auth-server/bin/* $(DIST)/bin/
	cp auth-server/src/main/resources/*.conf $(DIST)/conf/
	cp auth-server/src/main/resources/*.xml $(DIST)/conf/
	cp auth-server/target/universal/stage/lib/* $(DIST)/lib/
	cp auth-server/target/universal/stage/bin/authserver $(DIST)/bin/main
	echo $(VERSION) > $(DIST)/RELEASE

clean-dist:
	rm -rf $(DIST)
