external_url 'https://gitlab.mattwahner.com:8000'
letsencrypt['enable'] = true
letsencrypt['contact_emails'] = ['mattwahner@gmail.com']

registry['enable'] = true
registry_external_url 'https://gitlab.mattwahner.com:4567'
registry_nginx['ssl_certificate'] = '/etc/gitlab/ssl/gitlab.mattwahner.com.crt'
registry_nginx['ssl_certificate_key'] = '/etc/gitlab/ssl/gitlab.mattwahner.com.key'