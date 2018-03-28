docker run --ip 10.0.0.242 --network=fabric -d --expose 20 --expose 21  --expose 65500 --expose 65515 -v /nfs/fabric:/var/ftp:ro inanimate/vsftpd-anon
