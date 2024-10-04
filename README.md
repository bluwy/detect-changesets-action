# Detect Changesets

Detect whether there are changesets in the `.changeset` directory. It checks the `.changeset` directory for changeset `.md` files statically so `@changesets/cli` doesn't need to be installed. It also handles prerelease mode where `.md` files are always preserved, but will filter them out if they were already released (via `pre.json` file).

## Example

```yaml
name: CI

on:
  push:
    branches:
      - master

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      # Checkout the repository to access the files
      - uses: actions/checkout@v4

      - uses: bluwy/detect-changesets-action@v1
        id: detect

      - if: steps.detect.outputs.has-changesets == 'true'
        run: |
          echo "Changesets detected!"
          echo "Changesets: ${{ steps.detect.outputs.changesets }}"

        # Example output:
        # Changesets detected!
        # Changesets: [blue-boats-relax,dry-donuts-smile]

      - if: steps.detect.outputs.has-changesets == 'false'
        run: echo "No changesets detected!"
```

> For `steps.detect.outputs.changesets`, you can use [`fromJSON`](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/evaluate-expressions-in-workflows-and-actions#fromjson) to parse the array if needed, for example:
>
> ```yaml
> - if: contains(fromJSON(steps.detect.outputs.changesets), 'blue-boats-relax')
> ```

## Sponsors

<p align="center">
  <a href="https://bjornlu.com/sponsor">
    <img src="https://bjornlu.com/sponsors.svg" alt="Sponsors" />
  </a>
</p>

## License

MIT
