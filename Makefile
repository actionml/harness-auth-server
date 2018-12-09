.DEFAULT_GOAL := build
.PHONY: sbt clean clean-dist build dist

HARNESS_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SBT_SYSTEM_SCALA ?= no
SBT_URL ?= https://git.io/sbt
SBT ?= $(HARNESS_ROOT)/sbt/sbt
SBT_OPTS ?=

JAVA_PROPS ?=
VERSION := $(shell grep ^version build.sbt | grep -o '".*"' | sed 's/"//g')
DIST := dist/

# Use system-wide installed Scala version, add ++${version} into SBT_OPTS
ifneq (,$(filter yes y true enabled,$(SBT_SYSTEM_SCALA)))
SBT_OPTS += $(shell which scala &>/dev/null && scala -e 'println("++" + util.Properties.versionNumberString)')
endif

# By default install sbtx locally if no SBT path provided
sbt:
ifeq ($(SBT),$(HARNESS_ROOT)/sbt/sbt)
	@ SBT_DIR="$$(dirname $(SBT))" && mkdir -p $$SBT_DIR && cd $$SBT_DIR && \
	[ -x sbt ] || ( echo "Installing sbt extras locally (from $(SBT_URL))"; \
		which curl &> /dev/null && ( curl \-#SL -o sbt \
			https://git.io/sbt && chmod 0755 sbt || exit 1; ) || \
			( which wget &>/dev/null && wget -O sbt https://git.io/sbt && chmod 0755 sbt; ) \
	)
endif


build: sbt
	$(SBT) $(SBT_OPTS) $(JAVA_PROPS) -batch authServer/universal:stage

clean: sbt
	$(SBT) $(SBT_OPTS) $(JAVA_PROPS) -batch authServer/clean

dist: clean clean-dist build
	mkdir -p $(DIST) && cd $(DIST) && rm -rf ./* && mkdir bin conf logs lib project
	cp auth-server/bin/* $(DIST)/bin/
	cp auth-server/src/main/resources/*.conf $(DIST)/conf/
	cp auth-server/src/main/resources/*.xml $(DIST)/conf/
	cp auth-server/project/build.properties $(DIST)/project/
	cp auth-server/target/universal/stage/lib/* $(DIST)/lib/
	cp auth-server/target/universal/stage/bin/authserver $(DIST)/bin/main
	echo $(VERSION) > $(DIST)/RELEASE

clean-dist:
	rm -rf $(DIST)
