drop index idx_location;
drop index idx_charge;
drop index idx_rental;
drop index idx_reservation;
drop index idx_vehicle;
drop table charge;
drop table reservation;
drop table rental;
drop table vehicle;
drop table location;
drop table customer;
drop table membership;
drop table discount;
drop table license;

create table license(
    license_id integer GENERATED ALWAYS AS IDENTITY,
    license_number varchar(256) not null,
    state varchar(64) not null,
    age integer not null,
    primary key(license_id),
    CONSTRAINT dln_unique UNIQUE (license_number)
);

create table discount(
    discount_id integer GENERATED ALWAYS AS IDENTITY,
    percent_off numeric(3) not null,
    description varchar(512) not null,
    primary key(discount_id)
);

create table membership(
    membership_id integer GENERATED ALWAYS AS IDENTITY,
    group_name varchar(256) not null,
    discount_id integer not null,
    foreign key(discount_id) references discount(discount_id),
    primary key(membership_id),
    CONSTRAINT mid_unique UNIQUE (group_name)
);

create table customer (
    customer_id integer GENERATED ALWAYS AS IDENTITY,
    address varchar(256) not null,
    name varchar(256) not null,
    license_id integer not null,
    membership_id integer not null,
    foreign key(license_id) references license(license_id),
    foreign key(membership_id) references membership(membership_id),
    primary key(customer_id)
);

create table location(
    location_id integer GENERATED ALWAYS AS IDENTITY,
    street varchar(128) not null,
    city varchar(128) not null,
    state varchar(128) not null,
    zip integer not null,
    primary key(location_id)
);
CREATE INDEX idx_location ON location (city);

create table vehicle (
    vehicle_id integer GENERATED ALWAYS AS IDENTITY,
    make varchar(64) not null,
    model varchar(64) not null,
    year number(4) not null,
    color varchar(16) not null,
    type varchar(16) not null,
    vin varchar(17) not null,
    odo integer not null,
    location_id integer not null,
    foreign key(location_id) references location(location_id),
    primary key(vehicle_id)
);
CREATE INDEX idx_vehicle ON vehicle (location_id);

create table rental(
    rental_id integer GENERATED ALWAYS AS IDENTITY,
    taken date not null,
    returned date,
    rate numeric(10,4) not null,
    customer_id integer not null,
    vehicle_id integer not null,
    foreign key(customer_id) references customer(customer_id),
    foreign key(vehicle_id) references vehicle(vehicle_id),
    primary key(rental_id)
);
CREATE INDEX idx_rental ON rental (customer_id, vehicle_id, returned);

create table reservation (
    reservation_id integer GENERATED ALWAYS AS IDENTITY,
    created date not null,
    customer_id integer not null,
    vehicle_id integer not null,
    foreign key(customer_id) references customer(customer_id),
    foreign key(vehicle_id) references vehicle(vehicle_id),
    primary key(reservation_id)
);
CREATE INDEX idx_reservation ON reservation (customer_id, vehicle_id, created);

create table charge(
    charge_id integer GENERATED ALWAYS AS IDENTITY,
    fuel numeric(10,4) not null,
    dropoff numeric(10,4) not null,
    insurance numeric(10,4) not null,
    other numeric(10,4) not null,
    complete number(1) default 0 not null,
    rental_id integer not null,
    foreign key(rental_id) references rental(rental_id),
    primary key(charge_id)
);
CREATE INDEX idx_charge ON charge (rental_id, complete);

INSERT INTO location VALUES (DEFAULT,'Blackheath Lane','Fayetteville','Virginia','68254');
INSERT INTO location VALUES (DEFAULT,'Cavell Vale','Las Vegas','Oklahoma','55672');
INSERT INTO location VALUES (DEFAULT,'Blackheath Tunnel','London','Tennessee','63955');
INSERT INTO location VALUES (DEFAULT,'Beaconsfield Tunnel','Henderson','Vermont','95558');
INSERT INTO location VALUES (DEFAULT,'Bury Tunnel','Stockton','Nevada','12998');
INSERT INTO location VALUES (DEFAULT,'Kimberley Avenue','Tokyo','Maine','18854');
INSERT INTO location VALUES (DEFAULT,'Church Tunnel','Seattle','Iowa','25829');
INSERT INTO location VALUES (DEFAULT,'Chancellor Pass','Richmond','Missouri','20365');
INSERT INTO location VALUES (DEFAULT,'Geffrye Pass','Baltimore','New Jersey','41073');
INSERT INTO location VALUES (DEFAULT,'Birkenhead Lane','Moreno Valley','Vermont','62480');
INSERT INTO location VALUES (DEFAULT,'Gate Vale','Fayetteville','Maryland','43004');
INSERT INTO location VALUES (DEFAULT,'Yorkshire Walk','Laredo','Utah','77297');
INSERT INTO location VALUES (DEFAULT,'Charterhouse Alley','Bridgeport','Mississippi','59033');
INSERT INTO location VALUES (DEFAULT,'Falconberg Lane','Bakersfield','New Mexico','80074');
INSERT INTO location VALUES (DEFAULT,'Blean Alley','Lisbon','Iowa','70224');
INSERT INTO location VALUES (DEFAULT,'Liverpool Grove','Springfield','Michigan','56224');
INSERT INTO location VALUES (DEFAULT,'King Pass','Dallas','Kentucky','77492');
INSERT INTO location VALUES (DEFAULT,'Bacton Vale','Columbus','Nevada','11034');
INSERT INTO location VALUES (DEFAULT,'Cloth Hill','Amarillo','Pennsylvania','59680');
INSERT INTO location VALUES (DEFAULT,'Addison Alley','Bucharest','California','51087');

INSERT INTO vehicle VALUES (DEFAULT,'Mazda','CX5','2015','Ruby','truck','fiiLRbNzRLM0jR3hN','130756','13');
INSERT INTO vehicle VALUES (DEFAULT,'Dacia','Logan','1961','Dark red','truck','vNHquoQ1CP5pRfS22','244720','9');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M6','1979','Magenta','van','pKejypP7XfOFIhh69','262634','9');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','X1','2014','Ruby','coup','IWESfDUGDFdvSOkps','450121','17');
INSERT INTO vehicle VALUES (DEFAULT,'Dacia','Logan','2010','Lavender','van','TL1DvtaxtpTLo2b38','46120','17');
INSERT INTO vehicle VALUES (DEFAULT,'Fiat','Argo','1971','Maroon','van','JCunBYYY7L2dDRWD8','277503','9');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i30','1990','Turquoise','coup','yofmJm3aumrpJrR4w','346396','20');
INSERT INTO vehicle VALUES (DEFAULT,'Mazda','3','1986','Fuchsia','sedan','NIsJyEAMdNt3wxi9D','152342','20');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i20','1984','Cerise','sedan','rXU8u30Zm5eKQ5hqd','339766','16');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i40','1961','Sky blue','van','WmIalZRbxHrqNtT3d','78365','11');
INSERT INTO vehicle VALUES (DEFAULT,'Ford','Focus','2011','Fuchsia','truck','4IVuVqeLYXQr9AgMt','240285','16');
INSERT INTO vehicle VALUES (DEFAULT,'Mitsubishi','Outlander','2022','Gold','van','h0BEvkPAbrQ6qbbNe','407143','19');
INSERT INTO vehicle VALUES (DEFAULT,'Mitsubishi','Lancer','1972','Barbie Pink','truck','FSjS9oLKGxzcGnxBq','274088','12');
INSERT INTO vehicle VALUES (DEFAULT,'Fiat','Panda','1976','Lime','truck','eblIbDrqNqRpscCFv','292999','13');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','V8','2007','Brown','truck','e5zEkCQMqeMkBotHw','445817','5');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','R8','1982','Carmine','sedan','ecXv1GQCH6H1lmnBc','18839','12');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','R8','1991','Capri','coup','8eNDog0j3Gk3byY6h','454217','15');
INSERT INTO vehicle VALUES (DEFAULT,'Mazda','3','1976','coral','truck','36IaqugcR3lC9caRS','360643','16');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','X3','1967','Purple','sedan','7zNTNxO3jvkrIMWDa','79690','17');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M2','2015','Maroon','coup','7buRW2sjgs4SJEGXJ','207391','3');
INSERT INTO vehicle VALUES (DEFAULT,'Mazda','3','1996','Fuchsia','coup','r1SwAZY69QVemN21I','302965','10');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i40','2007','Green','coup','tIubtw6kSpBZwgSgW','78287','4');
INSERT INTO vehicle VALUES (DEFAULT,'Mitsubishi','Outlander','2015','Beige','sedan','biBsNZvdWQRnfPdZ4','162716','5');
INSERT INTO vehicle VALUES (DEFAULT,'Citroen','Nemo','1988','Camel','van','YIREgN66cSO41EPQ5','211005','11');
INSERT INTO vehicle VALUES (DEFAULT,'Ford','Mustang','2015','Lavender','truck','8Mn7gGdzwzRdZ0DVr','19512','11');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','R8','1990','Lime','truck','g5zKChN7shAS96MuE','41156','3');
INSERT INTO vehicle VALUES (DEFAULT,'Ford','Mustang','2009','Champagne','van','Ly6F166UVAKoptSDf','349616','10');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M5','1962','coral','van','Z7AUyAVne1sR21lD7','317931','6');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M2','1966','Camel','sedan','QyRJndsKkb96AgAzB','92181','1');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Q6','2008','Fuchsia','truck','FEKuXAlDZiLEd1Y9G','142876','10');
INSERT INTO vehicle VALUES (DEFAULT,'Ford','Fiesta','1967','Carmine','sedan','FNdXJn8jJhYiaMaX3','303123','1');
INSERT INTO vehicle VALUES (DEFAULT,'Opel','Insignia','2007','Sky blue','van','pVaF2I8OiSwIqP4Me','162486','3');
INSERT INTO vehicle VALUES (DEFAULT,'Fiat','Panda','1987','Orange','coup','OVHGah39xeRieRZaT','437709','9');
INSERT INTO vehicle VALUES (DEFAULT,'Mazda','CX5','1974','Magenta','truck','QNBdJ9Qb0ox0IHu3I','443712','17');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Q7','2000','Sky blue','sedan','HxKVAB9DdKU2gneAH','320483','2');
INSERT INTO vehicle VALUES (DEFAULT,'Fiat','Tipo','1995','Auburn','van','FTka8QKH3CLGF0nxx','325495','15');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','R8','1961','Magenta','van','gWaRA5CBl4rYmf3Ku','312814','6');
INSERT INTO vehicle VALUES (DEFAULT,'Ford','Kuga','2017','Dark red','coup','vhxtsdEUxb3t02GJE','248710','1');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Cabriolet','1985','Red','coup','Q9n7sfjbcOYPS2amE','414413','8');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','A5','1986','Azure','coup','0g1DZlYtdcdaWF6US','189495','1');
INSERT INTO vehicle VALUES (DEFAULT,'Kia','Soul','2015','Maroon','van','UUFDzVPIx28sYCnAg','409782','6');
INSERT INTO vehicle VALUES (DEFAULT,'Ford','Fiesta','1971','Champagne','sedan','HhGxQD3VtFQSpoGOS','279348','12');
INSERT INTO vehicle VALUES (DEFAULT,'Fiat','500','1999','Dark Red','coup','W7NiImk8YryJVhyEW','328727','19');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','R8','2004','Rosegold','sedan','3JhICNMGF3GqwlcpT','137109','1');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Cabriolet','1965','Gray','coup','PPWn9gw40OdD0WelD','123423','18');
INSERT INTO vehicle VALUES (DEFAULT,'Kia','Soul','1983','Dark Red','sedan','XjO9n6HJOw7zcGXTw','467628','5');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M3','1998','Dark Red','van','CrXpgpM15l6i4NRV4','311548','17');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i30','2008','Green','van','koqgF4owSlPtdrGu8','265727','1');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i40','2007','Magenta','sedan','r0V45biIQ5BfU0rRw','306132','12');
INSERT INTO vehicle VALUES (DEFAULT,'Fiat','Tipo','1998','Olive','truck','wDoyot5l3XET1WJql','106373','11');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Q7','1975','Azure','sedan','8QGCBQ52IJY4TlMG4','219219','16');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i35','2020','Cerise','van','9NJXhIW0pqczj1GIb','358283','5');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M6','2008','Fuchsia','truck','UMNKLCAnpCDvflABD','323515','20');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M2','1977','coral','truck','hNBskrmkYM6JpdocL','450525','10');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','Elantra','1983','Rosegold','truck','soqzsAn0qoz94FVaK','55468','16');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Q5','2014','Black','coup','FatSGlGyA2C5vpMST','494308','8');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','Elantra','1989','Magenta','coup','MzsJ0UeZhnj3hjDtK','450829','4');
INSERT INTO vehicle VALUES (DEFAULT,'Fiat','500','1991','Olive','sedan','iYVcyxmPp4wXoJhig','110389','4');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','A6','1985','Aqua','truck','SXlMHwYfXR5I7tz7o','436573','5');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i20','1981','Auburn','truck','8LYkWx8jWfZADhHY2','137509','1');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Q6','1985','Champagne','sedan','u3uetwn6cJl95Bd6j','292403','4');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M6','2019','Purple','van','dO1DUYrL5l4OEmtwD','298323','13');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Q5','1984','Gold','truck','09QwrJiMlQhw3Hv3x','3715','12');
INSERT INTO vehicle VALUES (DEFAULT,'Ford','Fiesta','2004','Magenta','van','3A6Beg9dYeZbYNcVB','241070','18');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M3','1960','Magenta','sedan','k6zz6VCvJyImLGtiS','246791','12');
INSERT INTO vehicle VALUES (DEFAULT,'Kia','Soul','1988','Rosewood','sedan','qAkTnsgTX3kJnbIXq','125036','2');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Q5','2005','Magenta','truck','rq0RLMI2lQVbcgGmT','401858','9');
INSERT INTO vehicle VALUES (DEFAULT,'Fiat','500','1985','Beige','sedan','vJZoe0m7q6BqBMrcQ','16970','6');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M4','2018','Dark Red','sedan','ZCLeNCnVSZCtOHZsd','385187','11');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i30','2017','Dark Red','sedan','Im1rChZH6Eybdc3YV','366669','17');
INSERT INTO vehicle VALUES (DEFAULT,'Mitsubishi','Outlander','2005','Peach','truck','ccJMwHbqyFZwnP1mm','142127','10');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','A5','1976','Dark Red','van','jixz8FsFmkFQ4K6Wu','331364','6');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M3','1998','Cyan','sedan','Gu0KycIdgMjo1zArr','7206','14');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i20','1982','Orange','coup','gV6ME1E0x1U15yI6w','193813','8');
INSERT INTO vehicle VALUES (DEFAULT,'Opel','Insignia','2005','Mauve','van','4qyKpYou5SGMRcUex','37224','12');
INSERT INTO vehicle VALUES (DEFAULT,'Opel','Insignia','2012','Ruby','truck','jTItgmgkYJKQpHcqH','499009','18');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','X3','2007','Rust','truck','5y0r7IeQVFFfAZpkm','438821','12');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M5','1974','Beige','van','swpgEEXe1kyp2bAq9','160221','6');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','X1','1971','Emerald','coup','Innenx1VsPWzuRBrB','78634','15');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','SantaFe','2018','Capri','coup','Ox5HxmLxF6au9Nx7T','82271','5');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','M4','2013','Champagne','van','J6wBfYLVBZ95N5nLB','327954','11');
INSERT INTO vehicle VALUES (DEFAULT,'Mitsubishi','Lancer','2020','Purple','truck','ljPom9v5bnpYwkhOY','488050','13');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','SantaFe','1961','Aquamarine','coup','zkqYsIAvH3z6rYZOA','385826','4');
INSERT INTO vehicle VALUES (DEFAULT,'Kia','Sportage','2009','Lavender','van','iCHN2fUrLxYEgtepn','330817','20');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Q3','1978','Amethyst','truck','BU7kpkg2CKF2iPYfP','254744','17');
INSERT INTO vehicle VALUES (DEFAULT,'Ford','Kuga','1969','Black','coup','JjYGD0dto0KWGgM1L','245600','20');
INSERT INTO vehicle VALUES (DEFAULT,'Hyundai','i30','2009','Carmine','coup','DL7WZiRKSgAIw8TmI','449959','13');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Q5','1968','Azure','van','78dXfEKG4AofWPS2M','409154','14');
INSERT INTO vehicle VALUES (DEFAULT,'Dacia','Logan','2005','Mauve','sedan','oLADD4MiNbjywwb0B','433639','18');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','R8','1967','Lavender','sedan','6T9NaicMl03KD1Fc7','77135','4');
INSERT INTO vehicle VALUES (DEFAULT,'Mitsubishi','Outlander','1964','Blue','truck','rhhmp2g3sGlNUw3Gl','92131','15');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Cabriolet','2002','Carmine','coup','Jm1XQhRa2sA4k68WQ','168169','17');
INSERT INTO vehicle VALUES (DEFAULT,'Mazda','6','1975','Magenta','sedan','cNFAoshpafQpgbjTw','219974','16');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','A5','1971','Carmine','coup','aoQX6gP6uyTLaOAcP','84589','18');
INSERT INTO vehicle VALUES (DEFAULT,'Citroen','C3','2003','Turquoise','sedan','cLSBab8HyOEQSd8As','385346','15');
INSERT INTO vehicle VALUES (DEFAULT,'Fiat','Tipo','1967','Emerald','coup','60yQequFMdU65UWUE','308239','7');
INSERT INTO vehicle VALUES (DEFAULT,'Audi','Q1','1972','Dark Red','sedan','87Q5DH8PlelJ1UiUL','47261','5');
INSERT INTO vehicle VALUES (DEFAULT,'Dacia','Logan','1963','Gray','van','DtNHOAJWigsdJJWWr','160767','10');
INSERT INTO vehicle VALUES (DEFAULT,'BMW','X5','1971','Lime','sedan','A0qxnKgAA9YvHXdbx','154496','11');
INSERT INTO vehicle VALUES (DEFAULT,'Mitsubishi','Outlander','2012','Black','truck','Wdlft1bvfNJdi5VMd','72264','15');

INSERT INTO license VALUES (DEFAULT,'X7DlQr3z3pRu4QP','Oklahoma','93');
INSERT INTO license VALUES (DEFAULT,'wglDoH3aQrZOZHh','Arkansas','35');
INSERT INTO license VALUES (DEFAULT,'oJTmSxgqaQROdiC','Oregon','31');
INSERT INTO license VALUES (DEFAULT,'JYEes0JLAAdkdhu','South Dakota','82');
INSERT INTO license VALUES (DEFAULT,'lFjSesFWO1mLwIW','Kansas','49');
INSERT INTO license VALUES (DEFAULT,'8IBn5TKbRxCG6sg','Idaho','77');
INSERT INTO license VALUES (DEFAULT,'67dwpp8He8g9O1G','Illinois','35');
INSERT INTO license VALUES (DEFAULT,'jlnHqvZ1M5CQRJF','West Virginia','29');
INSERT INTO license VALUES (DEFAULT,'MZshTdCgbUnbC66','South Carolina','84');
INSERT INTO license VALUES (DEFAULT,'J46kQLE5cu60Mza','Illinois','37');
INSERT INTO license VALUES (DEFAULT,'oqqlPIllOavZJ8F','Idaho','60');
INSERT INTO license VALUES (DEFAULT,'ALpd6Nnl1sFpPfM','Oregon','89');
INSERT INTO license VALUES (DEFAULT,'RQAM3wV8CuTgSv1','Arizona','78');
INSERT INTO license VALUES (DEFAULT,'zPtqsdC9Yaf595j','Pennsylvania','46');
INSERT INTO license VALUES (DEFAULT,'rziRGYUe3cUFi6O','Illinois','63');
INSERT INTO license VALUES (DEFAULT,'q6ULiw8MfV0DDzt','Wyoming','25');
INSERT INTO license VALUES (DEFAULT,'EBsbs0YLyAs4zdQ','Georgia','58');
INSERT INTO license VALUES (DEFAULT,'PmBGJCkEkDdb0nk','Nevada','65');
INSERT INTO license VALUES (DEFAULT,'2NpE7F59tvPSq2j','Georgia','68');
INSERT INTO license VALUES (DEFAULT,'jHI458IXIx5u8XH','Rhode Island','46');
INSERT INTO license VALUES (DEFAULT,'lD1XSgGHZRUv4K4','Hawaii','44');
INSERT INTO license VALUES (DEFAULT,'Ddvn6OhryRAPvXI','Iowa','54');
INSERT INTO license VALUES (DEFAULT,'QgpNRkCwfrylNmA','Nebraska','77');
INSERT INTO license VALUES (DEFAULT,'UoOoozTqdOG2n3L','Florida','63');
INSERT INTO license VALUES (DEFAULT,'4XQDw2t0bgtFlp9','Indiana','29');
INSERT INTO license VALUES (DEFAULT,'DeEulrVgxW641ym','Minnesota','77');
INSERT INTO license VALUES (DEFAULT,'sniohvexNSkk2jG','New Mexico','68');
INSERT INTO license VALUES (DEFAULT,'zrZvSq4g9gx6jrG','Massachusetts','90');
INSERT INTO license VALUES (DEFAULT,'6W1Ygsj6YYu64wz','New Mexico','45');
INSERT INTO license VALUES (DEFAULT,'85s6Z6oIiPr1old','Tennessee','98');
INSERT INTO license VALUES (DEFAULT,'nukLT80y4SJkEt8','Florida','46');
INSERT INTO license VALUES (DEFAULT,'tLO6gZMQ7d2FtxQ','Maine','93');
INSERT INTO license VALUES (DEFAULT,'JE1Fp62Hfoeieft','Illinois','52');
INSERT INTO license VALUES (DEFAULT,'1SYCGUY5We8tKe2','Iowa','35');
INSERT INTO license VALUES (DEFAULT,'k3mLDOWyBvssd7J','South Carolina','52');
INSERT INTO license VALUES (DEFAULT,'5842DtdKSb4YUJl','Arizona','50');
INSERT INTO license VALUES (DEFAULT,'5zvLxDBNEjpN2hz','Connecticut','84');
INSERT INTO license VALUES (DEFAULT,'j4XPgJIBvwcaqlG','New Mexico','34');
INSERT INTO license VALUES (DEFAULT,'CT6LH42p8Jx7a4F','New Hampshire','64');
INSERT INTO license VALUES (DEFAULT,'kr3FYpmJCRjxX8i','Maryland','81');
INSERT INTO license VALUES (DEFAULT,'efFlcAeki9VDU1X','Oregon','37');
INSERT INTO license VALUES (DEFAULT,'AZiCnnTBEnS1kLO','Kansas','73');
INSERT INTO license VALUES (DEFAULT,'ajR4IqYe0qRGrZM','Texas','41');
INSERT INTO license VALUES (DEFAULT,'7JNt01vkXXMt7yG','Alabama','75');
INSERT INTO license VALUES (DEFAULT,'bxvP2sJhx7B5WNG','Missouri','52');
INSERT INTO license VALUES (DEFAULT,'NF85jrfUuTMv21L','Washington','27');
INSERT INTO license VALUES (DEFAULT,'7Y88FaDLD4uoBJF','West Virginia','68');
INSERT INTO license VALUES (DEFAULT,'lA2u2GP4HZ6v5G0','New Jersey','49');
INSERT INTO license VALUES (DEFAULT,'PrIYHp4ugxvqtKG','California','46');
INSERT INTO license VALUES (DEFAULT,'QLVRFStE7BHaIy4','Massachusetts','75');
INSERT INTO license VALUES (DEFAULT,'3XdLdV89WSdNYO0','West Virginia','71');
INSERT INTO license VALUES (DEFAULT,'zpVCKZYUKnxUY91','Kentucky','28');
INSERT INTO license VALUES (DEFAULT,'QtqGxzXSt9Q0jwR','Mississippi','62');
INSERT INTO license VALUES (DEFAULT,'8Pmot8E1SrKp7Tl','New York','50');
INSERT INTO license VALUES (DEFAULT,'8H5gCz7uaaIdk1g','Wisconsin','90');
INSERT INTO license VALUES (DEFAULT,'AmGYgulOeHNmvpo','Pennsylvania','42');
INSERT INTO license VALUES (DEFAULT,'xK295Zo3Th5Xs0n','California','30');
INSERT INTO license VALUES (DEFAULT,'S9Y6cWURiruHpue','Minnesota','51');
INSERT INTO license VALUES (DEFAULT,'DWn3EMbfNNq0vRj','Florida','75');
INSERT INTO license VALUES (DEFAULT,'Wo7SVxirXs4vnwa','Arizona','51');
INSERT INTO license VALUES (DEFAULT,'xRfLOw6bOJoawaL','South Dakota','97');
INSERT INTO license VALUES (DEFAULT,'Y0JDriFMregtjaP','Montana','55');
INSERT INTO license VALUES (DEFAULT,'dR6fI2B1Go4QkSt','Missouri','74');
INSERT INTO license VALUES (DEFAULT,'YkGSFsa8gSZrpsY','Alaska','52');
INSERT INTO license VALUES (DEFAULT,'63scP8IMl3L5GMx','Tennessee','91');
INSERT INTO license VALUES (DEFAULT,'BoeHXjggmjmJb6f','Indiana','42');
INSERT INTO license VALUES (DEFAULT,'V0YMJm7GeyODZFm','Arkansas','81');
INSERT INTO license VALUES (DEFAULT,'ruVPiUL5nYgCK7q','New York','89');
INSERT INTO license VALUES (DEFAULT,'06Or2BgA3uRdMd9','North Dakota','74');
INSERT INTO license VALUES (DEFAULT,'OuE8xgMQfObEU1i','Idaho','64');
INSERT INTO license VALUES (DEFAULT,'Pp1DzszPpj4cb4g','Ohio','61');
INSERT INTO license VALUES (DEFAULT,'t5Z3DaBaWxE6j3s','Nevada','73');
INSERT INTO license VALUES (DEFAULT,'OUMlZCPtH6SyET5','Arkansas','87');
INSERT INTO license VALUES (DEFAULT,'HnJnLPznc5vSGqL','Georgia','82');
INSERT INTO license VALUES (DEFAULT,'pMv2U3KJ5dtmRdJ','Alaska','78');
INSERT INTO license VALUES (DEFAULT,'vFvBCEX86GebBPG','Arizona','46');
INSERT INTO license VALUES (DEFAULT,'osT7xt8dPvGALcl','New Mexico','52');
INSERT INTO license VALUES (DEFAULT,'5FvunHY3Xwqs4Nm','Pennsylvania','98');
INSERT INTO license VALUES (DEFAULT,'zahv7VwhwTQ8vo2','North Carolina','73');
INSERT INTO license VALUES (DEFAULT,'UBfhAl5EZ7SvVhd','South Dakota','38');
INSERT INTO license VALUES (DEFAULT,'nL4l8t8N0yI5mIx','Kentucky','43');
INSERT INTO license VALUES (DEFAULT,'3lzbyymrhYewbvw','Maine','67');
INSERT INTO license VALUES (DEFAULT,'BrFCWRgTKxxIxye','Connecticut','32');
INSERT INTO license VALUES (DEFAULT,'o2ztyWS4aVebZDV','West Virginia','28');
INSERT INTO license VALUES (DEFAULT,'HGnMhTTInBziuk9','Texas','49');
INSERT INTO license VALUES (DEFAULT,'G4d0MUxI56C2vtb','Georgia','80');
INSERT INTO license VALUES (DEFAULT,'rYY3GjflKUcWpuf','South Carolina','30');
INSERT INTO license VALUES (DEFAULT,'6aIM4v0ElWRP2SX','Connecticut','25');
INSERT INTO license VALUES (DEFAULT,'3lVa9U7OBAUvPLh','Wyoming','76');
INSERT INTO license VALUES (DEFAULT,'xAXhwmhzfMOVSCF','Delaware','74');
INSERT INTO license VALUES (DEFAULT,'13Vn6GL82vgSVKu','Arkansas','38');
INSERT INTO license VALUES (DEFAULT,'eWncG8xleIt3t7O','Indiana','68');
INSERT INTO license VALUES (DEFAULT,'UnyD04Mj30BgJBe','Arizona','33');
INSERT INTO license VALUES (DEFAULT,'htrNv5iBb7cEJyR','Alaska','81');
INSERT INTO license VALUES (DEFAULT,'0HQHoba3MIvEVGO','Tennessee','70');
INSERT INTO license VALUES (DEFAULT,'ZftXjrQBY6ueuCu','South Dakota','53');
INSERT INTO license VALUES (DEFAULT,'KW993RQTiww7G1N','New Mexico','64');
INSERT INTO license VALUES (DEFAULT,'YwHYRZ9FPeqZcGB','Vermont','96');
INSERT INTO license VALUES (DEFAULT,'51nmgNdDA5eESFh','Oregon','40');
INSERT INTO license VALUES (DEFAULT,'n7i93793nxk4Fqu','Michigan','35');
INSERT INTO license VALUES (DEFAULT,'5Vy42jnVQefA7ZJ','New Hampshire','43');
INSERT INTO license VALUES (DEFAULT,'cE08C4ns2Z3I5Ot','Georgia','35');
INSERT INTO license VALUES (DEFAULT,'KLOSvY4nmde2pYa','Michigan','87');
INSERT INTO license VALUES (DEFAULT,'NqqK3aKL9JuMVPw','New York','85');
INSERT INTO license VALUES (DEFAULT,'P7I6rq6UZbJzNBc','Montana','30');
INSERT INTO license VALUES (DEFAULT,'BCz8RuDGwOKbQNr','Vermont','88');
INSERT INTO license VALUES (DEFAULT,'JdZ3gAu0d9BWvHR','Montana','45');
INSERT INTO license VALUES (DEFAULT,'Ouo07MF05bw2INc','Indiana','51');
INSERT INTO license VALUES (DEFAULT,'29LKeBFIxuBuAG2','Alaska','98');
INSERT INTO license VALUES (DEFAULT,'96uALQUDkj77Uwj','Hawaii','55');
INSERT INTO license VALUES (DEFAULT,'ORZGttisKbDF4V4','Connecticut','36');
INSERT INTO license VALUES (DEFAULT,'NfpVrt1G3cHKd8c','Mississippi','68');
INSERT INTO license VALUES (DEFAULT,'1kb2QNMRByR7qOD','Nevada','38');
INSERT INTO license VALUES (DEFAULT,'jEPDhii9zRbhqdk','Arizona','49');
INSERT INTO license VALUES (DEFAULT,'dTlQ7RdDq4kJNND','Virginia','47');
INSERT INTO license VALUES (DEFAULT,'YYigUB33a6vuUUq','New Jersey','51');
INSERT INTO license VALUES (DEFAULT,'uuT4mww90n70lDX','Iowa','53');
INSERT INTO license VALUES (DEFAULT,'FLsxIRrXgUsTWk3','Florida','89');
INSERT INTO license VALUES (DEFAULT,'cT6XwmwheY5Cz3X','Florida','95');
INSERT INTO license VALUES (DEFAULT,'Pe8ilclhFbDqeDE','Illinois','79');
INSERT INTO license VALUES (DEFAULT,'kEVASj5Qo3wUrbU','Alaska','55');
INSERT INTO license VALUES (DEFAULT,'UYeT00U0qKt09U0','Colorado','31');
INSERT INTO license VALUES (DEFAULT,'TTI674CS7jyMY9s','Alaska','31');
INSERT INTO license VALUES (DEFAULT,'tp3atNAJlZMZpj6','New Jersey','69');
INSERT INTO license VALUES (DEFAULT,'IBscXdcA3RfnRKA','Rhode Island','92');
INSERT INTO license VALUES (DEFAULT,'lKuojFHwVfz3R92','Wisconsin','83');
INSERT INTO license VALUES (DEFAULT,'1rImVMbaz6egUOM','Vermont','80');
INSERT INTO license VALUES (DEFAULT,'7v66i6kpC7mHmRm','Missouri','61');
INSERT INTO license VALUES (DEFAULT,'TS1RP8SOuInQBRn','New York','64');
INSERT INTO license VALUES (DEFAULT,'BHj0Svi7TOzTNp1','Vermont','86');
INSERT INTO license VALUES (DEFAULT,'43hdswnsyx7ZBq8','Tennessee','31');
INSERT INTO license VALUES (DEFAULT,'PehoAhTU6ud5hdv','Alaska','39');
INSERT INTO license VALUES (DEFAULT,'Wu6ETV6He7kiRh1','South Dakota','34');
INSERT INTO license VALUES (DEFAULT,'ZW2K3VNIvCKxRTL','Michigan','86');
INSERT INTO license VALUES (DEFAULT,'TOqA5JkggjswoMl','Virginia','54');
INSERT INTO license VALUES (DEFAULT,'EY8BdYs5iSwUNoZ','Rhode Island','59');
INSERT INTO license VALUES (DEFAULT,'Om9HdNRnXweWGzi','Michigan','90');
INSERT INTO license VALUES (DEFAULT,'Pxjx008FX0yMT5T','Maryland','39');
INSERT INTO license VALUES (DEFAULT,'89QRkLrXGlNibdN','Maryland','49');
INSERT INTO license VALUES (DEFAULT,'ZlboYwABGWcaD1L','Montana','92');
INSERT INTO license VALUES (DEFAULT,'1jSlom1ZtOug5Xl','Indiana','97');
INSERT INTO license VALUES (DEFAULT,'frUhjMPPeyP7CuC','Ohio','64');
INSERT INTO license VALUES (DEFAULT,'lodtu9jOohQfK81','Rhode Island','30');
INSERT INTO license VALUES (DEFAULT,'VdPWRWDVKxmcrer','Michigan','54');
INSERT INTO license VALUES (DEFAULT,'w66PvsvS5p8uT0Y','Massachusetts','97');
INSERT INTO license VALUES (DEFAULT,'YjsKTSaYjL7v7Dj','Massachusetts','81');
INSERT INTO license VALUES (DEFAULT,'M4DyjueDWqEk06O','Wisconsin','78');
INSERT INTO license VALUES (DEFAULT,'FH0Ocog1Mgxh8mY','Mississippi','65');
INSERT INTO license VALUES (DEFAULT,'od3JzzNG7lVxsOt','Virginia','42');
INSERT INTO license VALUES (DEFAULT,'7bGhuQh7XNqgYEp','Louisiana','47');
INSERT INTO license VALUES (DEFAULT,'SumjQSmHeDKDdRE','Iowa','79');
INSERT INTO license VALUES (DEFAULT,'o7rA4NWLclgkjgq','Rhode Island','55');
INSERT INTO license VALUES (DEFAULT,'69nprJdaPMX335m','Virginia','73');
INSERT INTO license VALUES (DEFAULT,'asFSYgQXxqGh5ge','Oregon','30');
INSERT INTO license VALUES (DEFAULT,'VFoD7xNkoA8Rjp4','Delaware','92');
INSERT INTO license VALUES (DEFAULT,'G75HhcWS3cX2Tq3','Alaska','85');
INSERT INTO license VALUES (DEFAULT,'jgkld51rufRFOAL','Kansas','26');
INSERT INTO license VALUES (DEFAULT,'ahI6ymRvDU0rUUF','Indiana','80');
INSERT INTO license VALUES (DEFAULT,'FXuTmBDZx7EMpcL','New Jersey','47');
INSERT INTO license VALUES (DEFAULT,'PWs1v3TzZlAAZKM','Colorado','60');
INSERT INTO license VALUES (DEFAULT,'4xcrxfEhBpNiY2o','Rhode Island','27');
INSERT INTO license VALUES (DEFAULT,'Ets2UeadMaCZYw2','Michigan','38');
INSERT INTO license VALUES (DEFAULT,'hXOlb0oUtNGRBsW','North Carolina','52');
INSERT INTO license VALUES (DEFAULT,'Gc5lkTBOlEBHn3U','North Carolina','40');
INSERT INTO license VALUES (DEFAULT,'UQwan2EhkQUMLrq','Vermont','26');
INSERT INTO license VALUES (DEFAULT,'qZnj7EMW0vmMGTv','Arizona','85');
INSERT INTO license VALUES (DEFAULT,'XFN6ck1D9CqBZWU','South Carolina','70');
INSERT INTO license VALUES (DEFAULT,'N4WnXMjEwGbVe6j','Hawaii','52');
INSERT INTO license VALUES (DEFAULT,'TlMENzwf7BgUaZS','New York','60');
INSERT INTO license VALUES (DEFAULT,'G04KA3n1qdZseFH','Missouri','28');
INSERT INTO license VALUES (DEFAULT,'DtfhAFkHZKDtVrJ','Alaska','25');
INSERT INTO license VALUES (DEFAULT,'0sAMTsiNgWWxd6Y','Washington','53');
INSERT INTO license VALUES (DEFAULT,'Vi86FvTCkskIVvQ','Alabama','61');
INSERT INTO license VALUES (DEFAULT,'PZG0tA6UetOU6Op','Wisconsin','96');
INSERT INTO license VALUES (DEFAULT,'Vk1Dv7qJt98ELkG','Hawaii','97');
INSERT INTO license VALUES (DEFAULT,'q8HhmiBmlCFrne5','Tennessee','52');
INSERT INTO license VALUES (DEFAULT,'Zp9aecZq9B8PSII','Vermont','96');
INSERT INTO license VALUES (DEFAULT,'hqXasC0aJ4kbGfD','New Mexico','84');
INSERT INTO license VALUES (DEFAULT,'Ka5hMgr0ngDXS37','Maine','74');
INSERT INTO license VALUES (DEFAULT,'6OP6rnJ9UhzO2g5','Mississippi','61');
INSERT INTO license VALUES (DEFAULT,'7rdaVKqkFfxD1An','California','57');
INSERT INTO license VALUES (DEFAULT,'iyL1dxwh182luAI','Idaho','84');
INSERT INTO license VALUES (DEFAULT,'6QzOlEjWlHW6dgM','Arkansas','58');
INSERT INTO license VALUES (DEFAULT,'7Gmnd4r2dLx8Ueo','Wisconsin','28');
INSERT INTO license VALUES (DEFAULT,'EWTM6tme1pZlYbq','Wisconsin','47');
INSERT INTO license VALUES (DEFAULT,'DB6KcVIWI3vXRmr','Indiana','56');
INSERT INTO license VALUES (DEFAULT,'czwPBW9IlORQEtH','Florida','27');
INSERT INTO license VALUES (DEFAULT,'bni3lALzx00GkCr','Wyoming','97');
INSERT INTO license VALUES (DEFAULT,'91tDBo6B0H0FDKo','Nevada','43');
INSERT INTO license VALUES (DEFAULT,'LE2g0ykZNgJCBLj','Arkansas','32');
INSERT INTO license VALUES (DEFAULT,'tPu8a8m1u3VutqM','Kansas','50');
INSERT INTO license VALUES (DEFAULT,'1nSbIDInxIx9z5Q','North Carolina','95');
INSERT INTO license VALUES (DEFAULT,'aZKQvFPpF4Ppd07','Nebraska','74');
INSERT INTO license VALUES (DEFAULT,'U6wolMlVm0y258E','Texas','82');
INSERT INTO license VALUES (DEFAULT,'PwBFGiCwCI27US0','California','37');
INSERT INTO license VALUES (DEFAULT,'kUMSzMi4JPbwK6K','Hawaii','76');
INSERT INTO license VALUES (DEFAULT,'kKyjOYt2iDsXRh8','Kentucky','80');
INSERT INTO license VALUES (DEFAULT,'XuhdakcK6SlA1Ms','Oregon','71');
INSERT INTO license VALUES (DEFAULT,'rqVkW6caQJ0h1rc','Connecticut','55');
INSERT INTO license VALUES (DEFAULT,'jaXNKjVYRFI2q1A','Delaware','73');

INSERT INTO discount VALUES (DEFAULT,'0','Default ');
INSERT INTO discount VALUES (DEFAULT,'73','Description for discount with ID 1');
INSERT INTO discount VALUES (DEFAULT,'50','Description for discount with ID 2');
INSERT INTO discount VALUES (DEFAULT,'34','Description for discount with ID 3');
INSERT INTO discount VALUES (DEFAULT,'57','Description for discount with ID 4');
INSERT INTO discount VALUES (DEFAULT,'33','Description for discount with ID 5');
INSERT INTO discount VALUES (DEFAULT,'72','Description for discount with ID 6');
INSERT INTO discount VALUES (DEFAULT,'53','Description for discount with ID 7');
INSERT INTO discount VALUES (DEFAULT,'34','Description for discount with ID 8');
INSERT INTO discount VALUES (DEFAULT,'60','Description for discount with ID 9');
INSERT INTO discount VALUES (DEFAULT,'21','Description for discount with ID 10');
INSERT INTO discount VALUES (DEFAULT,'12','Description for discount with ID 11');
INSERT INTO discount VALUES (DEFAULT,'73','Description for discount with ID 12');
INSERT INTO discount VALUES (DEFAULT,'9','Description for discount with ID 13');
INSERT INTO discount VALUES (DEFAULT,'14','Description for discount with ID 14');
INSERT INTO discount VALUES (DEFAULT,'17','Description for discount with ID 15');
INSERT INTO discount VALUES (DEFAULT,'18','Description for discount with ID 16');
INSERT INTO discount VALUES (DEFAULT,'47','Description for discount with ID 17');
INSERT INTO discount VALUES (DEFAULT,'9','Description for discount with ID 18');
INSERT INTO discount VALUES (DEFAULT,'49','Description for discount with ID 19');

INSERT INTO membership VALUES (DEFAULT,'Default','1');
INSERT INTO membership VALUES (DEFAULT,'CarMax','16');
INSERT INTO membership VALUES (DEFAULT,'Amazon.com','20');
INSERT INTO membership VALUES (DEFAULT,'Jackbox','1');
INSERT INTO membership VALUES (DEFAULT,'DynCorp','15');
INSERT INTO membership VALUES (DEFAULT,'Zepter','3');
INSERT INTO membership VALUES (DEFAULT,'Bars','8');
INSERT INTO membership VALUES (DEFAULT,'Erickson','14');
INSERT INTO membership VALUES (DEFAULT,'Demaco','19');
INSERT INTO membership VALUES (DEFAULT,'Facebook','1');
INSERT INTO membership VALUES (DEFAULT,'UPC','19');
INSERT INTO membership VALUES (DEFAULT,'Podaphone','12');
INSERT INTO membership VALUES (DEFAULT,'Areon Impex','6');
INSERT INTO membership VALUES (DEFAULT,'LTT','14');
INSERT INTO membership VALUES (DEFAULT,'Apple Inc.','13');
INSERT INTO membership VALUES (DEFAULT,'It Smart Group','1');
INSERT INTO membership VALUES (DEFAULT,'Coca-Cola Company','2');
INSERT INTO membership VALUES (DEFAULT,'Duluth','15');
INSERT INTO membership VALUES (DEFAULT,'Vodafone','8');
INSERT INTO membership VALUES (DEFAULT,'Yarp','8');
INSERT INTO membership VALUES (DEFAULT,'Mars','6');
INSERT INTO membership VALUES (DEFAULT,'Team Guard SRL','10');
INSERT INTO membership VALUES (DEFAULT,'Biolife Grup','9');
INSERT INTO membership VALUES (DEFAULT,'Blarkfel','9');
INSERT INTO membership VALUES (DEFAULT,'Jarmen','17');

INSERT INTO customer VALUES (DEFAULT,'Mr. Cedrick Carter, Lonsdale 3222, Prague - 4432, Belarus','Cedrick Carter','46','7');
INSERT INTO customer VALUES (DEFAULT,'Mr. Julius Uddin, Clavell 4789, Chicago - 6587, Ireland','Julius Uddin','52','8');
INSERT INTO customer VALUES (DEFAULT,'Mr. Maxwell Mullins, King Edward 5517, Kansas City - 1360, Bhutan','Maxwell Mullins','12','2');
INSERT INTO customer VALUES (DEFAULT,'Miss Carmella Vince, Antrobus 4998, Baltimore - 8634, Malawi','Carmella Vince','79','15');
INSERT INTO customer VALUES (DEFAULT,'Mr. Mason Jones, North 5746, Amarillo - 1125, Vatican City','Mason Jones','50','16');
INSERT INTO customer VALUES (DEFAULT,'Mr. Harvey Crawford, Chamberlain 563, Seattle - 2555, The Bahamas','Harvey Crawford','2','1');
INSERT INTO customer VALUES (DEFAULT,'Ms. Marla Burnley, Oxford 8289, Lincoln - 1513, Gabon','Marla Burnley','54','14');
INSERT INTO customer VALUES (DEFAULT,'Miss Diane Johnson, Bacton 8406, Jersey City - 1086, Honduras','Diane Johnson','77','23');
INSERT INTO customer VALUES (DEFAULT,'Miss Gladys Salt, Howard 2644, Indianapolis - 8074, United Kingdom','Gladys Salt','16','17');
INSERT INTO customer VALUES (DEFAULT,'Mr. Manuel Wren, Belmore 4883, Otawa - 8347, South Africa','Manuel Wren','58','21');
INSERT INTO customer VALUES (DEFAULT,'Mr. Michael Zaoui, Sundown 4418, Tulsa - 1836, Yemen','Michael Zaoui','38','14');
INSERT INTO customer VALUES (DEFAULT,'Mr. Nate Seymour, Cliffords 5240, Fremont - 3088, Malta','Nate Seymour','8','21');
INSERT INTO customer VALUES (DEFAULT,'Mr. Doug Foxley, Linden 7497, Honolulu - 7017, Tajikistan','Doug Foxley','92','17');
INSERT INTO customer VALUES (DEFAULT,'Mr. Owen Hancock, Cam 3647, Zurich - 4062, Thailand','Owen Hancock','99','25');
INSERT INTO customer VALUES (DEFAULT,'Miss Ciara Little, Blandford 4252, Tulsa - 8540, Ecuador','Ciara Little','36','17');
INSERT INTO customer VALUES (DEFAULT,'Mr. William Lambert, Lexington 9503, Zurich - 7455, Seychelles','William Lambert','34','3');
INSERT INTO customer VALUES (DEFAULT,'Mr. Bart Huggins, Viscount 4313, Lakewood - 0601, Kuwait','Bart Huggins','59','5');
INSERT INTO customer VALUES (DEFAULT,'Mr. William Wilson, Victoria 9132, El Paso - 2520, San Marino','William Wilson','3','4');
INSERT INTO customer VALUES (DEFAULT,'Mr. Tony Mackenzie, Glenwood 4505, Springfield - 6618, Uganda','Tony Mackenzie','89','5');
INSERT INTO customer VALUES (DEFAULT,'Ms. Kimberly Ranks, Norfolk 9278, Dallas - 4776, China','Kimberly Ranks','45','6');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Stephanie Rainford, Balfour 2643, Springfield - 5871, Myanmar','Stephanie Rainford','37','17');
INSERT INTO customer VALUES (DEFAULT,'Ms. Sofia Eddison, Castle 4491, Jersey City - 2002, Libya','Sofia Eddison','44','21');
INSERT INTO customer VALUES (DEFAULT,'Mr. Johnathan Rose, Geary 5527, San Francisco - 5341, Tanzania','Johnathan Rose','73','21');
INSERT INTO customer VALUES (DEFAULT,'Mr. Manuel Downing, Cave 2676, Philadelphia - 3686, United Arab Emirates','Manuel Downing','81','13');
INSERT INTO customer VALUES (DEFAULT,'Mr. Nathan Tait, Caldwell 3703, London - 8430, Malawi','Nathan Tait','35','15');
INSERT INTO customer VALUES (DEFAULT,'Mr. Fred Bell, Cavendish 5035, Hollywood - 8518, Uzbekistan','Fred Bell','74','17');
INSERT INTO customer VALUES (DEFAULT,'Miss Samara Price, Central 8200, Salt Lake City - 5874, Italy','Samara Price','6','18');
INSERT INTO customer VALUES (DEFAULT,'Mr. Tom Richardson, Chicksand 2169, Wien - 8788, Fiji','Tom Richardson','60','9');
INSERT INTO customer VALUES (DEFAULT,'Ms. Hope Kelly, Gavel 7636, Tallahassee - 0318, Kenya','Hope Kelly','76','10');
INSERT INTO customer VALUES (DEFAULT,'Mr. Michael Trent, Baylis 4856, Bakersfield - 6177, Bangladesh','Michael Trent','15','16');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Celia Hobson, Antrobus 9819, Charlotte - 5745, Samoa','Celia Hobson','62','24');
INSERT INTO customer VALUES (DEFAULT,'Ms. Celia Morgan, Magnolia 4533, Santa Ana - 3022, Israel','Celia Morgan','29','11');
INSERT INTO customer VALUES (DEFAULT,'Mr. Chadwick Thorne, Angrave 1638, Glendale - 3536, Seychelles','Chadwick Thorne','24','5');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Vicky Asher, Linden 3230, Venice - 2877, Jamaica','Vicky Asher','41','12');
INSERT INTO customer VALUES (DEFAULT,'Mr. Cedrick Patel, Adams 4193, San Diego - 1527, Burkina Faso','Cedrick Patel','10','21');
INSERT INTO customer VALUES (DEFAULT,'Mr. Oliver Moore, Cliffords 2218, Richmond - 4142, Philippines','Oliver Moore','85','4');
INSERT INTO customer VALUES (DEFAULT,'Mr. Bryon Coleman, Cleaver 380, Bridgeport - 5533, Mali','Bryon Coleman','49','19');
INSERT INTO customer VALUES (DEFAULT,'Mr. Roger Fields, Bendmore 5215, Indianapolis - 5021, Sudan, South','Roger Fields','40','15');
INSERT INTO customer VALUES (DEFAULT,'Miss Sonya Walsh, Collent 2752, Denver - 3542, Equatorial Guinea','Sonya Walsh','80','24');
INSERT INTO customer VALUES (DEFAULT,'Mr. Hayden Sawyer, Under 1823, Richmond - 7186, Belgium','Hayden Sawyer','23','18');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Brooklyn Heaton, Pine 6547, Columbus - 2131, Cuba','Brooklyn Heaton','7','10');
INSERT INTO customer VALUES (DEFAULT,'Ms. Greta Brooks, Apostle 116, Escondido - 3768, Monaco','Greta Brooks','75','22');
INSERT INTO customer VALUES (DEFAULT,'Mr. Alexander Grant, Ernest 3788, Atlanta - 5487, Libya','Alexander Grant','87','13');
INSERT INTO customer VALUES (DEFAULT,'Miss Camila Jackson, Blackpool 474, Omaha - 8670, Bolivia','Camila Jackson','66','5');
INSERT INTO customer VALUES (DEFAULT,'Ms. Kimberly Pearson, Fawn 3363, Hayward - 1060, Guyana','Kimberly Pearson','91','21');
INSERT INTO customer VALUES (DEFAULT,'Mr. Boris Rogan, Fairholt 5842, Omaha - 5016, Czech Republic','Boris Rogan','57','23');
INSERT INTO customer VALUES (DEFAULT,'Mr. Bryon Edmonds, Railroad 9624, Arlington - 6625, Zimbabwe','Bryon Edmonds','26','18');
INSERT INTO customer VALUES (DEFAULT,'Ms. Janice Cobb, Clarges 6603, Houston - 7302, Australia','Janice Cobb','48','11');
INSERT INTO customer VALUES (DEFAULT,'Ms. Elly Hastings, Bletchley 4663, Worcester - 1174, Korea, South','Elly Hastings','90','16');
INSERT INTO customer VALUES (DEFAULT,'Ms. Makenzie Gregory, Abbots 3730, Milano - 2178, South Africa','Makenzie Gregory','69','12');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Faith West, Bury 9550, Minneapolis - 5027, Argentina','Faith West','9','19');
INSERT INTO customer VALUES (DEFAULT,'Ms. Doris Gray, Battis 4850, Stockton - 0762, Norway','Doris Gray','56','1');
INSERT INTO customer VALUES (DEFAULT,'Ms. Cadence Adams, Ampton 9818, Toledo - 0834, Swaziland','Cadence Adams','21','3');
INSERT INTO customer VALUES (DEFAULT,'Ms. Rachael Bell, Colombo 8871, Memphis - 5271, Germany','Rachael Bell','17','5');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Bristol Purvis, Cave 8932, Colorado Springs - 8147, Gabon','Bristol Purvis','84','11');
INSERT INTO customer VALUES (DEFAULT,'Mr. Jayden Moore, Wakley 7682, Madrid - 4643, Panama','Jayden Moore','18','11');
INSERT INTO customer VALUES (DEFAULT,'Miss Greta Russell, Camelot 6561, Santa Ana - 6480, Liechtenstein','Greta Russell','64','18');
INSERT INTO customer VALUES (DEFAULT,'Ms. Alice Flett, Cardinal 5526, Moreno Valley - 3204, Botswana','Alice Flett','13','10');
INSERT INTO customer VALUES (DEFAULT,'Mr. Elijah Allcott, Arbutus 6383, Bridgeport - 4788, Nepal','Elijah Allcott','88','19');
INSERT INTO customer VALUES (DEFAULT,'Mr. Denis Young, Cave 918, Henderson - 6255, Poland','Denis Young','20','2');
INSERT INTO customer VALUES (DEFAULT,'Ms. Lara Dempsey, Champion 9848, Zurich - 5430, Italy','Lara Dempsey','4','13');
INSERT INTO customer VALUES (DEFAULT,'Miss Dalia Jarvis, Babmaes 5321, New Orleans - 4446, Mozambique','Dalia Jarvis','94','3');
INSERT INTO customer VALUES (DEFAULT,'Ms. Jessica Sherry, Lake 7396, Huntsville - 2560, Sri Lanka','Jessica Sherry','68','20');
INSERT INTO customer VALUES (DEFAULT,'Miss Cassidy Graham, Elba 2933, Minneapolis - 7722, Myanmar','Cassidy Graham','100','15');
INSERT INTO customer VALUES (DEFAULT,'Miss Dorothy Partridge, Egerton 1799, Laredo - 8600, Taiwan','Dorothy Partridge','63','3');
INSERT INTO customer VALUES (DEFAULT,'Miss Natalie Davies, Abbots 8266, Irving - 4221, Brazil','Natalie Davies','22','25');
INSERT INTO customer VALUES (DEFAULT,'Ms. Cynthia Wild, Blean 8343, Lisbon - 7813, Belarus','Cynthia Wild','33','7');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Peyton Allen, Hammersmith 659, Minneapolis - 6334, Myanmar','Peyton Allen','71','19');
INSERT INTO customer VALUES (DEFAULT,'Mr. Rick Murray, Bacon 8482, Toledo - 3068, Trinidad and Tobago','Rick Murray','39','15');
INSERT INTO customer VALUES (DEFAULT,'Miss Jade Gunn, Linda Lane 3043, Atlanta - 1684, Argentina','Jade Gunn','86','21');
INSERT INTO customer VALUES (DEFAULT,'Ms. Josephine Gibbons, King 3507, Minneapolis - 3135, Senegal','Josephine Gibbons','61','7');
INSERT INTO customer VALUES (DEFAULT,'Ms. Gina Miller, Aylward 386, Irving - 5260, Lebanon','Gina Miller','1','16');
INSERT INTO customer VALUES (DEFAULT,'Mr. Chris Oakley, Woodland 3647, Pittsburgh - 6102, Jamaica','Chris Oakley','72','25');
INSERT INTO customer VALUES (DEFAULT,'Mr. Alexander Drew, Cheltenham 5733, Innsbruck - 7213, Monaco','Alexander Drew','95','5');
INSERT INTO customer VALUES (DEFAULT,'Miss Mina Utterson, Clerkenwell 8642, Lyon - 8218, Comoros','Mina Utterson','83','13');
INSERT INTO customer VALUES (DEFAULT,'Miss Bristol Cameron, Balfour 8522, Madrid - 3771, Korea, South','Bristol Cameron','19','16');
INSERT INTO customer VALUES (DEFAULT,'Mr. Carter Everett, Lake 1883, Long Beach - 0178, Taiwan','Carter Everett','96','22');
INSERT INTO customer VALUES (DEFAULT,'Mr. Ramon Williams, Birkin 2961, Bakersfield - 7781, Central African Republic','Ramon Williams','5','2');
INSERT INTO customer VALUES (DEFAULT,'Mr. Tyson Dwyer, Bush 9732, Richmond - 2260, Romania','Tyson Dwyer','97','3');
INSERT INTO customer VALUES (DEFAULT,'Mr. Johnny Gordon, Bennett 8548, Madrid - 7104, Czech Republic','Johnny Gordon','53','13');
INSERT INTO customer VALUES (DEFAULT,'Mr. Henry Yoman, Ely 3487, Valetta - 6606, Cuba','Henry Yoman','51','21');
INSERT INTO customer VALUES (DEFAULT,'Ms. Violet Emmott, Virginia 7166, Albuquerque - 5825, Japan','Violet Emmott','27','20');
INSERT INTO customer VALUES (DEFAULT,'Ms. Gina Tutton, Birkenhead 3673, Amarillo - 8831, Finland','Gina Tutton','30','3');
INSERT INTO customer VALUES (DEFAULT,'Miss Evelynn Walsh, Bletchley 3592, Rome - 5548, USA','Evelynn Walsh','98','5');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Daria Ellery, Blandford 8535, Philadelphia - 0356, Sudan, South','Daria Ellery','14','7');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Tania Harrison, Queensberry 7372, Toledo - 6644, Nicaragua','Tania Harrison','78','25');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Mara Nanton, Glenwood 982, Toledo - 3084, Honduras','Mara Nanton','43','6');
INSERT INTO customer VALUES (DEFAULT,'Mr. Chad Wren, Beechen 482, Washington - 0874, Indonesia','Chad Wren','55','20');
INSERT INTO customer VALUES (DEFAULT,'Mr. Percy Hobbs, Coleman 2311, Escondido - 0612, Senegal','Percy Hobbs','32','17');
INSERT INTO customer VALUES (DEFAULT,'Mr. Nicholas Wilton, Rosewood 3438, Scottsdale - 4881, Sudan, South','Nicholas Wilton','67','19');
INSERT INTO customer VALUES (DEFAULT,'Miss Ellen Edler, Clerkenwell 4628, Milwaukee - 3733, Kazakhstan','Ellen Edler','70','25');
INSERT INTO customer VALUES (DEFAULT,'Mr. Ethan Windsor, Carolina 4285, Murfreesboro - 1144, Antigua and Barbuda','Ethan Windsor','93','13');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Janelle Buckley, Thomas More 9367, Bucharest - 2862, Liberia','Janelle Buckley','11','5');
INSERT INTO customer VALUES (DEFAULT,'Ms. Tiffany Pond, Eaglet 9490, Oakland - 1875, Pakistan','Tiffany Pond','82','3');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Anne Cartwright, Baynes 502, San Diego - 1300, Australia','Anne Cartwright','25','9');
INSERT INTO customer VALUES (DEFAULT,'Mr. Luke Wright, Apothecary 1422, Fremont - 8858, Bahrain','Luke Wright','42','20');
INSERT INTO customer VALUES (DEFAULT,'Mr. Alan Stevens, Apollo 3438, Jersey City - 7312, Rwanda','Alan Stevens','65','18');
INSERT INTO customer VALUES (DEFAULT,'Miss Jamie Dempsey, Westbourne 565, Fullerton - 8553, Gabon','Jamie Dempsey','47','11');
INSERT INTO customer VALUES (DEFAULT,'Mr. Mike Walton, Dunstable 7240, San Jose - 6787, Antigua and Barbuda','Mike Walton','31','21');
INSERT INTO customer VALUES (DEFAULT,'Mr. Chadwick Ranks, Woodland 1789, Detroit - 6157, United Arab Emirates','Chadwick Ranks','45','18');
INSERT INTO customer VALUES (DEFAULT,'Miss Sara Kennedy, Blendon 9974, Valetta - 0733, USA','Sara Kennedy','67','9');
INSERT INTO customer VALUES (DEFAULT,'Mr. Nick Edley, Bendmore 5150, Oakland - 1567, Côte d’Ivoire','Nick Edley','106','12');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Michaela Richardson, Calverley 6289, Murfreesboro - 2884, Vanuatu','Michaela Richardson','154','5');
INSERT INTO customer VALUES (DEFAULT,'Mr. Clint Campbell, Gautrey 8440, Escondido - 6035, Liechtenstein','Clint Campbell','163','24');
INSERT INTO customer VALUES (DEFAULT,'Mr. Barry Preston, Apsley 7551, Tallahassee - 5781, Peru','Barry Preston','159','18');
INSERT INTO customer VALUES (DEFAULT,'Mr. Ramon Lewis, Howard 801, Salt Lake City - 4815, Romania','Ramon Lewis','58','22');
INSERT INTO customer VALUES (DEFAULT,'Miss Kirsten Olivier, Western 2074, Baltimore - 2268, Iran','Kirsten Olivier','61','19');
INSERT INTO customer VALUES (DEFAULT,'Mr. Liam Antcliff, Castlereagh 8636, Anaheim - 0227, Eritrea','Liam Antcliff','21','17');
INSERT INTO customer VALUES (DEFAULT,'Mr. William Whatson, Badric 353, Valetta - 3552, Kuwait','William Whatson','170','17');
INSERT INTO customer VALUES (DEFAULT,'Mr. Clint Ventura, Chestnut 9133, Milano - 2064, East Timor (Timor-Leste)','Clint Ventura','192','23');
INSERT INTO customer VALUES (DEFAULT,'Mr. Anthony Carson, Parkgate 5872, Bucharest - 0811, Bhutan','Anthony Carson','150','24');
INSERT INTO customer VALUES (DEFAULT,'Ms. Violet Wade, Cam 5515, Las Vegas - 0530, Cabo Verde','Violet Wade','38','25');
INSERT INTO customer VALUES (DEFAULT,'Mr. Ramon Miller, Woodland 6121, Springfield - 7472, Jamaica','Ramon Miller','136','13');
INSERT INTO customer VALUES (DEFAULT,'Miss Stacy Hall, Cockspur 1349, Hollywood - 0272, Nigeria','Stacy Hall','168','16');
INSERT INTO customer VALUES (DEFAULT,'Mr. Alan Walsh, Apollo 4553, Nashville - 2864, Israel','Alan Walsh','60','15');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Blake Oldfield, Longman 4303, Lakewood - 4560, Somalia','Blake Oldfield','84','12');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Julia Dillon, Blackheath 220, Philadelphia - 7664, Afghanistan','Julia Dillon','74','24');
INSERT INTO customer VALUES (DEFAULT,'Ms. Hannah Powell, Charterhouse 9891, Madrid - 4712, Vietnam','Hannah Powell','66','18');
INSERT INTO customer VALUES (DEFAULT,'Miss Cameron Thorpe, Gavel 7628, Bridgeport - 1106, Niger','Cameron Thorpe','144','14');
INSERT INTO customer VALUES (DEFAULT,'Miss Hailey Lambert, Chancellor 6919, Detroit - 8056, Ireland','Hailey Lambert','125','1');
INSERT INTO customer VALUES (DEFAULT,'Mr. Denis Walker, Bletchley 5935, Bellevue - 5635, Kenya','Denis Walker','123','4');
INSERT INTO customer VALUES (DEFAULT,'Miss Rosalee Rigg, Endsleigh 3161, Berna - 5110, Brazil','Rosalee Rigg','53','13');
INSERT INTO customer VALUES (DEFAULT,'Mr. Peter Appleton, Belgrave 3883, Charlotte - 2743, Guatemala','Peter Appleton','27','5');
INSERT INTO customer VALUES (DEFAULT,'Mr. William Gibbons, Tisbury 1982, Henderson - 5101, Kenya','William Gibbons','96','6');
INSERT INTO customer VALUES (DEFAULT,'Miss Hannah Warren, Birkbeck 1867, Otawa - 2714, Togo','Hannah Warren','79','23');
INSERT INTO customer VALUES (DEFAULT,'Mr. William Moss, Cleveland 4132, Bucharest - 1551, El Salvador','William Moss','137','9');
INSERT INTO customer VALUES (DEFAULT,'Miss Hannah Garcia, Bolingbroke 4704, Lancaster - 1272, Dominican Republic','Hannah Garcia','46','8');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Lucy Bennett, Chandos 1800, Minneapolis - 5505, Kenya','Lucy Bennett','126','7');
INSERT INTO customer VALUES (DEFAULT,'Mr. Denis Verdon, Dutton 9776, Memphis - 2673, Lesotho','Denis Verdon','148','20');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Mavis Crawford, Sheffield 3496, Omaha - 0767, Liberia','Mavis Crawford','52','9');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Karla Goodman, Lincoln 4724, Miami - 3288, Italy','Karla Goodman','181','13');
INSERT INTO customer VALUES (DEFAULT,'Ms. Michaela Flack, Hickory 9919, Cincinnati - 5761, Fiji','Michaela Flack','15','1');
INSERT INTO customer VALUES (DEFAULT,'Ms. Julia Farrow, Archery 5419, Lisbon - 2063, Hungary','Julia Farrow','190','25');
INSERT INTO customer VALUES (DEFAULT,'Mr. Liam Santos, Blackheath 8992, Fayetteville - 5788, Bolivia','Liam Santos','16','21');
INSERT INTO customer VALUES (DEFAULT,'Miss Zara Moreno, Cloth 1770, Saint Paul - 6133, Angola','Zara Moreno','33','25');
INSERT INTO customer VALUES (DEFAULT,'Mr. Sebastian Clark, Chantry 6858, Laredo - 6436, Poland','Sebastian Clark','20','2');
INSERT INTO customer VALUES (DEFAULT,'Miss Hope Nicholls, Fawn 6243, Kansas City - 0038, Azerbaijan','Hope Nicholls','80','23');
INSERT INTO customer VALUES (DEFAULT,'Miss Bristol Tennant, Carltoun 6407, Atlanta - 1458, Andorra','Bristol Tennant','157','8');
INSERT INTO customer VALUES (DEFAULT,'Mr. Denny Burnley, Bicknell 1661, Richmond - 7476, Bangladesh','Denny Burnley','188','21');
INSERT INTO customer VALUES (DEFAULT,'Mr. Johnathan Price, Waite 3429, Salem - 8266, Hungary','Johnathan Price','140','14');
INSERT INTO customer VALUES (DEFAULT,'Miss Stacy Bristow, Ellerman 5490, Salem - 4408, Honduras','Stacy Bristow','162','14');
INSERT INTO customer VALUES (DEFAULT,'Mr. Bart Torres, Burton 1147, Pittsburgh - 2458, Liechtenstein','Bart Torres','69','12');
INSERT INTO customer VALUES (DEFAULT,'Mr. Anthony Cooper, Charnwood 9890, El Paso - 1606, Tajikistan','Anthony Cooper','198','14');
INSERT INTO customer VALUES (DEFAULT,'Miss Alessandra Dixon, Clifton 2774, Tokyo - 8675, Maldives','Alessandra Dixon','141','18');
INSERT INTO customer VALUES (DEFAULT,'Mr. Daron Wellington, Sheringham 4462, Boston - 7322, Syria','Daron Wellington','151','1');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Aurelia Glynn, Queensberry 8316, Saint Paul - 8363, USA','Aurelia Glynn','135','6');
INSERT INTO customer VALUES (DEFAULT,'Ms. Winnie Greenwood, Carolina 9169, Sacramento - 6370, Seychelles','Winnie Greenwood','109','10');
INSERT INTO customer VALUES (DEFAULT,'Mr. Johnathan Bell, Angrave 9037, Bakersfield - 1883, Solomon Islands','Johnathan Bell','179','25');
INSERT INTO customer VALUES (DEFAULT,'Miss Martha Walton, Fieldstone 6491, Santa Ana - 2758, Liechtenstein','Martha Walton','110','3');
INSERT INTO customer VALUES (DEFAULT,'Mr. Gabriel Miller, Cockspur 5784, Columbus - 5001, Haiti','Gabriel Miller','177','18');
INSERT INTO customer VALUES (DEFAULT,'Mr. Denny Truscott, Shepherds 2231, Wien - 2218, Micronesia','Denny Truscott','132','24');
INSERT INTO customer VALUES (DEFAULT,'Miss Amy Kent, Battersea 7305, Paris - 6663, Czech Republic','Amy Kent','172','2');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Tiffany Robinson, Chapel 7623, Orlando - 1230, Ukraine','Tiffany Robinson','44','17');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Callie Wilde, Clifton 7667, Toledo - 5003, Grenada','Callie Wilde','121','3');
INSERT INTO customer VALUES (DEFAULT,'Ms. Jackeline Morgan, Edwin 5008, Cincinnati - 1836, Cuba','Jackeline Morgan','165','14');
INSERT INTO customer VALUES (DEFAULT,'Mr. Johnathan Yarwood, Paris 8264, Hayward - 6551, Japan','Johnathan Yarwood','2','25');
INSERT INTO customer VALUES (DEFAULT,'Mr. Caleb Rodwell, Dyott 8199, Moreno Valley - 6162, Papua New Guinea','Caleb Rodwell','75','8');
INSERT INTO customer VALUES (DEFAULT,'Mr. Javier White, Unwin 9939, Fullerton - 0550, United Arab Emirates','Javier White','161','25');
INSERT INTO customer VALUES (DEFAULT,'Ms. Carrie Ward, Baylis 7282, Rochester - 3672, United Kingdom','Carrie Ward','47','18');
INSERT INTO customer VALUES (DEFAULT,'Ms. Samara Summers, Cadogan 349, Glendale - 8333, Rwanda','Samara Summers','94','18');
INSERT INTO customer VALUES (DEFAULT,'Mr. Gabriel Robe, Marina 1112, Stockton - 4420, Norway','Gabriel Robe','49','2');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Scarlett Parsons, Bayberry 9049, San Antonio - 3803, Austria','Scarlett Parsons','55','24');
INSERT INTO customer VALUES (DEFAULT,'Mr. Hayden Stuart, Cheney 797, Milano - 4236, Australia','Hayden Stuart','100','2');
INSERT INTO customer VALUES (DEFAULT,'Mr. Caleb Haines, Champion 7769, Santa Ana - 1641, Saudi Arabia','Caleb Haines','22','19');
INSERT INTO customer VALUES (DEFAULT,'Mr. Denny York, Blomfield 9948, Saint Paul - 4501, Estonia','Denny York','81','15');
INSERT INTO customer VALUES (DEFAULT,'Mr. Clint Spencer, Cave 4973, Santa Ana - 4726, USA','Clint Spencer','30','7');
INSERT INTO customer VALUES (DEFAULT,'Ms. Maia Parker, Thomas More 2850, Fort Lauderdale - 8530, New Zealand','Maia Parker','71','10');
INSERT INTO customer VALUES (DEFAULT,'Ms. Janelle Adams, Black Swan 2573, Lancaster - 5278, Saint Kitts and Nevis','Janelle Adams','193','23');
INSERT INTO customer VALUES (DEFAULT,'Mr. Nate Martin, Clissold 6899, Jersey City - 3532, Suriname','Nate Martin','65','4');
INSERT INTO customer VALUES (DEFAULT,'Ms. Mona Goldsmith, Lake 2715, Laredo - 2426, Japan','Mona Goldsmith','158','25');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Diane Knight, Carolina 1360, Otawa - 2230, Swaziland','Diane Knight','138','8');
INSERT INTO customer VALUES (DEFAULT,'Miss Bree Pitt, Carlisle 6491, Glendale - 2657, Mongolia','Bree Pitt','200','14');
INSERT INTO customer VALUES (DEFAULT,'Ms. Adalind Stanley, Sundown 6558, Otawa - 7556, Andorra','Adalind Stanley','175','4');
INSERT INTO customer VALUES (DEFAULT,'Mr. Phillip Collingwood, Glenwood 9515, Quebec - 8323, Egypt','Phillip Collingwood','40','8');
INSERT INTO customer VALUES (DEFAULT,'Mr. Maxwell Ellery, Andrews 4858, Lyon - 8634, Lesotho','Maxwell Ellery','124','19');
INSERT INTO customer VALUES (DEFAULT,'Mr. Phillip Lee, Betton 1895, Nashville - 2108, Papua New Guinea','Phillip Lee','180','10');
INSERT INTO customer VALUES (DEFAULT,'Miss Sylvia Robinson, Cockspur 9036, Bucharest - 6748, Solomon Islands','Sylvia Robinson','167','7');
INSERT INTO customer VALUES (DEFAULT,'Ms. Rosa Farrell, Durham 8171, Chicago - 5138, India','Rosa Farrell','120','14');
INSERT INTO customer VALUES (DEFAULT,'Ms. Ada Tennant, Chambers 1631, Huntsville - 0158, Sri Lanka','Ada Tennant','194','2');
INSERT INTO customer VALUES (DEFAULT,'Miss Megan Wright, Virgil 7828, Berna - 8611, Austria','Megan Wright','29','10');
INSERT INTO customer VALUES (DEFAULT,'Mr. Barry Gardner, Sheffield 3493, Zurich - 4344, Romania','Barry Gardner','4','10');
INSERT INTO customer VALUES (DEFAULT,'Miss Norah Stone, Collins 9333, Escondido - 7731, Serbia','Norah Stone','195','23');
INSERT INTO customer VALUES (DEFAULT,'Mr. Julius Rothwell, Elia 333, San Francisco - 1134, Sierra Leone','Julius Rothwell','59','21');
INSERT INTO customer VALUES (DEFAULT,'Mr. Harry Whitehouse, Linden 4509, Anaheim - 3681, Rwanda','Harry Whitehouse','152','18');
INSERT INTO customer VALUES (DEFAULT,'Mr. Julian Anderson, South 2549, Quebec - 2027, Ethiopia','Julian Anderson','111','2');
INSERT INTO customer VALUES (DEFAULT,'Mr. Ronald Blackwall, Blean 2894, Salt Lake City - 2381, Sri Lanka','Ronald Blackwall','95','12');
INSERT INTO customer VALUES (DEFAULT,'Mr. Jack Roman, Chandos 8116, Anaheim - 5562, Nigeria','Jack Roman','39','18');
INSERT INTO customer VALUES (DEFAULT,'Miss Trisha Quinn, Buttonwood 1584, Houston - 2757, Korea, South','Trisha Quinn','82','8');
INSERT INTO customer VALUES (DEFAULT,'Mr. Leroy Bennett, Thomas Doyle 7920, Laredo - 0422, Sudan','Leroy Bennett','187','2');
INSERT INTO customer VALUES (DEFAULT,'Mr. Ryan Knight, Bacon 2303, St. Louis - 2625, Israel','Ryan Knight','25','20');
INSERT INTO customer VALUES (DEFAULT,'Ms. Daphne Noach, Clavell 8563, Salem - 7524, Chad','Daphne Noach','70','16');
INSERT INTO customer VALUES (DEFAULT,'Miss Lucy Powell, Carnegie 2638, Oakland - 3282, Malaysia','Lucy Powell','76','2');
INSERT INTO customer VALUES (DEFAULT,'Mr. George Vernon, Emily 5264, Columbus - 5554, Poland','George Vernon','184','19');
INSERT INTO customer VALUES (DEFAULT,'Miss Ellen Thomson, Rivervalley 4874, Baltimore - 3085, Papua New Guinea','Ellen Thomson','17','2');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Meredith Stevens, Parkgate 2339, Escondido - 0824, France','Meredith Stevens','92','20');
INSERT INTO customer VALUES (DEFAULT,'Mr. Mason Flanders, Longman 8488, Fullerton - 8588, Costa Rica','Mason Flanders','113','25');
INSERT INTO customer VALUES (DEFAULT,'Mr. Matt Jones, Eaglet 9014, Pittsburgh - 6820, Sierra Leone','Matt Jones','185','1');
INSERT INTO customer VALUES (DEFAULT,'Mrs. Shay Flack, Collins 4349, Hayward - 4414, Serbia','Shay Flack','91','6');
INSERT INTO customer VALUES (DEFAULT,'Mr. Danny Burnley, Bond 6139, San Bernardino - 4500, Turkey','Danny Burnley','197','5');
INSERT INTO customer VALUES (DEFAULT,'Miss Camellia Windsor, Viscount 8047, Oakland - 8562, Tunisia','Camellia Windsor','114','2');

INSERT INTO rental VALUES (DEFAULT,TO_DATE('2022-05-19','YYYY-MM-DD'),TO_DATE('2022-05-21','YYYY-MM-DD'),'253','20','20');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-03-06','YYYY-MM-DD'),TO_DATE('2017-03-13','YYYY-MM-DD'),'252','72','19');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-01-29','YYYY-MM-DD'),TO_DATE('2016-02-04','YYYY-MM-DD'),'215','96','11');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-03-09','YYYY-MM-DD'),TO_DATE('2020-03-13','YYYY-MM-DD'),'73','47','20');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-04-12','YYYY-MM-DD'),TO_DATE('2021-04-28','YYYY-MM-DD'),'229','42','5');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-06-04','YYYY-MM-DD'),TO_DATE('2020-06-09','YYYY-MM-DD'),'137','99','25');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-01-28','YYYY-MM-DD'),TO_DATE('2021-02-12','YYYY-MM-DD'),'199','52','21');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-12-28','YYYY-MM-DD'),TO_DATE('2021-01-09','YYYY-MM-DD'),'57','8','16');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-01-01','YYYY-MM-DD'),TO_DATE('2018-01-09','YYYY-MM-DD'),'100','36','19');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-08-23','YYYY-MM-DD'),TO_DATE('2016-08-25','YYYY-MM-DD'),'66','12','15');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-05-05','YYYY-MM-DD'),TO_DATE('2020-05-12','YYYY-MM-DD'),'228','52','21');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-04-29','YYYY-MM-DD'),TO_DATE('2019-05-05','YYYY-MM-DD'),'218','12','7');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-03-11','YYYY-MM-DD'),TO_DATE('2017-03-28','YYYY-MM-DD'),'180','36','13');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-09-17','YYYY-MM-DD'),TO_DATE('2021-09-22','YYYY-MM-DD'),'179','1','4');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-05-29','YYYY-MM-DD'),TO_DATE('2018-06-05','YYYY-MM-DD'),'74','36','16');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-02-23','YYYY-MM-DD'),TO_DATE('2018-03-08','YYYY-MM-DD'),'149','89','7');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-06-02','YYYY-MM-DD'),TO_DATE('2021-06-09','YYYY-MM-DD'),'192','79','13');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2022-03-09','YYYY-MM-DD'),TO_DATE('2022-03-31','YYYY-MM-DD'),'183','87','7');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-03-08','YYYY-MM-DD'),TO_DATE('2021-03-18','YYYY-MM-DD'),'191','79','1');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-12-28','YYYY-MM-DD'),TO_DATE('2021-01-08','YYYY-MM-DD'),'244','77','21');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-09-17','YYYY-MM-DD'),TO_DATE('2016-10-08','YYYY-MM-DD'),'161','36','25');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-02-23','YYYY-MM-DD'),TO_DATE('2019-03-08','YYYY-MM-DD'),'110','12','19');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-12-25','YYYY-MM-DD'),TO_DATE('2021-01-07','YYYY-MM-DD'),'119','12','13');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-03-01','YYYY-MM-DD'),TO_DATE('2020-03-04','YYYY-MM-DD'),'54','54','19');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-01-09','YYYY-MM-DD'),TO_DATE('2016-01-28','YYYY-MM-DD'),'79','47','21');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-05-10','YYYY-MM-DD'),TO_DATE('2019-05-20','YYYY-MM-DD'),'266','36','14');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-06-11','YYYY-MM-DD'),TO_DATE('2017-06-26','YYYY-MM-DD'),'266','30','25');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-02-02','YYYY-MM-DD'),TO_DATE('2019-02-22','YYYY-MM-DD'),'168','70','20');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-12-31','YYYY-MM-DD'),TO_DATE('2017-01-13','YYYY-MM-DD'),'175','67','1');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2022-02-09','YYYY-MM-DD'),TO_DATE('2022-02-19','YYYY-MM-DD'),'89','42','8');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-11-16','YYYY-MM-DD'),TO_DATE('2020-12-08','YYYY-MM-DD'),'226','6','2');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-04-10','YYYY-MM-DD'),TO_DATE('2020-05-01','YYYY-MM-DD'),'285','62','17');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-12-07','YYYY-MM-DD'),TO_DATE('2016-12-17','YYYY-MM-DD'),'50','79','7');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-12-18','YYYY-MM-DD'),TO_DATE('2018-12-28','YYYY-MM-DD'),'293','60','10');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-01-17','YYYY-MM-DD'),TO_DATE('2021-02-06','YYYY-MM-DD'),'267','12','21');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-11-19','YYYY-MM-DD'),TO_DATE('2017-12-01','YYYY-MM-DD'),'70','87','14');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2022-01-08','YYYY-MM-DD'),TO_DATE('2022-01-28','YYYY-MM-DD'),'234','25','5');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-12-27','YYYY-MM-DD'),TO_DATE('2017-01-09','YYYY-MM-DD'),'288','47','22');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-01-08','YYYY-MM-DD'),TO_DATE('2019-01-29','YYYY-MM-DD'),'292','6','10');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-04-14','YYYY-MM-DD'),TO_DATE('2019-04-28','YYYY-MM-DD'),'253','30','16');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-09-17','YYYY-MM-DD'),TO_DATE('2020-09-27','YYYY-MM-DD'),'116','67','8');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-07-31','YYYY-MM-DD'),TO_DATE('2016-08-18','YYYY-MM-DD'),'201','10','9');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-11-16','YYYY-MM-DD'),TO_DATE('2021-11-23','YYYY-MM-DD'),'84','54','22');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2015-12-15','YYYY-MM-DD'),TO_DATE('2016-01-02','YYYY-MM-DD'),'203','79','23');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-03-29','YYYY-MM-DD'),TO_DATE('2018-04-15','YYYY-MM-DD'),'66','12','4');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-11-25','YYYY-MM-DD'),TO_DATE('2021-12-14','YYYY-MM-DD'),'299','8','8');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-08-05','YYYY-MM-DD'),TO_DATE('2021-08-13','YYYY-MM-DD'),'84','30','17');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-12-09','YYYY-MM-DD'),TO_DATE('2021-12-21','YYYY-MM-DD'),'94','62','11');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-01-02','YYYY-MM-DD'),TO_DATE('2021-01-12','YYYY-MM-DD'),'209','42','5');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-12-10','YYYY-MM-DD'),TO_DATE('2020-12-16','YYYY-MM-DD'),'88','60','23');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-10-03','YYYY-MM-DD'),TO_DATE('2016-10-23','YYYY-MM-DD'),'168','25','10');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-07-11','YYYY-MM-DD'),TO_DATE('2021-07-17','YYYY-MM-DD'),'62','99','9');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-12-25','YYYY-MM-DD'),TO_DATE('2020-01-14','YYYY-MM-DD'),'155','89','12');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-05-13','YYYY-MM-DD'),TO_DATE('2016-05-18','YYYY-MM-DD'),'274','79','12');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-05-29','YYYY-MM-DD'),TO_DATE('2016-06-11','YYYY-MM-DD'),'191','62','19');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-05-07','YYYY-MM-DD'),TO_DATE('2019-05-11','YYYY-MM-DD'),'77','62','6');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-06-09','YYYY-MM-DD'),TO_DATE('2016-06-17','YYYY-MM-DD'),'230','30','19');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-03-03','YYYY-MM-DD'),TO_DATE('2018-03-25','YYYY-MM-DD'),'67','67','3');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-02-18','YYYY-MM-DD'),TO_DATE('2016-02-20','YYYY-MM-DD'),'220','25','16');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-12-30','YYYY-MM-DD'),TO_DATE('2022-01-15','YYYY-MM-DD'),'214','96','11');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-03-07','YYYY-MM-DD'),TO_DATE('2020-03-24','YYYY-MM-DD'),'275','54','12');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-02-03','YYYY-MM-DD'),TO_DATE('2018-02-11','YYYY-MM-DD'),'177','89','6');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-09-07','YYYY-MM-DD'),TO_DATE('2019-09-17','YYYY-MM-DD'),'213','21','6');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-12-29','YYYY-MM-DD'),TO_DATE('2018-01-16','YYYY-MM-DD'),'153','47','14');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-11-15','YYYY-MM-DD'),TO_DATE('2016-11-19','YYYY-MM-DD'),'137','89','3');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-11-01','YYYY-MM-DD'),TO_DATE('2020-11-12','YYYY-MM-DD'),'228','1','12');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-12-20','YYYY-MM-DD'),TO_DATE('2022-01-02','YYYY-MM-DD'),'89','73','17');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-03-08','YYYY-MM-DD'),TO_DATE('2021-03-21','YYYY-MM-DD'),'157','25','23');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-07-25','YYYY-MM-DD'),TO_DATE('2016-08-03','YYYY-MM-DD'),'267','47','23');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-09-24','YYYY-MM-DD'),TO_DATE('2019-10-04','YYYY-MM-DD'),'127','12','4');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-01-28','YYYY-MM-DD'),TO_DATE('2018-02-06','YYYY-MM-DD'),'229','73','23');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-01-29','YYYY-MM-DD'),TO_DATE('2021-02-01','YYYY-MM-DD'),'245','42','4');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-08-20','YYYY-MM-DD'),TO_DATE('2016-08-28','YYYY-MM-DD'),'110','1','19');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-12-02','YYYY-MM-DD'),TO_DATE('2019-12-15','YYYY-MM-DD'),'173','79','5');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-08-21','YYYY-MM-DD'),TO_DATE('2017-09-05','YYYY-MM-DD'),'131','54','3');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-02-28','YYYY-MM-DD'),TO_DATE('2018-03-03','YYYY-MM-DD'),'145','42','8');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-06-21','YYYY-MM-DD'),TO_DATE('2017-07-05','YYYY-MM-DD'),'108','10','12');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-10-05','YYYY-MM-DD'),TO_DATE('2021-10-18','YYYY-MM-DD'),'98','96','22');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-01-15','YYYY-MM-DD'),TO_DATE('2017-02-01','YYYY-MM-DD'),'79','89','11');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-05-29','YYYY-MM-DD'),TO_DATE('2019-06-04','YYYY-MM-DD'),'198','54','8');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2015-12-02','YYYY-MM-DD'),TO_DATE('2015-12-16','YYYY-MM-DD'),'103','12','10');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-12-13','YYYY-MM-DD'),TO_DATE('2017-12-25','YYYY-MM-DD'),'217','21','9');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-09-28','YYYY-MM-DD'),TO_DATE('2018-10-05','YYYY-MM-DD'),'132','89','15');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-06-10','YYYY-MM-DD'),TO_DATE('2018-06-23','YYYY-MM-DD'),'129','79','6');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-12-18','YYYY-MM-DD'),TO_DATE('2017-12-31','YYYY-MM-DD'),'113','73','9');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-04-05','YYYY-MM-DD'),TO_DATE('2021-04-12','YYYY-MM-DD'),'62','1','19');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-01-30','YYYY-MM-DD'),TO_DATE('2017-02-15','YYYY-MM-DD'),'98','77','21');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-03-10','YYYY-MM-DD'),TO_DATE('2018-03-26','YYYY-MM-DD'),'105','21','10');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-07-16','YYYY-MM-DD'),TO_DATE('2016-07-24','YYYY-MM-DD'),'186','36','18');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-11-12','YYYY-MM-DD'),TO_DATE('2016-11-28','YYYY-MM-DD'),'77','25','20');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2020-03-23','YYYY-MM-DD'),TO_DATE('2020-04-14','YYYY-MM-DD'),'210','1','1');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-10-12','YYYY-MM-DD'),TO_DATE('2019-10-27','YYYY-MM-DD'),'108','54','17');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-10-21','YYYY-MM-DD'),TO_DATE('2016-10-28','YYYY-MM-DD'),'215','79','8');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2019-10-12','YYYY-MM-DD'),TO_DATE('2019-10-22','YYYY-MM-DD'),'231','89','7');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-05-29','YYYY-MM-DD'),TO_DATE('2021-06-13','YYYY-MM-DD'),'234','70','22');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2016-10-21','YYYY-MM-DD'),TO_DATE('2016-11-10','YYYY-MM-DD'),'67','21','7');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2017-10-29','YYYY-MM-DD'),TO_DATE('2017-11-09','YYYY-MM-DD'),'131','30','20');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2018-03-30','YYYY-MM-DD'),TO_DATE('2018-04-18','YYYY-MM-DD'),'278','62','24');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2022-06-01','YYYY-MM-DD'),TO_DATE('2022-06-11','YYYY-MM-DD'),'155','12','14');
INSERT INTO rental VALUES (DEFAULT,TO_DATE('2021-01-06','YYYY-MM-DD'),TO_DATE('2021-01-14','YYYY-MM-DD'),'188','30','4');

INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2021-05-31','YYYY-MM-DD'),'79','13');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2022-03-07','YYYY-MM-DD'),'87','7');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2021-02-22','YYYY-MM-DD'),'79','1');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2020-12-12','YYYY-MM-DD'),'77','21');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2016-09-01','YYYY-MM-DD'),'36','25');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2019-02-07','YYYY-MM-DD'),'12','19');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2020-12-17','YYYY-MM-DD'),'12','13');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2020-02-17','YYYY-MM-DD'),'54','19');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2015-12-31','YYYY-MM-DD'),'47','21');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2019-04-26','YYYY-MM-DD'),'36','14');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2017-06-01','YYYY-MM-DD'),'30','25');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2019-01-28','YYYY-MM-DD'),'70','20');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2016-12-15','YYYY-MM-DD'),'67','1');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2022-02-07','YYYY-MM-DD'),'42','8');
INSERT INTO reservation VALUES (DEFAULT,TO_DATE('2020-11-14','YYYY-MM-DD'),'6','2');

INSERT INTO charge VALUES (DEFAULT,'100','506','908.04','443.27','0','1');
INSERT INTO charge VALUES (DEFAULT,'100','1764','940.43','752.74','0','2');
INSERT INTO charge VALUES (DEFAULT,'100','1290','369.83','780.85','0','3');
INSERT INTO charge VALUES (DEFAULT,'100','292','50.66','424.74','1','4');
INSERT INTO charge VALUES (DEFAULT,'100','3664','353.91','691.43','0','5');
INSERT INTO charge VALUES (DEFAULT,'100','685','632.38','613.18','0','6');
INSERT INTO charge VALUES (DEFAULT,'100','2985','234.48','61.75','1','7');
INSERT INTO charge VALUES (DEFAULT,'100','684','124.55','140.67','0','8');
INSERT INTO charge VALUES (DEFAULT,'100','800','129.59','89.43','0','9');
INSERT INTO charge VALUES (DEFAULT,'100','132','847.18','421.46','1','10');
INSERT INTO charge VALUES (DEFAULT,'100','1596','603.55','831.93','1','11');
INSERT INTO charge VALUES (DEFAULT,'100','1308','798.94','24.65','1','12');
INSERT INTO charge VALUES (DEFAULT,'100','3060','503.84','382.72','0','13');
INSERT INTO charge VALUES (DEFAULT,'100','895','432.87','370.44','0','14');
INSERT INTO charge VALUES (DEFAULT,'100','518','74.21','539.11','1','15');
INSERT INTO charge VALUES (DEFAULT,'100','1937','222.75','108.78','0','16');
INSERT INTO charge VALUES (DEFAULT,'100','1344','183.85','786.74','0','17');
INSERT INTO charge VALUES (DEFAULT,'100','4026','902.86','207.85','0','18');
INSERT INTO charge VALUES (DEFAULT,'100','1910','953.6','54.08','0','19');
INSERT INTO charge VALUES (DEFAULT,'100','2684','726.68','653.23','1','20');
INSERT INTO charge VALUES (DEFAULT,'100','3381','487.24','508.56','0','21');
INSERT INTO charge VALUES (DEFAULT,'100','1430','979.18','491.08','0','22');
INSERT INTO charge VALUES (DEFAULT,'100','1547','712.34','340.75','0','23');
INSERT INTO charge VALUES (DEFAULT,'100','162','590.33','69.49','0','24');
INSERT INTO charge VALUES (DEFAULT,'100','1501','276.37','69.68','1','25');
INSERT INTO charge VALUES (DEFAULT,'100','2660','846.98','85.44','1','26');
INSERT INTO charge VALUES (DEFAULT,'100','3990','942.95','96.27','1','27');
INSERT INTO charge VALUES (DEFAULT,'100','3360','466.8','41.85','1','28');
INSERT INTO charge VALUES (DEFAULT,'100','2275','298.71','621.54','0','29');
INSERT INTO charge VALUES (DEFAULT,'100','890','274.89','84.99','0','30');
INSERT INTO charge VALUES (DEFAULT,'100','4972','756.35','357.81','1','31');
INSERT INTO charge VALUES (DEFAULT,'100','5985','272.31','819.38','1','32');
INSERT INTO charge VALUES (DEFAULT,'100','500','663.58','813.17','0','33');
INSERT INTO charge VALUES (DEFAULT,'100','2930','381.71','492.05','1','34');
INSERT INTO charge VALUES (DEFAULT,'100','5340','777.16','81.47','1','35');
INSERT INTO charge VALUES (DEFAULT,'100','840','739.76','73.79','0','36');
INSERT INTO charge VALUES (DEFAULT,'100','4680','804.01','670.26','1','37');
INSERT INTO charge VALUES (DEFAULT,'100','3744','237.34','930.06','1','38');
INSERT INTO charge VALUES (DEFAULT,'100','6132','157.15','738.6','1','39');
INSERT INTO charge VALUES (DEFAULT,'100','3542','508.15','422.54','0','40');
INSERT INTO charge VALUES (DEFAULT,'100','1160','421.85','375.08','1','41');
INSERT INTO charge VALUES (DEFAULT,'100','3618','673.98','384.38','1','42');
INSERT INTO charge VALUES (DEFAULT,'100','588','316.42','46.45','0','43');
INSERT INTO charge VALUES (DEFAULT,'100','3654','573.75','701.97','1','44');
INSERT INTO charge VALUES (DEFAULT,'100','1122','594.76','798.94','0','45');
INSERT INTO charge VALUES (DEFAULT,'100','5681','653.87','466.19','0','46');
INSERT INTO charge VALUES (DEFAULT,'100','672','443.1','52.28','0','47');
INSERT INTO charge VALUES (DEFAULT,'100','1128','164.41','341.72','0','48');
INSERT INTO charge VALUES (DEFAULT,'100','2090','435.81','132.02','0','49');
INSERT INTO charge VALUES (DEFAULT,'100','528','290.2','977.24','0','50');
INSERT INTO charge VALUES (DEFAULT,'100','3360','134.88','924.05','0','51');
INSERT INTO charge VALUES (DEFAULT,'100','372','614.82','739.79','0','52');
INSERT INTO charge VALUES (DEFAULT,'100','3100','439.52','979.6','0','53');
INSERT INTO charge VALUES (DEFAULT,'100','1370','150.72','616.58','1','54');
INSERT INTO charge VALUES (DEFAULT,'100','2483','949.52','965.76','0','55');
INSERT INTO charge VALUES (DEFAULT,'100','308','618.62','366.39','0','56');
INSERT INTO charge VALUES (DEFAULT,'100','1840','922.45','849.61','1','57');
INSERT INTO charge VALUES (DEFAULT,'100','1474','786.34','514.99','0','58');
INSERT INTO charge VALUES (DEFAULT,'100','440','46.46','571.89','0','59');
INSERT INTO charge VALUES (DEFAULT,'100','3424','312.05','435.3','1','60');
INSERT INTO charge VALUES (DEFAULT,'100','4675','772.46','43.28','1','61');
INSERT INTO charge VALUES (DEFAULT,'100','1416','522.43','908.91','0','62');
INSERT INTO charge VALUES (DEFAULT,'100','2130','547.95','62.73','1','63');
INSERT INTO charge VALUES (DEFAULT,'100','2754','4.55','373.01','1','64');
INSERT INTO charge VALUES (DEFAULT,'100','548','57.21','578.68','0','65');
INSERT INTO charge VALUES (DEFAULT,'100','2508','425.96','673.03','1','66');
INSERT INTO charge VALUES (DEFAULT,'100','1157','725.88','601.5','0','67');
INSERT INTO charge VALUES (DEFAULT,'100','2041','12.94','988.7','1','68');
INSERT INTO charge VALUES (DEFAULT,'100','2403','911.07','926.62','1','69');
INSERT INTO charge VALUES (DEFAULT,'100','1270','19.2','618.9','0','70');
INSERT INTO charge VALUES (DEFAULT,'100','2061','628.73','683.79','1','71');
INSERT INTO charge VALUES (DEFAULT,'100','735','979.01','202.37','1','72');
INSERT INTO charge VALUES (DEFAULT,'100','880','518.7','18.81','0','73');
INSERT INTO charge VALUES (DEFAULT,'100','2249','748.94','436.81','1','74');
INSERT INTO charge VALUES (DEFAULT,'100','1965','303.9','11.62','0','75');
INSERT INTO charge VALUES (DEFAULT,'100','435','254.18','423.47','1','76');
INSERT INTO charge VALUES (DEFAULT,'100','1512','944.42','200.22','0','77');
INSERT INTO charge VALUES (DEFAULT,'100','1274','440.09','909.22','0','78');
INSERT INTO charge VALUES (DEFAULT,'100','1343','341.08','916.48','1','79');
INSERT INTO charge VALUES (DEFAULT,'100','1188','420.37','189.49','0','80');
INSERT INTO charge VALUES (DEFAULT,'100','1442','18.32','540.68','0','81');
INSERT INTO charge VALUES (DEFAULT,'100','2604','963.46','556.11','1','82');
INSERT INTO charge VALUES (DEFAULT,'100','924','65.66','879.77','0','83');
INSERT INTO charge VALUES (DEFAULT,'100','1677','782.92','471.21','0','84');
INSERT INTO charge VALUES (DEFAULT,'100','1469','483.23','195.25','1','85');
INSERT INTO charge VALUES (DEFAULT,'100','434','129.53','186.13','0','86');
INSERT INTO charge VALUES (DEFAULT,'100','1568','344.4','114.24','1','87');
INSERT INTO charge VALUES (DEFAULT,'100','1680','718.91','131.01','0','88');
INSERT INTO charge VALUES (DEFAULT,'100','1488','131.15','308.49','1','89');
INSERT INTO charge VALUES (DEFAULT,'100','1232','383.99','922.28','0','90');
INSERT INTO charge VALUES (DEFAULT,'100','4620','630.95','615.78','0','91');
INSERT INTO charge VALUES (DEFAULT,'100','1620','93.8','380.42','1','92');
INSERT INTO charge VALUES (DEFAULT,'100','1505','713.24','294.65','1','93');
INSERT INTO charge VALUES (DEFAULT,'100','2310','224.89','146.63','1','94');
INSERT INTO charge VALUES (DEFAULT,'100','3510','574.83','573.14','0','95');
INSERT INTO charge VALUES (DEFAULT,'100','1340','569.22','725.28','0','96');
INSERT INTO charge VALUES (DEFAULT,'100','1441','994.64','194.05','1','97');
INSERT INTO charge VALUES (DEFAULT,'100','5282','387.88','466','1','98');
INSERT INTO charge VALUES (DEFAULT,'100','1550','245.44','531.38','1','99');
INSERT INTO charge VALUES (DEFAULT,'100','1504','516.71','809.21','1','100');
