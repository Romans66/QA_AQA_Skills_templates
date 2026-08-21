---
name: connect-skill-library
description: Install this repository's skill catalog into a shared local directory and connect supported AI assistants to it.
---

# Connect the skill library

Use the repository bootstrap command:

```bash
bash <repository-path>/automation/bootstrap-library.sh
```

The command discovers every `SKILL.md` under `catalog/`, creates one shared local layer, connects configured clients, and installs a repository-local `post-merge` hook.

After installation, verify that the shared layer contains links to the catalog entries. Re-run the bootstrap command when reconnecting clients or restoring the hook. Normal content updates are visible through existing links; the hook refreshes the index after `git pull` when entries are added, removed, or renamed.
