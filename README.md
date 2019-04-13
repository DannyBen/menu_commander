Menu Commander
==================================================

[![Gem Version](https://badge.fury.io/rb/menu_commander.svg)](https://badge.fury.io/rb/menu_commander)
[![Build Status](https://travis-ci.com/DannyBen/menu_commander.svg?branch=master)](https://travis-ci.com/DannyBen/menu_commander)
[![Maintainability](https://api.codeclimate.com/v1/badges/aa048e0f2cf1655261ac/maintainability)](https://codeclimate.com/github/DannyBen/menu_commander/maintainability)

---

Easily create menus for any command line tool using simple YAML configuration.

---

Installation
--------------------------------------------------

    $ gem install menu_commander



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

Running it, looks like this:

![Demo](/demo/demo.gif)


Features
--------------------------------------------------

All features have an example configuration in the
[examples folder](examples). To run an example, simply execute 
`menu EAXMPLE_NAME` form within the examples folder, where `EXAMPLE_NAME` 
is the name of the YAML file without the extension.

### Minimal menu requirements

The only requirement for a minimal menu is to have a `menu` definition
with `key: command` to run.

```yaml
# examples/minimal.yml
menu:
  hello: echo hello
  whoami: whoami
```

### Argument sub-menus

Using `%{variables}` in a command will prompt for an input when executed. The 
sub-menu for that input is specified in the `args` definition.

```yaml
# examples/args-array.yml
menu:
  server: rails server --env %{environment}
  test: RAILS_ENV=%{environment} rspec

args:
  environment:
    - staging
    - production
```

Using `key: value` pairs in the `args` menu will create a sub-menu with 
labels that are different from their substituted value:

```yaml
# examples/args-hash.yml
menu: 
  server: rails server --env %{environment}
  test: RAILS_ENV=%{environment} rspec

args:
  environment:
    Staging Environment: staging
    Production Environment: production
```

In order to obtain the sub-menu items from a shell command, simply provide
the command to run, instead of providing the menu options. The command is
expected to provide newline-delimited output.

```yaml
# examples/args-shell.yml
menu:
  show: cat %{file}
  edit: vi %{file}

args:
  file: ls 
```

### Free text input

When using a `%{variable}` that does not have a corresponding definition in
the `args` section, you will simply be prompted for a free text input:

```yaml
# examples/args-free-text.yml
menu:
  release: 
    echo %{version} > version.txt &&
    git tag v%{version}
```

### Nested menus

You can nest as many menu levels as you wish under the menu definition.

```yaml
# examples/nested.yml
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

