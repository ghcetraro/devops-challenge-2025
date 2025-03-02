# README

# How to deploy?

1.- Create a ssh tunnel, use ec2 jumper

Host jumper
  Hostname 170.91.82.1
  IdentityFile ~/.ssh/config.d.key/private.pem
  User ec2-user
  Port 22
  LocalForward 5432 <database url>:5432

2.- Modify host and point to local

	main.tf

		host_provider = "127.0.0.1"

3.- Deploy 

	terraform apply