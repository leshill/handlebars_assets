# Use handlebars.js templates with the asset pipeline and sprockets

Are your `handlebars.js` templates littering your Rails views with `script` tags? Wondering why the nifty Rails 3.1 asset pipeline streamlines all your Javascript except for your Handlebars templates? Wouldn't it be nice to have your Handlebars templates compiled, compressed, and cached like your other Javascript?

Yea, I think so too. That is why I wrote **handlebars_assets**. Give your Handlebars templates their own files (including partials) and have them compiled, compressed, and cached as part of the Rails 3.1 asset pipeline!

Using `sprockets` with Sinatra or another framework? **handlebars_assets** works outside of Rails too (as of v0.2.0)

## handlebars.js

`handlebars_assets` is packaged with `v1.0.beta.6` of `handlebars.js`.

## Installation with Rails 3.1+

Load `handlebars_assets` in your `Gemfile` as part of the `assets` group

    group :assets do
      gem 'handlebars_assets'
    end

## Installation without Rails 3.1+

`handlebars_assets` can work with earlier versions of Rails or other frameworks like Sinatra.

Load `handlebars_assets` in your `Gemfile`

    gem 'handlebars_assets'

Add the `HandlebarsAssets.path` to your `Sprockets::Environment` instance. This
lets Sprockets know where the Handlebars JavaScript files are and is required
for the next steps to work.

    env = Sprockets::Environment.new

    require 'handlebars_assets'
    env.append_path HandlebarsAssets.path


# Compiling your Javascript templates in the Rails asset pipeline

Require `handlebars.runtime.js` in your Javascript manifest (i.e. `application.js`)

    //= require handlebars.runtime

If you need to compile your Javascript templates in the browser as well, you should instead require `handlebars.js` (which is significantly larger)

    //= require handlebars

## Precompiling

`handlebars_assets` also works when you are precompiling your assets. If you are deploying to Heroku, be sure to read the [Rails guide](http://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets) and in your `config/application.rb` set:

    config.assets.initialize_on_precompile = false

## Templates directory

You should locate your templates with your other assets, for example `app/assets/javascripts/templates`. In your Javascript manifest file, use `require_tree` to pull in the templates

    //= require_tree ./templates

## The template file

Write your Handlebars templates as standalone files in your templates directory. Organize the templates similarly to Rails views.

For example, if you have new, edit, and show templates for a Contact model

    templates/
      contacts/
        new.hbs
        edit.hbs
        show.hbs

Your file extensions tell the asset pipeline how to process the file. Use `.hbs` to compile the template with Handlebars.

If your file is `templates/contacts/new.hbs`, the asset pipeline will generate Javascript code

1. Compile the Handlebars template to Javascript code
1. Add the template code to the `HandlebarsTemplates` global under the name `contacts/new`

You can then invoke the resulting template in your application's Javascript

    HandlebarsTemplates['contacts/new'](context);

## The template namespace

By default, the global Javascript object that holds the compiled templates is `HandlebarsTemplates`, but it can
be easily renamed. Another common template namespace is `JST`.  Just change the `template_namespace` configuration option
when you initialize your application.

    HandlebarsAssets::Config.template_namespace = 'JST'

## Partials

If you begin the name of the template with an underscore, it will be recognized as a partial. You can invoke partials inside a template using the Handlebars partial syntax:

    Invoke a {{> partial }}

**Important!** Handlebars does not understand nested partials. To support them, partials are named based on their path using `_` instead `/` (skid => slash). So given:

    templates/
      _form.hbs
      contacts/
        _form.hbs
      todos/
        _form.hbs

You will get three partials named `_form`, `_contacts_form`, and `_todos_form`; note that the partials begin with `_`.

# Thanks

This gem is standing on the shoulders of giants.

Thank you Yehuda Katz (@wycats) for [handlebars.js](https://github.com/wycats/handlebars.js) and lots of other code I use every day.

Thank you Charles Lowell (@cowboyd) for [therubyracer](https://github.com/cowboyd/therubyracer) and [handlebars.rb](https://github.com/cowboyd/handlebars.rb).

# Author

Hi, I'm Les Hill and I make things go.

Follow me on [Github](https://github.com/leshill) and [Twitter](https://twitter.com/leshill).


# Contributors

* Matt Burke         (@spraints)    : execjs support
*                    (@kendagriff)  : 1.8.7 compatibility
* Thorben Schröder   (@walski)      : 3.1 asset group for precompile
* Erwan Barrier      (@erwanb)      : Support for plain sprockets
* Brendan Loudermilk (@bloudermilk) : HandlebarsAssets.path
* Dan Evans          (@danevans)    : Rails 2 support
* Ben Woosley        (@empact)      : Update to handlebars.js 1.0.0.beta.6
*                    (@cw-moshe)    : Remove 'templates/' from names

# Contributing

Once you've made your great commits

1. Fork
1. Create a topic branch - git checkout -b my_branch
1. Push to your branch - git push origin my_branch
1. Create a Pull Request from your branch
1. That's it!
