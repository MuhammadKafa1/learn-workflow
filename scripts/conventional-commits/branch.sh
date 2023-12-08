#!/bin/bash
#
# Validates commits, on the current branch, using the
# text-validator.sh script.
#

# Get the path of the script so that the subscript can be invoked regardless
# of where this script is called from.
SCRIPT_PATH=$(dirname "${BASH_SOURCE[0]}")

# Get the name of the current branch. We're only interested in commits that's
# been added on that specific branch.
BRANCH_NAME=$(git branch --show-current)

# Get the commit SHAs for the commits on the branch, excluding any merge commits
# that might exist.
if [[ -n "$CI" ]]; then
    COMMITS=$(git log --no-merges --format="%H")
else
    COMMITS=$(git log main.."$BRANCH_NAME" --no-merges --format="%H")
fi

# Return success unless any of the commit messages are invalid.
EXIT_CODE=0

# Validate all commit messages against the expected format.
for COMMIT in $COMMITS; do
    # Get the commit message of the current commit.
    MESSAGE=$(git log -1 "${COMMIT}" --pretty=format:"%s")

    # Call the text validation script that validates a text against the conventional commit specification.
    OUTPUT=$(source "$SCRIPT_PATH"/text-validator.sh "$MESSAGE")
    STATUS=$?

    # Display error if the message was not valid.
    if [ $STATUS -ne 0 ]; then
        echo -e "$OUTPUT\n"

        EXIT_CODE=$STATUS
    fi
done

exit "$EXIT_CODE"
