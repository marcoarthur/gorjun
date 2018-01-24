APP=gorjun
CC=go
VERSION=$(shell git describe --abbrev=0 --tags | awk -F'.' '{print $$1"."$$2"."$$3+1}')
ifeq (${GIT_BRANCH}, )
	GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD | grep -iv head)
endif
ifneq (${GIT_BRANCH}, )
	VERSION:=${VERSION}-SNAPSHOT
endif
COMMIT=$(shell git rev-parse HEAD)

MAIN_LIBS=$(shell go list -f '{{ join .Imports "\n" }}'| grep -v subutai)
LIBS=$(shell for i in `go list -f '{{ join .Imports "\n" }}' | grep subutai` ; do go list -f '{{ join .Imports "\n" }}' $$i ; done | sort | uniq | grep -v subutai-io)
LDFLAGS=-ldflags "-w -s -X main.version=${VERSION}:${GIT_BRANCH}:${COMMIT}"

all:
	$(CC) get -u $(LIBS) $(MAIN_LIBS)
	$(CC) build ${LDFLAGS} -o $(APP)
