SHELL := /bin/bash

conventional-pr-title-lint:
	@echo "🚀 Checking PR Title"
	@source "scripts/conventional-commits/message.sh ${{ github.event.pull_request.title }}"