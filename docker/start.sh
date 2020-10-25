#! /bin/bash

# Start cron
function start_cron_job() {
  while [ true ]
  do
    php /var/www/artisan schedule:run >> /envault-log/cron.log &
    sleep 60
  done

}

start_cron_job &

# Start Supervisor
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

# Start apache
exec apache2-foreground