# MAP Workspace

It's not a monorepo or a pnpm workspace—just a bunch of packages linked together with npm link. And it works.

## Available Scripts

- `branches.sh` _(to show current git branch of each repo)_
- `build.sh` _(to build bundle for each repo)_
- `pull.sh` _(to pull latest updates)_
- `start.sh` _(to start `mapintegratedvuer` after linking all)_
- `switch.sh` _(to switch branches defined in `projects.json`)_
- `test.sh` _(to run `test` for each repo)_

## Projects

`projects.json` is the main file that defines the branches for each project. Because a single project or task may involve updates to multiple packages, which are linked together.

## Usage

1. Update `.gitmodules`.
2. Update `projects.json`.
3. Check `branches.sh`.
4. Run `switch.sh` and select the desired project to switch.
5. `pull.sh` to pull the latest updates from remote.
6. `start.sh` to `serve` `mapintegratedvuer` in dev mode.

## ⚠️ Warning:

Use with caution!
