[php.net Arrays](http://php.net/manual/en/language.types.array.php)

<img src='http://making-the-internet.s3.amazonaws.com/php-arrays.png?@2x' style='max-width:300px'>

Variables are useful for storing single pieces of information, but sometimes you need to organize multiple pieces together; enter arrays.

In PHP, arrays organize information using **keys** and **values**.

To practice with arrays and some other upcoming material, we're going to build a simple **Raffle** application that will randomly choose winners from a list of contestants.

## File Setup

```xml
/raffle/
	index.php
	logic.php
```



## Contestants setup


In `logic.php` create a contestants array:

```php
<?php
$contestants["Sam"]   = "loser";
$contestants["Eliot"] = "loser";
$contestants["Liz"]   = "winner";
$contestants["Max"]   = "loser";
```

This same array could also be written like this:

```php
<?php
$contestants = [
	'Sam'   => 'loser',
	'Eliot' => 'loser',
	'Liz'   => 'winner',
	'Max'   => 'loser',
	];
```

Regardless of which style you choose, the name of the array is `$contestants` and the **keys** are Sam, Eliot, Liz and Max. You can think of keys as an index, or position holder in an array.

The **values** are loser, loser, winner and loser. Sam is a loser, Eliot is a loser, Liz is a winner, and Max is a loser.

<img src='http://making-the-internet.s3.amazonaws.com/php-array-parts.png?@2x' style='max-width:424px'>

At this point the values are hard-coded; we'll make them randomly generated in a future step.




## Retrieving values

### Print one value from the array:

```php
Liz is a <?php echo $contestants['Liz']?>
```

### Print all the values from an array:		

A [foreach](http://www.php.net/manual/en/control-structures.foreach.php) loop is used to iterate through arrays.

In the `<body>` of `raffle/index.php`

```php
<h1>Contestants</h1>

<?php
foreach($contestants as $contestant => $result) {
	echo $contestant." is a ".$result.".<br>";
}
?>
```

This loop will work its way through the `$contestants` array, one value at a time. Each iteration through, the `$contestant` variable (key) will *point to* `=>` the `$result` variable.

For example, the first time `$key` will be `"Sam"` and `$value` will be `"loser"`

The second time, `$key` will be `"Eliot"` and `$value` will be `"loser"`

...so on until we reach the end of the loop.




### Quick and dirty array printing
If you need to quickly see the contents of an array for debugging purposes, you can use the [print_r()](http://www.php.net/manual/en/function.print-r.php) function.

```php
<pre>
	<?php print_r($contestants); ?>
</pre>
```

Wrapping the `print_r()` invocation in the `<pre>` tag makes it display nicer (try it with and without to see the difference).


### Numeric keys
So far, our arrays keys have been Strings. Instead of Strings, you can also use integers.

```php
$shoppingList[0] = 'Apples';
$shoppingList[1] = 'Oranges';
$shoppingList[2] = 'Milk';
```

Or, our alternative style:

```php
$shoppingList = [
	0 => 'Apples',
	1 => 'Oranges',
	2 => 'Milk',
	];
```

When using numeric keys that start at 0 and count up, specifying the key is optional:

```php
$shoppingList = [
	'Apples',
	'Oranges',
	'Milk'
	];
```

In this example, Apples is at key position 0, Oranges at 1, Milk at 2.





## Array functions
PHP includes many functions that will help you when working with Arrays.

For example...

* If you wanted to find out how many values were in an array, there's [count()](http://www.php.net/manual/en/function.count.php).
* If you wanted to order an array, there's [sort()](http://www.php.net/manual/en/function.sort.php) (plus several other [sorting methods](http://www.php.net/manual/en/array.sorting.php)).
* If you wanted to merge two arrays together, there's [array_merge()](http://www.php.net/manual/en/function.array-merge.php).

Etc.

[See the full list of Array Functions at php.net](http://php.net/manual/en/ref.array.php)



## Scenario
Imagine you're building a commerce application. Which of the following pieces of this app might be stored in an array?

* A true/false variable indicating whether a user is logged in
* The items in a user's cart
* The total of all the items in a user's cart
