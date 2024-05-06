# README

This project demonstrates a solution to build a set of analytics based off of a user's live search inputs in an efficient and scalable manner. The solution I've come up with utilizes Sidekiq and Redis. The flow of the application is as follows:
1. User enters the name of an article.
2. Every 500ms since the last input change/key stroke of the search bar, `/app/javascript/controllers/article_search_controller.js` makes a request to `index` action of the `articles_controller.rb`
3. If a search query is present, the `index` action retrieves articles with a similar title. It also saves the user's email, the query, and timestamp that the query was made to the Rails cache (set up with Redis for fast and lightweight caching).
4. If a user updates their search query within a minute, the relevant articles are retrieved, and the existing cached query value is updated with the new search query while updating it's timestamp. This allows us to overwrite the outdated value and timestamp before saving it to the database.
5. A cron job (`app/config/sideqik_schedule.yml`) is set up that runs the `/app/jobs/redis_subscriber_job.rb` after every minute. `RedisSubscriberJob` looks for all the keys with the `User:` prefix (as set in the `index` action). After a bit of string manipulation, we also retrieve the search query and the timestamp. If 30 or more seconds have passed since the user made their last search query, we save the email and search query into an array, and delete the key-value pair from the redis cache. Once all the emails and queries have been retrieved from redis, all the `SearchAnalytic` records are created in a batch from the array that saved the email and query.


To retrieve the analytics, it would be better to have the data warehouse set up for efficient reads and complex queries. But due to the time-constraint, I set up a job that does a relatively complex query to retrieve the analytics, so the main thread won't be blocked if there's a relatively large number of records that need to be processed. The data is saved per user (via email) in the database, however the data is displayed in a grouped manner since it's an overall overview. 
Here's the flow:
1. The `index` action in `SearchAnalyticsController` starts an async job. The job performs a query to group the search queries and saves the result to redis.
2. The `results` action reads the analytics from the redis cache and makes a json response with the analytics
3. The `/app/javascript/controllers/article_search_controller.js` makes a request to the `results` action, and updates the `index.html.erb` of `search_analytics` with the analytics.

