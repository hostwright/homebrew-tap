# Hostwright Homebrew Tap

This tap provides Hostwright's signed Apple-silicon qualification releases. It is not the Homebrew-core channel or a GA release.

## Install and verify

```bash
brew install hostwright/tap/hostwright
hostwright --version
hostwright capabilities --json
```

## Service

Install and review the example manifest before starting the service:

```bash
install -d -m 700 "$(brew --prefix)/etc/hostwright"
install -m 600 "$(brew --prefix)/opt/hostwright/share/hostwright/hostwright.yaml" \
  "$(brew --prefix)/etc/hostwright/hostwright.yaml"
brew services start hostwright
brew services restart hostwright
```

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

Homebrew leaves user-owned configuration and logs in place.
