# Hostwright Homebrew Tap

This vendor tap distributes signed Hostwright v0.0.2 downloads for Apple silicon on macOS 26 or later.

## Install and verify

```bash
brew install hostwright/tap/hostwright
hostwright --version
hostwright --help
```

Runtime commands use an authenticated local daemon. Follow the [installation and daemon setup guide](https://github.com/hostwright/hostwright/blob/main/docs/reference/install.md) before running `capabilities`, `doctor`, or workloads.

## Service

Review the installed Manifest v3 example and declare the signed installation identities before starting the service:

```bash
install -d -m 700 "$(brew --prefix)/etc/hostwright"
install -m 600 "$(brew --prefix hostwright)/share/hostwright/hostwright.yaml" \
  "$(brew --prefix)/etc/hostwright/hostwright.yaml"
hostwright daemon bootstrap-identities
brew services start hostwright
```

The signed desktop application is included under the formula prefix at `libexec/hostwright/Hostwright.app`. See the [desktop quickstart](https://github.com/hostwright/hostwright/blob/main/docs/guides/desktop-quickstart.md).

## Upgrade

```bash
brew update
brew upgrade hostwright
```

## Uninstall

```bash
brew services stop hostwright
brew uninstall hostwright
```

Homebrew leaves user-owned configuration, state and logs in place.
