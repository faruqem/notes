## Goal
It's time for an exercise that will combine *variables*, *if* constructs and *functions* all together.

The general idea for this exercise is simple: **create an app that tells time**.
Depending on when in the day a user visits your page, they will see different results.

[Final working demo...](http://php.wcc-hosting.com/clock)

## Specs

If your user visits your page between 5:00am and 10:59am in the morning, they should see this image:

```xml
http://making-the-internet.s3.amazonaws.com/php-morning.png
```

<img src='http://thewc.co.s3.amazonaws.com/challenges/php-morning.png' style='width:300px'>




If they visit between 11:00am and 3:59pm in the afternoon, they should see this image:

```xml
http://making-the-internet.s3.amazonaws.com/php-afternoon.png
```

<img src='http://making-the-internet.s3.amazonaws.com/php-afternoon.png' style='width:300px'>




If they visit between 4:00pm and 7:59pm in the evening, they should see this image:

```xml
http://making-the-internet.s3.amazonaws.com/php-evening.png
```

<img src='http://making-the-internet.s3.amazonaws.com/php-evening.png' style='width:300px'>



Finally, if they visit between 8:00pm and 4:59am in the evening, they should see this image:

```xml
http://making-the-internet.s3.amazonaws.com/php-night.png
```

<img src='http://making-the-internet.s3.amazonaws.com/php-night.png' style='width:300px'>



## Background color
The background color of the page should match the scenery image they're seeing.
For example, if it's morning time, the background color should be a light purple (`#856f86`).

<img src='http://making-the-internet.s3.amazonaws.com/php-colors.png'>

For the purposes of easy cutting and pasting, here are the above colors in text form:
```
#865f86
#2c87c8
#c7b02f
#180629
```

## Timezone

If your timezone is off, check out [date_default_timezone_set()](http://us3.php.net/manual/en/function.date-default-timezone-set.php) and the [list of supported timezones](http://us3.php.net/manual/en/timezones.php).
