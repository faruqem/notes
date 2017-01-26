## Preflight check

The Laravel framework has these system requirements:

+ PHP >= 5.6.4
+ OpenSSL PHP Extension
+ PDO PHP Extension
+ Mbstring PHP Extension
+ Tokenizer PHP Extension
+ XML PHP Extension

If you've followed our lead and set your PHP executable to be the same as the PHP that ships with MAMP/XAMPP, your local server should meet all these requirements.

Side note: What is Homestead (mentioned in the [Laravel installation documentation](https://laravel.com/docs/installation))?



## Create a new Laravel applications

There are a couple different ways to spawn a new Laravel application but we'll be using Composer.

Change directories into your local *Document Root* where your new app will live.

Mac:
```bash
$ cd /Applications/MAMP/htdocs
```

Windows:
```bash
$ cd c:\xampp\htdocs
```

Next, use this `composer` command to generate a new Laravel project. In this command, the name of our project is `foobooks` which the name we're giving an example application we'll be building during lectures. This command may take a minute or few to complete.

```bash
$ composer create-project laravel/laravel foobooks --prefer-dist
```

If you see warnings or errors after running this command, scroll down to see if your issue is listed in the __Troubleshooting__ section.

When Composer is done working, move into the newly created project directory:

```
$ cd foobooks
```

Once in this directory, run the `ls -la` command; you should see all the Laravel related files (including hidden ones).

<img src='http://making-the-internet.s3.amazonaws.com/laravel-fresh-install@2x.png' style='max-width:651px; width:100%' alt='Laravel fresh install'>




## Permissions

At this point in the installation procedure, some Laravel tutorials would have you run specific commands to make the `storage` and `bootstrap/cache` directories writable.

When using Laravel, the Apache web server needs *write* access for the `storage` and `bootstrap/cache` directories because Laravel will write data to these directories. For example, errors will be written to `storage/logs/laravel.log`, and cached configurations to speed up your app will be written to `bootstrap/cache`.

But for __Windows/XAMPP users__, you shouldn't need to adjust permissions because Apache already has all the permissions it needs since it runs under Window's LocalSystem account  which has extensive read/write access to local paths.

Likewise, most __Mac/MAMP users__ shouldn't need to adjust any permissions because MAMP's Apache is running as the user who launched it, i.e. you, and as owner of all the files and directories in your project, you already have write access.

The only instance where this might not work is if you're using a different local server setup that does *not* have the correct permission configuration. If that were the cause, you'd want to configure `storage` and `bootstrap/cache` to be writable by your web server.

We'll talk specifically about setting permissions on DigitalOcean when we get to deployment in the next note set.


## Namespacing
Namespacing is a programming techniques that helps you avoid name conflicts between software programs that are used in combination with one another.

Laravel5 uses namespacing, so one of the initial configurations you can make is to set a specific `name` for your application.

For example, for our &ldquo;Foobooks&rdquo; app, we may want to use the name `Foobooks`. This would be accomplished with this command:

```bash
$ php artisan app:name Foobooks
```

If you don't explicitly set a name for your application, it will default to `App`.

Choosing a name other than `App` for your application is suggested, but it's optional.

In the interest of making our examples more generic, we're *not* going to rename the Foobooks namespace and leave it as the default `App`.

We'll discuss namespacing more later, but in the mean time, you can learn more here: [Code Smart: Namespaces](https://daylerees.com/code-smart-namespaces/).


## Point local server to your new app
The bare bones initial setup for your app is complete, and you should be ready to view it in the browser.

First, though, you'll need to point your localhost's *Document Root* to the `public/` directory within your new app.

The paths will look something like this (adjust accordingly to match your system):

Mac:
```xml
/applications/MAMP/htdocs/foobooks/public
```

Windows:
```xml
c:\xampp\htdocs\foobooks\public
```

In MAMP you can change the *Document Root* via the Apache settings:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-app-setup-document-root@2x.png' class='' style='max-width:300px; width:100%'>

In XAMP you'll change the *Document Root* via Apache's config file, `httpd.conf`:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-xamp-document-root@2x.png' class='' style='max-width:1087px; width:100%' alt=''>

__Save all changes and restart your server.__

If all went well, you should see Laravel's default welcome page when you visit `http://localhost` in your browser:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-app-setup-success@2x.png' style='max-width:686px; width:100%'>

Whenever configuring a server to run Laravel, always remember **the Document Root has to point to the `public/` folder within your app directory**.




## Version Control your new app

In your project, initiate a new Git repository:

```bash
$ git init
```

### Github
Create a new repository at Github.com. When doing this, do *not* initialize the repository with a `README.md` file because you'll be working with a repository that has already been initialized.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-foobook-repo@2x.png' class='' style='max-width:735px; width:100%' alt='Foobooks repo setup in Github'>

Note the Git SSH URL, for example, `git@github.com:username/foobooks`

In your project directory, add a new remote origin called `origin`, for example:

```bash
$ git remote add origin git@github.com:username/foobooks.git
```

### First commit
Run git status to see all your untracked files:

```bash
$ git status
```

Add all your files for committing:

```bash
$ git add --all
```

Commit these changes:

```bash
$ git commit -m "First commit"
```

Push your project up to Github:

```bash
$ git push origin master
```

When you visit your repository on Github you should see all your changes there.

Your app is now set up locally and ready for development. In the next section, we'll cover the procedure for deploying your app to a live server.


## Troubleshooting

### Composer installs an older version of Laravel

If Composer is downloading an older version of Laravel than you're expecting, it could be because your PHP in command line is out of date, and Composer is getting the latest version of Laravel supported by that version.

Confirm by running `php --version`

It should report back >= 5.6

If it's 5.5 or less, you will get an older version of Laravel. Revisit the [Composer Setup](https://github.com/susanBuck/dwa15-fall2016-notes/blob/master/03_Laravel/03_Composer_Setup.md) notes where it talks about checking/setting your PHP version in Command Line.


### Cache permission error when creating a new Laravel project with Composer

If you see the following warning when installing Laravel w/ Composer...

```xml
Cannot create cache directory [your home directory].composer/cache/repo/https---packagist.org/, or directory is not writable. Proceeding without cache.
```

...it means that Composer lacks the appropriate permissions to write cache files to the `.composer/cache` directory

This appears to be an issue isolated to Mac users, and can be fixed by running the following command:

```
$ sudo chown -R $USER $HOME/.composer
```

Run this command exactly as is, you do not need to edit it, as `$USER` and `$HOME` are dynamic variables that will fill in with your computer's username and home directory.

This command will recursively (`-R`) set you (`$USER`) as the owner of the `.composer` directory. That way when you run commands as Composer, it will have the appropriate permissions needed to write files to its cache directory.



### When running your app
If your new app won't run, the first place you'll want to check for clues is `storage/logs/laravel.log` as that's where Laravel outputs errors.

If you see the error `No supported encrypter found.` chances are it means the `APP_KEY` in your environment file is not properly set.
This should not happen on a new installation, as generating the app key is something the Laravel installer does. However, if for some reason your app key is not set, you can fix it with this command:


```php
$ php artisan key:generate
```


## Misc
* When using the `composer create-project` command, we added the `--prefer-dist ` flag. You can read more about `--prefer-dist` and how it differs from `--prefer-source` [here](https://getcomposer.org/doc/03-cli.md#install).



## Read More
+ <https://laravel.com/docs/installation>
