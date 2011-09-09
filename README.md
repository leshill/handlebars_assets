# Use handlebars.js templates with the asset pipeline

**ALPHA**

Are your `handlebars.js` templates littering your Rails views with `script` tags? Wondering why the nifty Rails 3.1 asset pipeline streamlines all your Javascript except for your Handlebars templates? Wouldn't it be nice to have your Handlebars templates compiled, compressed, and cached like your other Javascript?

Yea, I think so too. That is why I wrote **handlebars_assets**. Give your Handlebars templates their own files (including partials) and have them compiled, compressed, and cached as part of the Rails 3.1 asset pipeline!

## Installation

Load `handlebars_assets` in your `Gemfile`

    gem 'handlebars_assets'

Require `handlebars.js` in your Javascript manifest (i.e. `application.js`)

    //= require handlebars

# Compiling your Javascript templates in the asset pipeline

## Templates directory

You should located your templates under `app/assets/templates`. In your Javascript manifest file, use `require_tree`

    //= require_tree ../templates

## The template file

Write your Handlebars templates as standalone files in your templates directory. Organize the templates similarly to Rails views.

For example, if you have new, edit, and show templates for a Contact model

    templates/
      contacts/
        new.jst.hbs
        edit.jst.hbs
        show.jst.hbs

Your file extensions tell the asset pipeline how to process the file. Use `.hbs` to compile the template with Handlebars. Combine it with `.jst` to add the compiled template to the `JST` global variable.

If your file is `templates/contacts/new.jst.hbs`, the asset pipeline will generate Javascript code

1. Compile the Handlebars template to Javascript code
1. Add the template code to the `JST` global under the name `contacts/new`

You can then invoke the resulting template in your application's Javascript

    JST['contacts/new'](context);

## Partials

If you begin the name of the template with an underscore, it will be recognized as a partial. You can invoke partials inside a template using the Handlebars partial syntax:

    Invoke a {{> partial }}

**Important!** Handlebars does not understand nested partials and neither does this engine. No matter how nested, the partial is named from the asset's basename. The following will lead to much frustration (so don't do it :)

    templates/
      contacts/
        _form.hbs
      todos/
        _form.hbs

# Thanks

This gem is standing on the shoulders of giants.

Thank you Yehuda Katz (@wycats) for [handlebars.js](https://github.com/wycats/handlebars.js) and lots of other code I use every day.

Thank you Charles Lowell (@cowboyd) for [therubyracer](https://github.com/cowboyd/therubyracer) and [handlebars.rb](https://github.com/cowboyd/handlebars.rb).

# Contributing

Once you've made your great commits

1. Fork
1. Create a topic branch - git checkout -b my_branch
1. Push to your branch - git push origin my_branch
1. Create a Pull Request from your branch
1. That's it!

# Author

Les Hill : @leshill

# Contributors

Matt Burke : @spraints ( execjs support )
