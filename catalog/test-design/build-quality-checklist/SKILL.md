---
name: build-quality-checklist
description: Produce a prioritized QA checklist from Jira, Confluence, implementation evidence, or direct requirements.
---

# Build a quality checklist

Gather only context relevant to the requested change from Jira, Confluence, repository changes, and user notes. The method and order used to obtain that context are environment-dependent and must not be encoded in the output.

Identify expected behavior, constraints, unclear areas, dependencies, and credible failure modes. Keep every checklist item traceable to requirement or implementation evidence; do not add generic filler.

## Coverage areas

Include only applicable sections:

- Functional behavior
- Non-functional quality
- Security and access control
- Performance and concurrency
- Boundary and recovery cases
- Regression impact

## Format

Write in the user's language. Format each item as a checkbox with priority, action, expected result, and a source reference where available:

```text
- [ ] <PRIORITY> <ACTION> → <EXPECTED_RESULT> [<SOURCE_REFERENCE>]
```

Sort higher-risk checks first. If the evidence is insufficient, state what requirement boundary or implementation context is missing instead of inventing checks.

Do not post the checklist externally unless the user explicitly approves the exact destination and content.
