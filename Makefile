SHELL := /bin/bash

TEST_VAR ?= test-var-from-make-file

test-step:
	@echo ${TEST_VAR}