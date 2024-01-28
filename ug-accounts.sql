CREATE TABLE `accounts` (
	`name` VARCHAR(60) NOT NULL,
	`label` VARCHAR(100) NOT NULL,
	`shared` INT NOT NULL,
	PRIMARY KEY (`name`)
) ENGINE=InnoDB;

CREATE TABLE `accountsdata` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`accountName` VARCHAR(100) DEFAULT NULL,
	`money` INT NOT NULL,
	`owner` VARCHAR(60) DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `index_accountdata_accountName_owner` (`accountName`, `owner`),
	INDEX `index_accountdata_accountName` (`accountName`)
) ENGINE=InnoDB;
