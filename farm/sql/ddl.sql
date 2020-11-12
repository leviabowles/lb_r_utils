use farm_db;
drop table if exists staging_field_year_crop;
create table staging_field_year_crop (id int auto_increment key,
	field_key varchar(10),
    year_key int ,
    crop_key varchar(10),
    pushed int default 0,
    create_date datetime DEFAULT CURRENT_TIMESTAMP,
    update_date datetime ON UPDATE CURRENT_TIMESTAMP);

drop table if exists field_year_crop;
create table field_year_crop (id int auto_increment key,
	field_key varchar(10),
    year_key int ,
    crop_key varchar(10),
    create_date datetime DEFAULT CURRENT_TIMESTAMP,
    update_date datetime ON UPDATE CURRENT_TIMESTAMP);
    
    

drop table if exists staging_field_year_transaction;
create table staging_field_year_transaction(id int auto_increment key,
	field_key varchar(10),
    year_key int ,
    trans_type varchar(10),
    object_type varchar(25),
    invoice_date datetime,
    paid_date datetime,
    vendor varchar(255),
    expense_category varchar(255),
    paid_amount decimal(15,2),
    received_amount decimal (15,2),
    pushed int default 0,
    create_date datetime DEFAULT CURRENT_TIMESTAMP,
    update_date datetime ON UPDATE CURRENT_TIMESTAMP);
    
    
drop table if exists field_year_transaction;
create table field_year_transaction(id int auto_increment key,
	field_key varchar(10),
    year_key int ,
    trans_type varchar(10),
    object_type varchar(25),
    invoice_date datetime,
    paid_date datetime,
    vendor varchar(255),
    expense_category varchar(255),
    paid_amount decimal(15,2),
    received_amount decimal (15,2),
    create_date datetime DEFAULT CURRENT_TIMESTAMP,
    update_date datetime ON UPDATE CURRENT_TIMESTAMP);
    
    
drop table if exists staging_legit_transaction_objects;
create table staging_legit_transaction_objects (id int auto_increment key,
	object_type varchar(25) unique);




    
drop table if exists field;
create table field(id int auto_increment key,
	field_key varchar(10),
    field_name varchar(255),
    field_state varchar(2),
    field_county varchar(255),
    date_purchased datetime,
    price_paid decimal(15,2),
    crop_acreage decimal(15,2),
    pasture_acreage decimal(15,2),
    crp_acreage decimal(15,2),
    create_date datetime DEFAULT CURRENT_TIMESTAMP,
    update_date datetime ON UPDATE CURRENT_TIMESTAMP);
    
    
    
    
drop table if exists crop;
create table crop (id int auto_increment key,
	crop_key varchar(10),
    crop_name varchar(255),
    create_date datetime DEFAULT CURRENT_TIMESTAMP,
    update_date datetime ON UPDATE CURRENT_TIMESTAMP);
    
    

    