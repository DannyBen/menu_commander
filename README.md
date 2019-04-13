Menu Commander
==================================================

[![Gem Version](https://badge.fury.io/rb/menu_commander.svg)](https://badge.fury.io/rb/menu_commander)
[![Build Status](https://travis-ci.com/DannyBen/menu_commander.svg?branch=master)](https://travis-ci.com/DannyBen/menu_commander)
[![Maintainability](https://api.codeclimate.com/v1/badges/.../maintainability)](https://codeclimate.com/github/DannyBen/menu_commander/maintainability)

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

