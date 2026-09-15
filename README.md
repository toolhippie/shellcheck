# shellcheck

[![Docker Build](https://github.com/toolhippie/shellcheck/workflows/docker/badge.svg)](https://github.com/toolhippie/shellcheck/actions?query=workflow%3Adocker) [![GitHub Repo](https://img.shields.io/badge/github-repo-yellowgreen)](https://github.com/toolhippie/shellcheck) [![Upstream Repo](https://img.shields.io/badge/upstream-repo-yellow)](https://github.com/koalaman/shellcheck)

All these images are used for various scriptings, it's possible that any of
these tools are updated randomly

## Versions

To get an overview about the available versions please take a look at our
[DockerHub tags][dockerhub] or [Quay.io tags][quayio], these lists are always up
to date.

## Contributing

Generally we are following [conventional commits][commits] when we apply
changes. That way we are able to generate proper changelogs for every release.
Please use always pull requests to integrate new functionalities or to fix
issues.

For the release process we are following [semantic versioning][semver] which
clearly indicates if a new version just resolves bugs, includes new features or
even includes breaking changes.

After installing the tools via `mise install` as described above set up the
pre-commit hooks so they run automatically on every commit:

```console
prek install --hook-type pre-commit --hook-type commit-msg
```

> `prek` is managed by mise and will be available after `mise install`.

If you have changed something on the source you should simply commit following
the mentioned conventions:

```console
git checkout -b feat/new-feature
git add --all
git commit -m 'feat: added awesome new feature'
git push --set-upstream origin feat/new-feature
```

After pushing your changes into the Git repository you should create a pull
request on GitHub. If the pull request have been merged and everything built
fine it will also create automatically a new release at least once a week.

## Authors

*  [Thomas Boerger](https://github.com/tboerger)

## License

MIT

## Copyright

```console
Copyright (c) 2018 Thomas Boerger <http://www.webhippie.de>
```

[dockerhub]: https://hub.docker.com/r/toolhippie/shellcheck/tags/
[quayio]: https://quay.io/repository/toolhippie/shellcheck?tab=tags
[mise]: https://mise.jdx.dev/
[mise-install]: https://mise.jdx.dev/getting-started.html
[commits]: https://www.conventionalcommits.org/en/v1.0.0/
[semver]: https://semver.org/
