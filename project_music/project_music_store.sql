create database music_store_db;
use music_store_db;

-- Creating the Employee table
drop table if exists employee;
create table if not exists employee (employee_id int primary key,
    last_name varchar(50),
    first_name varchar(50),
    title varchar(50),
    reports_to varchar(20),
    levels varchar(5),
    birthdate text,
    hire_date text,
    address varchar(50),
    city varchar(50),
    state varchar(50),
    country varchar(50),
    postal_code varchar(50),
    phone varchar(50),
    fax varchar(50),
    email varchar(100));
    
    -- Creating the Customer table
create table if not exists customer (
	customer_id int not null primary key auto_increment,
    first_name varchar(20),
    last_name varchar(20),
    company varchar(50),
    address varchar(255),
    city varchar(50),
    state varchar(20),
    country varchar(50),
    postal_code varchar(50),
    phone varchar(255),
    fax varchar(255),
    email varchar(255),
    support_rep_id int
);
# Adding FOREIGN KEY------
alter table customer add constraint fk_customer_support_rep_id
foreign key (support_rep_id) references employee(employee_id) on update cascade on delete cascade;

-- Creating the Invoice table
create table if not exists invoice (
	invoice_id int not null primary key,
    customer_id int,
    invoice_date text,
    billing_address varchar(100),
    billing_city varchar(50),
    billing_state varchar(50),
    billing_country varchar(50),
    billing_postal_code varchar(50),
    postal_code varchar(50),
    total decimal(10,2)
);
# Adding FOREIGN KEY------
alter table invoice add constraint fk_customer_customer_id
foreign key (customer_id) references customer(customer_id) on update cascade on delete cascade;

-- Create artist table
create table if not exists artist (
	artist_id int not null primary key,
    name text
);

-- Create album table
create table if not exists album (
	album_id int not null primary key,
    title text,
    artist_id int 
);
# Adding FOREIGN KEY------
alter table album add constraint fk_album_artist_id
foreign key (artist_id) references artist(artist_id) on update cascade on delete cascade;

-- Create genre table
create table if not exists genre (
	genre_id int not null primary key,
    name text
);

-- Create media_type table
create table if not exists media_type (
	media_type_id int not null primary key,
    name text
);

-- Creating the track table
create table if not exists track (
	track_id int primary key,
    name text,
    album_id int,
    media_type_id int,
    genre_id int,
    composer text,
    milliseconds text,
    bytes text,
    unit_price decimal(10,2)
);
# Adding FOREIGN KEY------
alter table track add constraint fk_track_media_type_id
foreign key (media_type_id) references media_type(media_type_id) on update cascade on delete cascade;
alter table track add constraint fk_track_genre_id
foreign key (genre_id) references genre(genre_id) on update cascade on delete cascade;
alter table track add constraint fk_track_album_id
foreign key(album_id) references album(album_id) on update cascade on delete cascade;

-- Create Invoice_line table
create table if not exists invoice_line (
	invoice_line_id int not null primary key,
    invoice_id int,
    track_id int,
    unit_price decimal(10,2),
    quantity int
);
set foreign_key_checks=0;
# Adding FOREIGN KEY------
alter table invoice_line add constraint fk_invoice_line_invoice_id
foreign key (invoice_id) references invoice(invoice_id) on update cascade on delete cascade;
alter table invoice_line add constraint fk_invoice_line_track_id
foreign key (track_id) references track(track_id) on update cascade on delete cascade;
set foreign_key_checks=1;

-- Create playlist table
create table if not exists playlist (
	playlist_id int not null primary key,
    name text
);

-- Create playlist_track table
create table if not exists playlist_track (
	playlist_id int,
    track_id int
);
set foreign_key_checks=0;
# Adding FOREIGN KEY------
alter table playlist_track add constraint fk_playlist_track_playlist_id
foreign key (playlist_id) references playlist(playlist_id) on update cascade on delete cascade;
alter table playlist_track add constraint fk_playlist_track_track_id
foreign key (track_id) references track(track_id) on update cascade on delete cascade;
set foreign_key_checks=1;
