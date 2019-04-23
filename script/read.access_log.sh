


zgrep "UploadManualeServlet" apache_access_log.20181012001501.gz | head -10 | awk '{print $1" "$4$5" "$6" "$7" "$8" "$9" "$10" "$11}' | column -t

1 - ip
2 - remote log name
3 - remote user
4,5 - Data con separatori []
request:
- 6 http method (get/post)
- 7 URL
- 8 target
9 - HTTP CODE
10 - dimensione request
11 - tempo in secondi

LogFormat "%h %l %u %t \"%r\" %>s %b %T" common
https://httpd.apache.org/docs/2.4/mod/mod_log_config.html#customlog
