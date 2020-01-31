Menu Commander
==================================================

[![Gem Version](https://badge.fury.io/rb/menu_commander.svg)](https://badge.fury.io/rb/menu_commander)
[![Build Status](https://github.com/DannyBen/menu_commander/workflows/Test/badge.svg)](https://github.com/DannyBen/menu_commander/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/aa048e0f2cf1655261ac/maintainability)](https://codeclimate.com/github/DannyBen/menu_commander/maintainability)

---

Easily create menus for any command line tool using simple YAML configuration.

---

* [Installation](#installation)
* [Usage](#usage)
   * [Menu Navigation](#menu-navigation)
* [Menu Definition](#menu-definition)
   * [Minimal menu requirements](#minimal-menu-requirements)
   * [Argument sub-menus](#argument-sub-menus)
   * [Free text input](#free-text-input)
   * [Nested menus](#nested-menus)
   * [Split menu into several files](#split-menu-into-several-files)
   * [Multi-line commands](#multi-line-commands)
* [Menu Options](#menu-options)
* [Menu File Location](#menu-file-location)

---

![Demo](/demo/cast.svg)

---

Installation
--------------------------------------------------

```shell
$ gem install menu_commander
```


Usage
--------------------------------------------------

Menu Commander adds the `menu` command line tool to your path. When running 
it without arguments, it will look for a `menu.yml` file in the current 
directory, and will provide you with a menu to execute any shell command.

A basic menu configuration file looks like this:

```yaml
# menu.yml

# Using %{variables} in a command will prompt for an input when executed
menu:
  hello: echo hello
  hi: echo hi %{name}

# Define sub menus for any %{variable} that was defined in the command
args:
  name:
  - Harry
  - Lloyd
```

Then, start the menu by running:

```shell
# Start the menu with ./menu.yml
$ menu

# Start the menu with ./some-other-file.yml
$ menu some-other-file
```

### Menu Navigation

- When a menu or sub menu has more than 10 items, it will become paginated
  and a search filter will be added.
- Pressing <kbd>Home</kbd> from any nested menu will go back to the first 
  menu.
- Pressing <kbd>Page Up</kbd> from any nested menu will go back to the 
  previous menu.
- Pressing <kbd>Ctrl</kbd>+<kbd>C</kbd> will exit from the menu.



Menu Definition
--------------------------------------------------

All features have an example configuration in the
[examples folder](examples). To run an example, simply execute 
`menu EAXMPLE_NAME` form within the examples folder, where `EXAMPLE_NAME` 
is the name of the YAML file without the extension.

### Minimal menu requirements

The only requirement for a minimal menu is to have a `menu` definition
with `key: command` to run.

```yaml
menu:
  hello: echo hello
  whoami: whoami
```

> See: [examples/minimal.yml](examples/minimal.yml)

### Argument sub-menus

Using `%{variables}` in a command will prompt for an input when executed. The 
sub-menu for that input is specified in the `args` definition.

```yaml
menu:
  server: rails server --env %{environment}
  test: RAILS_ENV=%{environment} rspec

args:
  environment:
    - staging
    - production
```

> See: [examples/args-array.yml](examples/args-array.yml)

In case the argument array contains only one array element for a given 
variable, it will be automatically used without prompting the user.

This is useful when you need to define variables that repeat multiple times
in your menu.

```yaml
args:
  server: [localhost]
```

> See: [examples/args-static.yml](examples/args-static.yml)

Using `key: value` pairs in the `args` menu will create a sub-menu with 
labels that are different from their substituted value:

```yaml
menu: 
  server: rails server --env %{environment}
  test: RAILS_ENV=%{environment} rspec

args:
  environment:
    Staging Environment: staging
    Production Environment: production
```

> See: [examples/args-hash.yml](examples/args-hash.yml)

In order to obtain the sub-menu items from a shell command, simply provide
the command to run, instead of providing the menu options. The command is
expected to provide newline-delimited output.

```yaml
menu:
  show: cat %{file}
  edit: vi %{file}

args:
  file: ls 
```

> See: [examples/args-shell.yml](examples/args-shell.yml)

### Free text input

When using a `%{variable}` that does not have a corresponding definition in
the `args` section, you will simply be prompted for a free text input:

```yaml
menu:
  release: 
    echo %{version} > version.txt &&
    git tag v%{version}
```

> See: [examples/args-free-text.yml](examples/args-free-text.yml)

### Nested menus

You can nest as many menu levels as you wish under the menu definition.

```yaml
menu:
  docker:
    images: docker images ls
    containers: docker ps -a
    stack:
      deploy: docker stack deploy -c docker-compose.yml mystack
      list: docker stack ls

  git:
    status: git status
    branch: git branch
```

> See: [examples/args-nested.yml](examples/args-nested.yml)


### Split menu into several files

Each menu configuration file can include any number of additional YAML
files inside it. This is useful when:

- Your menu configuration file becomes too long, and you wish to split it
  to separate logical units.
- You have multiple menu files, and you want to include common configuration
  in each of them.

This is done by using the `extends` option:

```yaml
# examples/extend.yml
extends: extend-parent.yml

menu:
  hello: echo hello
  hi: echo hi %{name}

args:
  name: [Harry, Lloyd]
  server: [example.com]
```

> See: [examples/extend.yml](examples/extend.yml)

The below configuration will be merged into the above menu:

```yaml
# examples/extend-parent.yml
menu:
  ping: ping %{server}

args:
  server: [localhost, google.com]
```

> See: [examples/extend-parent.yml](examples/extend-parent.yml)


### Multi-line commands

Providing an array to a menu, will join the array with '&&' to a single
command. Alternatively, you can use a simple YAML multi-line string.


```yaml
menu:
  deploy:
    - run tests
    - git commit -am "automatic commit"
    - git push

  alternative: >
    run tests &&
    git commit -am "automatic commit" &&
    git push
```

> See: [examples/multiline.yml](examples/multiline.yml)


Menu Options
--------------------------------------------------

You can tweak several aspects of the menu by adding an `options` section
in your YAML file.

```yaml
# Optional menu configuration
options:
  # Show header text
  header: Hello

  # Marker to show as the suffix of items that have submenus
  # Use false to disable
  submenu_marker: " ..."

  # Menu selection marker
  select_marker: ">"

  # Menu title marker
  title_marker: "-"

  # When a menu has more items than page_size, add pagiation
  # Default 10
  page_size: 2

  # When to show search filter
  # yes      = always show
  # no       = never show
  # auto     = show only when there aare more items than page_size (default)
  # <number> = show only when there are more items than <number>
  filter: yes

  # When arg lists generate one item only it is auto-selected by default.
  # Set this to false to disable this behavior
  auto_select: false

  # Show the command after execution
  echo: true

  # Marker to use when echoing the command and it was successful
  echo_marker_success: "==>"

  # Marker to use when echoing the command and it failed
  echo_marker_error: "ERROR ==>"

```

> See: [examples/options.yml](examples/options.yml)



Menu File Location
--------------------------------------------------

By default, menu files are looked for in the current working directory. 

You may instruct Menu Commander to look in additional locations by setting
the `MENU_PATH` environment variable to one or more paths. Note that when
using this method, Menu Commander will *not* look in the current directory, 
unless you include it in `MENU_PATH`, like this:

```shell
$ export MENU_PATH=.:$HOME/menus:/etc/menus
```

If you wish this setting to be permanent, add it to your `.bashrc` or your 
preferred initialization script.


[1]: https://github.com/dannyben/colsole#color-codes
