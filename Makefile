SHELL := /bin/bash

TEST_VAR ?= test-var-from-make-file
TEST_VAR1 ?= test-var1-from-make-file

test-step:
	@echo ${TEST_VAR}
	@echo ${TEST_VAR1}
