#!/bin/bash
#
# Generates a change log, in markdown format, of the changes that
# has been added between the latest and previous tags.
#

# Extract information about the latest tag.
LATEST_TAG=$(git describe --tags --always --abbrev=0)

# Extract information about the previous tag.
PREVIOUS_TAG=$(git describe --tags --always --abbrev=0 "$LATEST_TAG^")

# Define supported conventional commit types with corresponding emojis
types=(
    'build|🏗️️'
    'ci|🤖'
    'chore|🧹'
    'docs|📝'
    'feat|🚀'
    'fix|🛠️'
    'perf|⚡'
    'refactor|🔧'
    'style|💄'
)

echo "# Changelog #"

# Retrieve the commit SHAs for the commits that have been added since the previous tag was created
# up to the latest tag
COMMITS=$(git log "$PREVIOUS_TAG".."$LATEST_TAG" --no-merges --pretty=format:"%H|%s")

# Loop through each type
for fields in "${types[@]}"; do
    # Split the type and emoji by the '|' delimiter
    IFS=$'|' read -r TYPE EMOJI < <(echo "$fields")

    # Create array for all commits that match the current type
    commits_from_type=()

    # For every commit, check if its title matches the current type
    for COMMIT in $COMMITS; do
        # Split commit in its SHA and its title by the '|' delimiter
        IFS=$'|' read -r COMMIT_SHA COMMIT_TITLE < <(echo "$COMMIT")

        # Check the commit title via regexp
        if  [[ "$COMMIT_TITLE" =~ ^"$TYPE".*$ ]]; then
            commits_from_type+=($COMMIT_SHA)
        fi
    done

    # If there are no commits for this type, skip to the next one
    if [[ -z "${commits_from_type[@]}" ]]; then
        continue
    fi

    # Output a header for this type with its corresponding emoji
    echo "## $EMOJI $TYPE ##"

    # Loop through each commit and output its message with a bullet point
    for COMMIT in "${commits_from_type[@]}"; do
        MESSAGE=$(git log -1 "$COMMIT" --pretty=format:"%s (%h)")

        echo -n "- "

        # If the commit contains a breaking change, add a warning emoji to the output
        if [[ "$MESSAGE" =~ !: ]]; then
            echo -n "⚠️ "
        fi

        # Output the commit message
        echo "$MESSAGE"
    done
done
