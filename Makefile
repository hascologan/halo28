projectname = <"Project Name">
builddate = $(shell date +%FT%T%Z)

all: pemkey password.json

password.json:
	@echo "Generating new passwords"
	@mkdir passwords
	@echo "{\n\t\"admin_pwd\": \"$(shell openssl rand -base64 48 | tr -C -d "[:alnum:]" | head -c 24)\",\n\t\"ds_pwd\": \"$(shell openssl rand -base64 48 | tr -C -d "[:alnum:]" | head -c 24)\"\n}" > passwords/$@

pemkey:
	@echo "Generating pem key for setting up EC2 servers"
	@mkdir pemkeys
	@ssh-keygen -m PEM -f pemkeys/$(projectname).pem -q -N "" -C $(projectname)
	@echo "Pem keys have been created"
