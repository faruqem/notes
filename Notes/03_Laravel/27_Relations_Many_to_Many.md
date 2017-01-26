## Relationships: Many to Many
In defining the *One to Many* relationship for books and authors, we operated under the constraint that each book only had a single author.

Certain features, though, won't fit into this design. For example, a tagging feature.

We could add a `tag_id` field to the books table, to associate a tag (novel, fiction, history, etc.) with a book, but that would limit us to a single tag per book, which is not ideal.

To accomplish what we want, we need to implement a *Many to Many* relationship so that *many* books can have *many* tags (and vice versa)

Example:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-many-to-many-diagram@2x.png' style='max-width:641px; width:100%' alt='Many to Many'>



## Pivot tables
*Many to Many* relationships require an additional table, called a __pivot table__ to keep track of the many connections.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-book-tag-pivot@2x.png' style='max-width:882px;' alt=''>

+ Also known as: *lookup table*, *join table*.
+ Table naming convention:
    + Use the singular version of the name of the two tables you're joining, separated with an underscore, in alphabetical order.
    + Ex: If you're joining the `books` table with the `tags` table, the resulting pivot table name would be `book_tag`.
+ Foreign keys:
    + A pivot table links together tables together using __foreign keys (FK)__.
    + Convention says FK field names should consist of the associated table name, singularized, and appended with `_id`.
    + Ex: The FK to the `books` table is `book_id` and the FK to the `tags` table is `tag_id`.

Before we create the pivot table, let's first get a Migration, Model and Seeder set up for __Tags__...




## Create the tags table
Create a new migration file to create the `tags` table:
```bash
$ php artisan make:migration create_tags_table
```

The migration up/down methods should look like this:
```php
public function up()
{
    Schema::create('tags', function (Blueprint $table) {
        $table->increments('id');
        $table->timestamps();
        $table->string('name');
    });
}

public function down()
{
    Schema::drop('tags');
}
```

Since we've created a `tags` table, we should also generate an `Tag` model:
```bash
$ php artisan make:model Tag
```



## Seed the tags table
Create the seeder:
```bash
$ php artisan make:seeder TagsTableSeeder
```

The `run()` method of this seeder should look like this:

```php
public function run()
{
    $data = ['novel','fiction','classic','wealth','women','autobiography','nonfiction'];

    foreach($data as $tagName) {
        $tag = new Tag();
        $tag->name = $tagName;
        $tag->save();
    }
}
```

Finally, update `/database/seeds/DatabaseSeeder.php` to invoke this new seeder, as we've done previously.

```php
public function run()
{
    $this->call(TagsTableSeeder::class); # <-- NEW
    $this->call(AuthorsTableSeeder::class);
    $this->call(BooksTableSeeder::class);
}
```



## Create pivot table
We've just created the `tags` table, and the `books` table already exists, so now we need to create the pivot table to connect these two tables.

Following the pivot table naming conventions described above, this table should be called `book_tag`.

Create a new migration file to create the `book_tag` table:
```xml
$ php artisan make:migration create_book_tag_table
```

The migration up/down methods should look like this (comments are included to explain the field choices):
```php
public function up()
{
    Schema::create('book_tag', function (Blueprint $table) {

        $table->increments('id');
        $table->timestamps();

        # `book_id` and `tag_id` will be foreign keys, so they have to be unsigned
        #  Note how the field names here correspond to the tables they will connect...
        # `book_id` will reference the `books table` and `tag_id` will reference the `tags` table.
        $table->integer('book_id')->unsigned();
        $table->integer('tag_id')->unsigned();

        # Make foreign keys
        $table->foreign('book_id')->references('id')->on('books');
        $table->foreign('tag_id')->references('id')->on('tags');
    });
}

public function down()
{
    Schema::drop('book_tag');
}
```




## Update the Models
As we saw with *One to Many*, relationships between tables need to be defined in their corresponding Models via __relationship methods__.

For this *Many to Many* example that will look like this...

In the Book model add a `tags()` method, specifying that each book belongs to many tags:
```php
public function tags()
{
    # With timetsamps() will ensure the pivot table has its created_at/updated_at fields automatically maintained
    return $this->belongsToMany('App\Tag')->withTimestamps();
}
```

And in the Tag model add a `books()` method, specifying that each tag belongs to many books:
```php
public function books() {
    return $this->belongsToMany('App\Book')->withTimestamps();
}
```



## Seed the book_tag pivot table
Create the seeder:
```xml
$ php artisan make:seeder BookTagTableSeeder
```

The `run()` method of this seeder should look like this:
```php
public function run()
{

    # First, create an array of all the books we want to associate tags with
    # The *key* will be the book title, and the *value* will be an array of tags.
    $books =[
        'The Great Gatsby' => ['novel','fiction','classic','wealth'],
        'The Bell Jar' => ['novel','fiction','classic','women'],
        'I Know Why the Caged Bird Sings' => ['autobiography','nonfiction','classic','women']
    ];

    # Now loop through the above array, creating a new pivot for each book to tag
    foreach($books as $title => $tags) {

        # First get the book
        $book = Book::where('title','like',$title)->first();

        # Now loop through each tag for this book, adding the pivot
        foreach($tags as $tagName) {
            $tag = Tag::where('name','LIKE',$tagName)->first();

            # Connect this tag to this book
            $book->tags()->save($tag);
        }

    }
}
```

And, of course, update `DatabaseSeeder.php`:

```php
public function run()
{
    $this->call(TagsTableSeeder::class);
    $this->call(AuthorsTableSeeder::class);
    $this->call(BooksTableSeeder::class);
    $this->call(BookTagTableSeeder::class); # <-- NEW
}
```

__Make sure your migrations and seeds have been run without error before proceeding...__


## Query relationship example
Here's what we've accomplished:

1. Created and seeded the `tags` table.
2. Let our Models (`Book` and `Tag`) know about the relationship between one another.
3. Created and seeded the `book_tag` table.

With that all set up, we can look at an example of retrieving a single book with its tags:
```php
$book = Book::where('title', '=', 'The Great Gatsby')->first();

dump($book->title);

foreach($book->tags as $tag) {
    dump($tag->name);
}
```

Or many books with their tags (note how tags are eagerly loaded to reduce queries):
```php
$books = Book::with('tags')->get();

foreach($books as $book) {
    dump($book->title.' is tagged with: ');
    foreach($book->tags as $tag) {
        dump($tag->name);
    }
}
```



## More...
The above is a basic setup and simple example of a Many to Many relationship. We will continue work on this by updating foobooks to cover:

+ Associating tags with books.
+ Deleting tags from books.
+ How tags impacts our *Create Book* and *Edit Book* page.




## Reference
+ [Docs: Relationships: Many to Many](http://laravel.com/docs/eloquent-relationships#many-to-many)
