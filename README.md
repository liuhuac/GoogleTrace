# GoogleTrace
Populate google trace records in mysql on palmetto

1. install gsutil
2. download trace bucket
   gsutil cp -r gs://clusterdata-2011-2 .
3. download and install mysql
   wget http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.8.tar.gz
   cmake .
   make
4. run gensql.sh to create tables
   bash gensql.sh | mysql -h [host] -u [uname] -p [database]

