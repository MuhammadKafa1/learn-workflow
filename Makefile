SHELL := /bin/bash

PULL_REQUEST_TITLE ?= pull request title

conventional-pr-title-lint:
	@echo "🚀 Checking PR Title"
	@source "scripts/conventional-commits/message.sh $(PULL_REQUEST_TITLE)"