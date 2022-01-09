<div align="center">

# asdf-mcfly ![Build](https://github.com/barolab/asdf-mcfly/workflows/Build/badge.svg) ![Lint](https://github.com/barolab/asdf-mcfly/workflows/Lint/badge.svg)

[mcfly](https://github.com/cantino/mcfly) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)
- [Credits](#credits)

# Dependencies

- `bash`, `curl`, `tar`.

# Install

Plugin:

```shell
asdf plugin add mcfly
# or
asdf plugin add mcfly https://github.com/barolab/asdf-mcfly.git
```

mcfly:

```shell
# Show all installable versions
asdf list-all mcfly

# Install specific version
asdf install mcfly latest

# Set a version globally (on your ~/.tool-versions file)
asdf global mcfly latest

# Now mcfly commands are available
mcfly --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/barolab/asdf-mcfly/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Romain Bailly](https://github.com/barolab/)

# Credits

This repository was heavily inspired from [asdf-exa](https://github.com/nyrst/asdf-exa)
