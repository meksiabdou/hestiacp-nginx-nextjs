server {
    listen      %ip%:%proxy_port%;
    server_name %domain_idn% %alias_idn%;
    error_log  /var/log/%web_system%/domains/%domain%.error.log error;

    include %home%/%user%/conf/web/%domain%/nginx.forcessl.conf*;

    # ✅ Serve Let's Encrypt challenge directly
    location ~ /\.(?!well-known\/|file) {
            deny all;
            return 404;
    }

    location / {
        proxy_pass http://unix:%home%/%user%/web/%domain%/nodeapp/app.sock:$request_uri;
    }

    location /error/ {
        alias  %home%/%user%/web/%domain%/document_errors/;
    }

    location @fallback {
        proxy_pass http://unix:%home%/%user%/web/%domain%/nodeapp/app.sock:$request_uri;
    }

    location ~ /\.ht    {return 404;}
    location ~ /\.svn/  {return 404;}
    location ~ /\.git/  {return 404;}
    location ~ /\.hg/   {return 404;}
    location ~ /\.bzr/  {return 404;}

    include %home%/%user%/conf/web/%domain%/nginx.conf_*;
}
