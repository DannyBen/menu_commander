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


![Demo](/demo/demo.gif)


Menu Configuration Features
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

In case the argument array contains only one array element for a given 
variable, it will be automatically used without prompting the user.

This is useful when you need to define variables that repeat multiple times
in your menu.

```yaml
# examples/args-static.yml

menu:
  "Show Files": ssh %{server} ls
  "Reboot": ssh %{server} reboot

# Using an array with exactly one argument will NOT prompt the user for input
# and instead, use the only possible value.
args:
  server:
  - localhost
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

The below configuration will be merged into the above menu:

```yaml
# examples/extend-parent.yml
menu:
  ping: ping %{server}

args:
  server: [localhost, google.com]
```


### Multi-line commands

Providing an array to a menu, will join the array with '&&' to a single
command. Alternatively, you can use a simple YAML multi-line string.


```yaml
# examples/multiline.yml
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


