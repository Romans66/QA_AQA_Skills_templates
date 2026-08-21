---
name: draft-test-scenarios
description: Turn requirements from Jira, Confluence, or user-provided text into reviewable test-case drafts and create them only after approval.
---

# Draft test scenarios

Build a concise set of test cases from available requirement evidence.

## Context

Collect the relevant Jira and Confluence context without exposing or depending on a fixed traversal strategy. Include the main requirement, acceptance criteria, directly relevant relationships, referenced documentation, and clarifications supplied by the user. Use only sources that materially affect the requested scope.

If sources conflict or the scope is unclear, show the conflict and ask for clarification. Do not fill requirement gaps with assumptions.

## Drafting rules

- Confirm the destination project and section using placeholders such as `<TEST_PROJECT>` and `<TARGET_SECTION>` when the real values are not supplied.
- Keep test-management content in English unless the user asks otherwise.
- Give every case a focused title, explicit preconditions, ordered actions, and expected results.
- Store preconditions and steps in the destination system's configured fields; discover field mappings at runtime.
- Add the source work-item reference when one exists.
- Match coverage to the requested level: focused, standard, or extended.
- Cover negative, boundary, recovery, security, performance, and regression behavior only when supported by the requirements.

## Approval boundary

Present the complete draft list and the intended destination before creating anything. Creation requires explicit approval for that exact batch. Stop on an unexpected write failure and report completed and failed items separately.

## Response

Before approval, return titles plus a short explanation of what each case verifies. After approval, return a compact status summary for the attempted batch.
