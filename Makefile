APP_SERVICE_NAME:=isuumo.nodejs.service
DATE:=`date +%s`

.SILENT:

deploy: ## update and reload systemd, nginx config files, rotate logs!
	$(MAKE) copy_conf
	$(MAKE) rotate_log

# mysqlは結構時間かかるので必要な時だけ。
copy_mysql_conf: ## update and restart mysql config files
	$(MAKE) __copy_mysql_conf

copy_conf: ## update and reload systemd, nginx config files
	$(MAKE) __copy_system_conf
	$(MAKE) __copy_nginx_conf

define __rotate_log

endef
export __rotate_log
rotate_log: ## rotate logs of nginx, mysql logs
	echo "\e[32mRotate logs\e[m"

	sudo cp /var/log/nginx/access.log /var/log/nginx/access.log.$(DATE)
	echo > /var/log/nginx/access.log
	sudo cp /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow.log.$(DATE)
	echo > /var/log/mysql/mysql-slow.log
alp: ## alp /var/log/nginx/access.log
	sudo cat /var/log/nginx/access.log | alp ltsv -c alp_config.yml | less -S

__copy_nginx_conf:
	echo "\e[32mCopy nginx.conf\e[m"
	sudo cp ./nginx.conf /etc/nginx/nginx.conf
	sudo nginx -t
	sudo nginx -s reload || :

__copy_mysql_conf:
	echo "\e[32mCopy mysql.cnf\e[m"
	sudo cp ./mysql.cnf /etc/mysql/my.cnf
	sudo mysqld --verbose --help > /dev/null
	sudo systemctl restart mysql
	sudo systemctl --no-pager status mysql

__copy_system_conf:
	echo "\e[32mCopy systemd files\e[m"
	sudo cp ./systemd/* /etc/systemd/system/
	sudo systemctl daemon-reload
	sudo systemctl restart $(APP_SERVICE_NAME)
	sudo systemctl --no-pager status $(APP_SERVICE_NAME)

install_essentials: ## install essential tools!
	echo "\e[32mInstall tools via apt\e[m"
	sudo apt install -y unzip tig htop

	echo "\e[32mInstall alp\e[m"
	curl --silent -L https://github.com/tkuchiki/alp/releases/download/v1.0.3/alp_linux_amd64.zip > /tmp/alp.zip
	unzip /tmp/alp.zip -d /tmp
	sudo mv /tmp/alp /usr/bin/alp
	sudo chmod +x /usr/bin/alp

	echo "\e[32mInstall pt-query-digest\e[m"
	curl --silent -L http://percona.com/get/pt-query-digest > /tmp/pt-query-digest
	sudo mv /tmp/pt-query-digest /usr/bin/pt-query-digest
	sudo chmod +x /usr/bin/pt-query-digest

	echo "\e[32mSetting git\e[m"
	git config --global user.name "Kwappa Penguin"
	git config --global user.email "kp@example.com"
	git config --global pull.rebase true

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
