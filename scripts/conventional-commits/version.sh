#!/bin/bash
#
# Examines the commits that have been added, since the latest tag, and
# calculates what the next semantic version should be based on the
# conventional commits.
#

# Define the valid message format regex.
VALID_MESSAGE_FORMAT="^([a-z]+)(\([a-z]+\))?(!)?: .*$"

# Define the valid tag format regex.
VALID_TAG_FORMAT="^v([0-9]+)\.([0-9]+)\.([0-9]+)$"


# Extract information about the latest existing tag.
LATEST_TAG=$(git describe --tags --always --abbrev=0)
echo "latest tag is $LATEST_TAG"
if ! [[ $LATEST_TAG =~ $VALID_TAG_FORMAT ]]; then
    echo "Latest tag is not valid"
    exit 1
fi
echo "Latest tag is valid"
TAG_MAJOR=${BASH_REMATCH[1]}
TAG_MINOR=${BASH_REMATCH[2]}
TAG_PATCH=${BASH_REMATCH[3]}

echo "tag major is $TAG_MAJOR"
echo "tag minor is $TAG_MINOR"
echo "tag patch is $TAG_PATCH"

# Get the commit SHAs for the commits that has been added since the last tag
# was created.
COMMITS=$(git log "$LATEST_TAG"..HEAD --no-merges --pretty=format:"%H")
echo "commit hashes are:"
for COMMIT in $COMMITS; do
echo $COMMIT
done


# Track the changes that have been made.
SHOULD_BUMP_MAJOR=false
SHOULD_BUMP_MINOR=false
SHOULD_BUMP_PATCH=false

# Check each commit to calculate the next semantic version.
for COMMIT in $COMMITS; do
    # Get the commit message of the current commit.
    MESSAGE=$(git log -1 "${COMMIT}" --pretty=format:"%s")
    echo "Commit message is $MESSAGE"
    # Validate message and collect information about the current commit.
    if [[ "$MESSAGE" =~ $VALID_MESSAGE_FORMAT ]]; then

        COMMIT_TYPE=${BASH_REMATCH[1]}
        echo "commit type is $COMMIT_TYPE"
        COMMIT_BREAKING_CHANGE=${BASH_REMATCH[3]}
        echo "commit breaking change is $COMMIT_BREAKING_CHANGE"
        # Breaking changes trumps all other commits.
        if [[ -n "$COMMIT_BREAKING_CHANGE" ]]; then
            SHOULD_BUMP_MAJOR=true

            break
        fi

        # Signal that one or more new features have been detected.
        if [[ "$COMMIT_TYPE" =~ ^feat ]]; then
            SHOULD_BUMP_MINOR=true
        fi

        # Signal that one or more new fixes, updated dependencies, etc. have been detected.
        if [[ "$COMMIT_TYPE" =~ ^fix ]] || [[ "$COMMIT_TYPE" =~ ^build ]] || [[ "$COMMIT_TYPE" =~ ^perf ]] || [[ "$COMMIT_TYPE" =~ ^refactor ]] || [[ "$COMMIT_TYPE" =~ ^style ]]; then
            SHOULD_BUMP_PATCH=true
        fi
    fi
done

# Decide what the next semantic version should be.
if [[ $SHOULD_BUMP_MAJOR = true ]]; then
    echo "v$((TAG_MAJOR + 1)).0.0"
elif [[ $SHOULD_BUMP_MINOR = true ]]; then
    echo "v$TAG_MAJOR.$((TAG_MINOR + 1)).0"
elif [[ $SHOULD_BUMP_PATCH = true ]]; then
    echo "v$TAG_MAJOR.$TAG_MINOR.$((TAG_PATCH + 1))"
fi
