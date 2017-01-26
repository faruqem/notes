use master;
go

if (exists (select name from master.dbo.sysdatabases where ('[' + name + ']' = 'tessreports' or name = 'tessreports')))
	drop database tessreports;

go

create database tessreports;
go

use tessreports;
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

CREATE TABLE categories
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
	CONSTRAINT PK_Categories PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Categories_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Categories_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)
);
GO

CREATE TABLE frameworks
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
	CONSTRAINT PK_Frameworks PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Frameworks_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Frameworks_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)
);
GO

CREATE TABLE types --report, utility, customscreen
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
	CONSTRAINT PK_Types PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Types_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Types_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)
);
GO

--drop table reports
CREATE TABLE reports 
(
	id int IDENTITY(1,1) NOT NULL, 
	name varchar(255) NOT NULL,
	description text NULL,
	tess_report_id varchar(255) NOT NULL,
	definition_file varchar(255) NOT NULL,
	sql_proc varchar(255) NOT NULL,
	[database] varchar(255) NULL,
	keywords varchar(255) NULL,
	notes_general text NULL,
	notes_technical text NULL,
	category_id int NOT NULL,
	framework_id int NOT NULL,
	type_id int NOT NULL,
	schedulable tinyint NOT NULL, --0 or 1
	inhouse tinyint NOT NULL, --0 or 1
	verified tinyint NOT NULL, --0 or 1
	published tinyint NOT NULL, --0 or 1
	first_implementation_dt datetime not null,
	last_update_dt datetime not null,
	discontinued tinyint not null, --0 or 1
	active tinyint not null, --0 or 1
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL
   	CONSTRAINT PK_Reports PRIMARY KEY NONCLUSTERED (id),     
	CONSTRAINT FK_Reports_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE, 
	CONSTRAINT FK_Reports_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id),
	CONSTRAINT FK_Reports_Categories FOREIGN KEY (category_id)     
		REFERENCES categories (id)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE, 
	CONSTRAINT FK_Reports_Types FOREIGN KEY (category_id)     
		REFERENCES types (id)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE, 
	CONSTRAINT FK_Reports_Frameworks FOREIGN KEY (framework_id)     
		REFERENCES frameworks (id)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE,      
);

GO    

--drop table screenshots
CREATE TABLE screenshots 
(
	id int IDENTITY(1,1) NOT NULL, 
	report_id INT NOT NULL,
	file_name varchar(255) NOT NULL,
	file_type varchar(30) NOT NULL,
	caption varchar(255) NOT NULL,
	description varchar(255) null,
	active tinyint NOT NULL, --0 or 1
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL
	CONSTRAINT PK_Screenshots PRIMARY KEY NONCLUSTERED (id)
	CONSTRAINT FK_Screenshots_Reports_Users FOREIGN KEY (report_id)     
		REFERENCES reports (id),    
	CONSTRAINT FK_Screenshots_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Screenshots_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)
);

GO


CREATE TABLE revisions 
(
	id int IDENTITY(1,1) NOT NULL, 
	report_id INT NOT NULL,
	rev_date datetime NOT NULL,
	reason text NOT NULL,
	active tinyint NOT NULL, --0 or 1
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL
	CONSTRAINT PK_Revisions PRIMARY KEY NONCLUSTERED (id)
	CONSTRAINT FK_Revisions_Reports FOREIGN KEY (report_id)     
		REFERENCES reports (id),
	CONSTRAINT FK_Revisions_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Revisions_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)
);

GO

CREATE TABLE comments --multiple comments by the same user to the same report is permitted
(
	id int IDENTITY(1,1) NOT NULL, 
	report_id INT NOT NULL,
	user_id INT NOT NULL,
	comment_date datetime NOT NULL,
	comment text NOT NULL,
	active tinyint NOT NULL, --0 or 1
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL,
	deleted_at datetime,
	CONSTRAINT PK_Comments PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Comments_Reports FOREIGN KEY (report_id)     
		REFERENCES reports (id),     
	CONSTRAINT FK_Comments_Users FOREIGN KEY (user_id)     
		REFERENCES users (id),
	CONSTRAINT FK_Comments_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Comments_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)     
);

GO


CREATE TABLE ratings --multiple ratings and favorite marking by the same user to the same report is NOT permitted
(
	id int IDENTITY(1,1) NOT NULL, 
	report_id INT NOT NULL,
	user_id INT NOT NULL,
	rating tinyint NOT NULL,
	favorite tinyint NULL,
	active tinyint NOT NULL, --0 or 1
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL,
	deleted_at datetime,
	CONSTRAINT PK_Ratings PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Ratings_Reports FOREIGN KEY (report_id)     
		REFERENCES reports (id),     
	CONSTRAINT FK_Ratings_Users FOREIGN KEY (user_id)     
		REFERENCES users (id),
	CONSTRAINT FK_Ratings_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Ratings_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)      
);

GO

CREATE TABLE glossaries
(
	id int IDENTITY(1,1) NOT NULL, 
	term varchar(255) NOT NULL,
	definition text NOT NULL,
	active tinyint NOT NULL, --0 or 1
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL
	CONSTRAINT PK_Glossaries PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Glossaries_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Glossaries_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id) 
);
GO

--------------------------------------------------------
CREATE TABLE tessareas
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
	CONSTRAINT PK_Tessareas PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Tessareas_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Tessareas_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)
);
GO

CREATE TABLE report_tessarea
(
	id int IDENTITY(1,1) NOT NULL, 
	report_id int NOT NULL,
	tessarea_id int NOT NULL,
	created_at datetime NULL,
	updated_at datetime NULL,
	created_by int  NOT NULL,
	updated_by int NULL
	CONSTRAINT PK_Report_tessarea PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Report_tessarea_Reports FOREIGN KEY (report_id)     
		REFERENCES Reports (id),
	CONSTRAINT FK_Report_tessarea_Tessareas FOREIGN KEY (tessarea_id)     
		REFERENCES Tessareas (id),
	CONSTRAINT FK_Report_tessarea_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Report_tessarea_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)
);
GO

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
	CONSTRAINT PK_Roles PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Roles_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Roles_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)
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
		REFERENCES Users (id),
	CONSTRAINT FK_Role_user_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Role_user_Updated FOREIGN KEY (updated_by)     
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
	CONSTRAINT PK_Appobjects PRIMARY KEY NONCLUSTERED (id),
	CONSTRAINT FK_Appobjects_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Appobjects_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)
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
		REFERENCES Roles (id),
	CONSTRAINT FK_Appobject_role_Users_Created FOREIGN KEY (created_by)     
		REFERENCES Users (id),     
	CONSTRAINT FK_Appobject_role_Users_Updated FOREIGN KEY (updated_by)     
		REFERENCES Users (id)
);
GO