# Data Stack Vars
db_size                   = 10
db_engine                 = "mysql"
db_instance_class         = "db.t2.micro"
db_name                   = "dev_db"
db_user                   = "dev_db_user"
db_password               = "dev_db_pass"
db_storage_type           = "gp2"
allow_rds_minor_upgrades  = "true"

# Web Layer Vars
web_server_count          = "2"
web_server_instance_type  = "t2.large"
