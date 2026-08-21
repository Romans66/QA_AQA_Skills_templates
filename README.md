# Skill Library

A portable collection of quality-engineering skills for AI assistants.

## Layout

- `catalog/` — skill definitions grouped by purpose
- `automation/` — local installation and link maintenance
- `settings/clients.list` — optional client locations

## Install

```bash
git clone <repository-url> <local-directory>
bash <local-directory>/automation/bootstrap-library.sh
```

The bootstrap command indexes every skill into `~/.local/share/assistant-skills`, connects detected clients, and adds a local refresh hook.

## Update

```bash
git pull
```

Existing links expose content changes immediately. The hook refreshes links after pulls that add, remove, or rename catalog entries. Run the bootstrap command again only to restore the hook or reconnect clients.
