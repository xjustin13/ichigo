set(:job_template, "/usr/local/bin/bash -l -c ':job'") # FreeBSD bash
set(:output, "#{path}/log/cron.log")

every 1.day do
  rake('tmp:clear')
  command('sudo /usr/local/bin/certbot renew') if @environment == 'production'
end

every 1.week do
  command('sudo /opt/nginx/sbin/nginx -s reload')
end

every 1.year, :at=>'January 1st' do
  rake('customer:set_spending_since_last_year')
end
