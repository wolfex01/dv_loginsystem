CREATE TABLE IF NOT EXISTS `login_data` (
	`identifier` varchar(50) NOT NULL,
  	`name` varchar(24) NOT NULL,
  	`pass` varchar(90) NOT NULL,
	`date` varchar(50) NOT NULL,

	PRIMARY KEY (`identifier`)
);