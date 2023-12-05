SHELL := /bin/bash

ACTIONLINT_VERSION := 1.6.25
ACTIONLINT := bin/actionlint_v$(ACTIONLINT_VERSION)/actionlint
ACTIONLINT_URL :=  https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash

TEST_VAR ?= test-var-from-make-file
TEST_VAR1 ?= test-var1-from-make-file
TEST_VAR2 ?= test-var2-from-make-file

test-step:
	@echo ${TEST_VAR}

test-step1:
	@echo ${TEST_VAR1}

test-step-all:
	@echo ${TEST_VAR}
	@echo ${TEST_VAR1}
	@echo ${TEST_VAR2}

## gha-lint: Lint the github actions code
gha-lint: ${ACTIONLINT}
	@echo "🚀 Linting github actions code"
	@$(ACTIONLINT)

## gha-linter-info: Returns information about the current github actions linter being used
gha-linter-info:
	@echo ${ACTIONLINT}


${ACTIONLINT}:
	$(call _check_shellcheck_installation)
	@echo "📦 Installing actionlint v${ACTIONLINT_VERSION}"
	@mkdir -p $(dir ${ACTIONLINT})
	@bash <(curl -sSL https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash) ${ACTIONLINT_VERSION} $(shell dirname ${ACTIONLINT})  > /dev/null 2>&1
