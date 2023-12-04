SHELL := /bin/bash

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