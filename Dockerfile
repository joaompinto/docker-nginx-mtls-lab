#The following should work with a RHEL subscription:
#
#   FROM rhscl/nginx-118-rhel7

#FROM centos/nginx-112-centos7
FROM  centos/nginx-114-centos7
COPY etc/nginx.conf /etc/nginx/nginx.conf
COPY tmp/mydomain.com.crt /etc/ssl
COPY tmp/mydomain.com.key /etc/ssl
COPY tmp/rootCA.crt /etc/ssl
CMD ["nginx", "-g", "daemon off;"]
