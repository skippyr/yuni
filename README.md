# yuni
## About
A modern version of the macOS default ZSH theme, adding essential developer features the original theme lacked. Its displays: the exit code of failed commands, your user and host names, the current directory path shortened, the active branch, and privilege decorators: `%` if you're a normal user, `#` if root, and `[!]` when you don't have permissions to modify the current directory. It's available for macOS 14 Sonoma or later.

![](Assets/PreviewDark.png)
![](Assets/PreviewLight.png)

## Install
### Using OhMyZSH Framework
- Download the latest release from the [Releases page](http://github.com/skippyr/yuni/releases/latest).
- Extract the archive.
- Move the extracted directory to `~/.oh-my-zsh/custom/themes`.
- Set it as your theme in your `~/.zshrc` file:

```zsh
ZSH_THEME='yuni'
```

- Reopen the shell.

### Without Using a Framework
- Download the latest release from the [Releases page](http://github.com/skippyr/yuni/releases/latest).
- Extract the archive.
- Move the extracted directory to `~/.config/zsh/themes`.
- Add this to your `~/.zshrc` file:

```zsh
source ~/.config/zsh/themes/yuni/yuni.zsh-theme
```

- Reopen the shell.

## Help
If you need help related to this project, open a new issue in its [issues pages](https://github.com/skippyr/yuni/issues) or send an [e-mail](mailto:skippyr.developer@icloud.com) describing what is going on.

## Contributing
This project is open to review and possibly accept contributions in the form of bug reports and suggestions. If you are interested, send your contribution to its [pull requests page](https://github.com/skippyr/yuni/pulls) or via [e-mail](mailto:skippyr.developer@icloud.com).

## Copyright
This software is licensed under the MIT License. Refer to the `LICENSE` file that comes in its source code for more details.
