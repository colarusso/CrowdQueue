# CrowdQueue
An open source tool for gatherings to discover what their attendees' care about. 

A live instance can be found at: [CrowdQueue.org](http://crowdqueue.org)

Install Instructions
-----
1. Download the *master* branch of this repo to a server running [php](http://php.net/) and [mySQL](https://www.mysql.com/).
2. Create a mySQL database and user for use by this web app.
3. Import the structure found in `sql\dbsetup.sql` to your new database.
3. Edit `php/functions.php`, replacing the placholder info on the `$dbh` line to reflect the database and user you just created. 
4. That's it. You're ready to start crowdsourcing queues of content.

License
----
[Mostly MIT](https://github.com/colarusso/CrowdQueue/blob/master/licence.md). 
