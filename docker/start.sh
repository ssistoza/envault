#! /bin/bash

# Start Cron Job
* * * * * php /var/www/artisan schedule:run 1>> /dev/null 2>&1
# Start Supervisor
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

# Start apache
exec apache2-foreground