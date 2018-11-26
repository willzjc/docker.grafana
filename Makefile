SHELL           := /bin/bash
DOCKER_REPO     := topsoil/grafanazbi
DOCKER_IID_FILE := .id
GH_PAGES_SRC    := _site
DOCKER_FILE_DIR := grafanazbi

lint: PRECOMMIT_IMAGE=docker.artifactory.ai.cba/zbi/pre-commit:0.13.6-20170502234256-aed9f27
lint:
	docker run --rm \
		-v $(PWD):$(PWD) \
		-w $(PWD) \
		$(PRECOMMIT_IMAGE) run --all-files


build: ci $(DOCKER_IID_FILE)
$(DOCKER_IID_FILE): $(shell git ls-files $(DOCKER_FILE_DIR))
	docker build $(DOCKER_BUILD_ARGS) \
		--iidfile=$@ \
		$(DOCKER_FILE_DIR)

gh-pages: $(GH_PAGES_SRC)/_data/release.json
$(GH_PAGES_SRC)/_data:
	@mkdir -p $@
$(GH_PAGES_SRC)/_data/release.json: release.json | $(GH_PAGES_SRC)/_data
	cp $< $@

clean::
	-rm -f $(GH_PAGES_SRC)/_data/release.json
	-rm ci.mk.tar.gz
	-rm -r ci

ci: CI_MK_URL ?= https://artifactory.ai.cba/artifactory/binaries-internal/ci.mk/0.7.0-20171018041349-d6cd615/ci.mk.tar.gz
ci:
	curl -fsSL -o ci.mk.tar.gz $(CI_MK_URL)
	tar -xzf ci.mk.tar.gz

-include ci/release.mk
-include ci/gh-pages.mk
-include ci/self-upgrade.mk

.PHONY: lint build clean
