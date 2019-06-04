# Tabby
Tabby is a simple iTerm2 environment configuration tool. It allows you to create different environments for different projects, each with their own set of tabs and command sets.

## Usage

### Install

`gem install tabby2`

### Creating Projects

`tabby create PROJECT_NAME`

### Editing Projects
Projects are stored in `~/.tabby/`, using a simple and short name. You can edit them at anytime by running `tabby edit PROJECT_NAME`

Tabby environments are just regular Ruby classes. The filename and classname should match, with the classname following regular Ruby standards:

    class Blog < Tabby::Base
    end

Define your project's root directory with `basedir`:

    class Blog < Tabby::Base
      basedir "~/Dev/Blog"
    end

Creating tabs is just a matter of creating methods. There should be one method per tab. The method name becomes the tab's title; replacing underscores with spaces.

    class Blog < Tabby::Base
      basedir "~/Dev/Blog"

      def jekyll
        exec "jekyll --auto --server"
      end

      def sass
        exec "sass --watch public/css/main.sass:public/css/main.css"
      end
    end

Each tab will start off by `cd`'ing into the environment's `basedir`. Then it will execute it's list of commands in order.

### Starting An Project
    tabby open blog

![tabby](https://github.com/mnoble/tabby/raw/master/screenshot.png)

## License
See LICENSE
