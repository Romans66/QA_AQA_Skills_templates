---
name: inspect-product-requirements
description: Review Jira, Confluence, or direct requirements for gaps, contradictions, risks, and test-relevant edge cases.
---

# Inspect product requirements

Create an evidence-based QA review of the supplied scope.

## Build the context

Use relevant information from Jira, Confluence, and user-provided material as one requirement set. Include relationships and referenced pages only when they clarify scope or behavior. Do not expose a fixed lookup order, internal query shape, connector method, or repository-specific convention.

When sources disagree, preserve the disagreement as a finding. Prefer explicit requirement statements over informal discussion, but do not silently resolve contradictions. If the available material does not define a stable scope, return a short insufficiency notice and identify what is missing.

## Review focus

- ambiguous or missing behavior
- state changes, retries, concurrency, and partial failure
- permissions, sensitive data, and abuse paths
- compatibility with existing users and stored data
- dependency, integration, performance, and observability expectations
- realistic boundary and recovery scenarios

Every finding must cite a source section, work item, or short source phrase. Avoid domain assumptions that are not supported by the collected context.

## Output

Respond in Russian unless the user asks otherwise. Group the result into:

1. Sources considered
2. Gaps and contradictions
3. Risks
4. Critical edge cases
5. Recommended requirement changes

Use `<P0>` through `<P3>` as severity placeholders and order findings by impact. Keep recommendations actionable and linked to the finding they address.
