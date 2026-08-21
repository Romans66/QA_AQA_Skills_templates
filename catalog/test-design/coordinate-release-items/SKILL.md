---
name: coordinate-release-items
description: Find release-related Jira items using user-supplied filters and optionally move the confirmed set to a requested workflow state.
---

# Coordinate release items

Use this skill for a filtered Jira search followed by an optional bulk workflow change.

## Required context

Resolve these values from the current request or ask for what is missing:

- project: `<PROJECT_KEY>`
- team field and value: `<TEAM_FIELD>` / `<TEAM_VALUE>`
- release version or versions: `<RELEASE_VERSION>`
- current state: `<SOURCE_STATUS>`
- requested state: `<TARGET_STATUS>`

Do not infer organization-specific field names, team values, or statuses from the skill.

## Search and confirmation

Use the most precise filters supported by the Jira instance and collect the complete matching set. Summarize the keys, current states, release values, and intended destination state. If there are no matches, stop after the summary.

Ask for explicit confirmation before changing workflow state. Confirmation applies only to the displayed set and target state.

## Applying changes

For each confirmed item, resolve a currently available transition that reaches the requested state. Never guess transition identifiers. Continue through independent failures, but re-check an item once when its state changed concurrently.

Report successes and failures separately. Include the reason and current state for every failed item when available.
