docker run --ip 10.0.0.242 --network=fabric -d -p 20-21:20-21 -p 65500-65515:65500-65515 -v /nfs/fabric:/var/ftp:ro inanimate/vsftpd-anon
