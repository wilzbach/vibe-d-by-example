SHELL:=/bin/bash
SOURCES=$(addsuffix .d, \
	config content_type cors errors hello routes static_files \
	$(addprefix web/, before_check error_display session) \
)
SOURCES_BUILD_ONLY=$(addsuffix .d, \
	html5 logging logging_custom middleware_logger use_auth \
	$(addprefix web/, methods routes service) \
)
# TODO:
#error_display web
# remove -de until vibe.d 0.8.5 has been released
#DFLAGS:=-de
export DFLAGS

# Override if needed
OPENSSL_VERSION=$(shell openssl version | cut -f2 -d" ")
ifneq (, $(shell echo $(OPENSSL_VERSION) | grep "1.1"))
OPENSSL=--override-config vibe-d:tls/openssl-1.1
endif
# Avoid registry check for increased speed
DUB_BUILD_FLAGS=--skip-registry=all --parallel $(OPENSSL)

all: test

bin/%.server: %.d
	dub build --single $(DUB_BUILD_FLAGS) --root=$(dir $<) $(notdir $<)
	@mkdir -p $(dir $@)
	@mv $(basename $<) $@

bin/%.client: %.d
	dub build --single -b unittest $(DUB_BUILD_FLAGS) --root=$(dir $<) $(notdir $<)
	@mkdir -p $(dir $@)
	@mv $(basename $<) $@

bin/%.test: bin/%.server bin/%.client
	@echo "Running test: $(notdir $(basename $<))"
	@($<) & pid=$$!; \
	function finish() { kill -9 $$pid; }  ; \
	trap finish EXIT; \
	sleep 0.001 && $(basename $<).client
	@echo "OK" > $@

SOURCES_TEST=$(addsuffix .test, $(addprefix bin/, $(basename $(SOURCES))))
SOURCES_BUILD_ONLY_BIN=$(addsuffix .server, $(addprefix bin/, $(basename $(SOURCES_BUILD_ONLY))))

build: $(SOURCES_BUILD_ONLY_BIN)
test: $(SOURCES_TEST) build

clean:
	rm -rf bin

.PRECIOUS: bin/%.client bin/%.server
