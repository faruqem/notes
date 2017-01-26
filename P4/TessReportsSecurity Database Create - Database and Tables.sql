use master;
go

if (exists (select name from master.dbo.sysdatabases where ('[' + name + ']' = 'tessreportssecurity' or name = 'tessreportssecurity')))
	drop database tessreportssecurity;

go

create database tessreportssecurity;
go

use tessreportssecurity;
go

CREATE TABLE users 
(
	id int IDENTITY(1,1) NOT NULL, 
	name varchar(255) NOT NULL,
	email varchar(255) NOT NULL,
	password varchar(255) NOT NULL,
	remember_token varchar(100) NULL,
	created_at datetime NULL,
	updated_at datetime NULL
	CONSTRAINT PK_Users PRIMARY KEY NONCLUSTERED (id)
);

GO

CREATE TABLE password_resets 
(
	email varchar(255) NOT NULL,
	token varchar(255) NOT NULL,
	created_at datetime NULL
);

GO

 


--------------------------------------------------------

CREATE TABLE roles
(
	id int IDENTITY(1,1) NOT NULL, 
	name varchar(255) NOT NULL,
	description text NOT NULL,
	[default] tinyint NOT NULL, --0 or 1
	active tinyint NOT NULL, --0 or 1
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL
	CONSTRAINT PK_Roles PRIMARY KEY NONCLUSTERED (id)
);
GO

CREATE TABLE role_user
(
	id int IDENTITY(1,1) NOT NULL, 
	role_id int NOT NULL,
	user_id int NOT NULL,
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL
	CONSTRAINT PK_Role_user PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Role_user_Roles FOREIGN KEY (role_id)     
		REFERENCES Roles (id),
	CONSTRAINT FK_Role_user_Users FOREIGN KEY (user_id)     
		REFERENCES Users (id)
);
GO


CREATE TABLE appobjects
(
	id int IDENTITY(1,1) NOT NULL, 
	name varchar(255) NOT NULL,
	description text NOT NULL,
	active tinyint NOT NULL, --0 or 1
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL
	CONSTRAINT PK_Appobjects PRIMARY KEY NONCLUSTERED (id)
);
GO

CREATE TABLE appobject_role
(
	id int IDENTITY(1,1) NOT NULL, 
	appobject_id int NOT NULL,
	role_id int NOT NULL,
	[create] tinyint NOT NULL,  --0 or 1
	[read] tinyint NOT NULL,  --0 or 1
	[update] tinyint NOT NULL,  --0 or 1
	[delete] tinyint NOT NULL,  --0 or 1
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL
	CONSTRAINT PK_Appobject_role PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Appobject_role_appobjects FOREIGN KEY (appobject_id)     
		REFERENCES Appobjects (id),
	CONSTRAINT FK_Appobject_role_Roles FOREIGN KEY (role_id)     
		REFERENCES Roles (id)
);
GO