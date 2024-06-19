# EJERCICIO 1
#CREAR UNA TABLA 
USE transactions;
CREATE TABLE credit_card (
id   varchar(15) primary KEY, # PRIMARY KEYS
iban varchar(40) NULL,
pan  varchar(25) NULL,
pin  varchar(6)  NULL,
cvv  varchar(6)  NULL,
expiring_date varchar(8)null);

# ahora la conexion 
alter table transaction
add constraint fk_credit_card
foreign key (credit_card_id)
references credit_card(id);

# EJERCICIO 2
# El departamento de Recursos Humanos ha identificado un error en el número de cuenta del usuario con ID CcU-2938. La información que debe mostrarse para este registro es: R323456312213576817699999. Recuerda mostrar que el cambio se realizó.

select  *
from transactions.credit_card
where id = 'CcU-2938';

UPDATE transactions.credit_card
SET iban = 'R323456312213576817699999'
WHERE id = 'CcU-2938';

#EJERCICIO3
#En la tabla "transaction" ingresa un nuevo usuario 

SELECT*
FROM transactions.transaction;

SELECT*
FROM transactions.company
where id='b-9999';
#insertamos en la tablas company y credit_card el nuevo registro
insert into transactions.company (id)
values ('b-9999');
SELECT*
FROM transactions.credit_card
where id='CcU-9999';
insert into transactions.credit_card (id)
values ('CcU-9999');

#Creo el nuevo usuario
insert into transactions.transaction(id,credit_card_id,company_id, user_id, lat, longitude,timestamp, amount, declined)
values ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', now(), '111.11', '0');
#Visualizo la nueva transacción
SELECT * FROM transaction
WHERE id = "108B1D1D-5B23-A76C-55EF-C568E49A99DD";


#EJERCICIO 4
#Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card. Recuerda mostrar el cambio realizado.
SELECT *
FROM transactions.credit_card;

ALTER TABLE credit_card
DROP COLUMN pan;

# NIVEL 2
#Elimina de la tabla transacción el registro con ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de datos.
select *
from transactions.transaction
where id='02C6201E-D90A-1859-B4EE-88D2986D3B02';

delete
from transactions.transaction
where id='02C6201E-D90A-1859-B4EE-88D2986D3B02';

#ejercicio2
#La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. 
#Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones.
# Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente información:
# Nombre de la compañía. Teléfono de contacto. País de residencia. Media de compra realizado por cada compañía.
# Presenta la vista creada, ordenando los datos de mayor a menor promedio de compra.

create view vistmarketing as
  select company.id,company.company_name, company.phone,company.country, avg(amount,2) as media
  from transactions.company
  join transactions.transaction on company.id = transaction.company_id
  where transaction.declined = 0
  group by company.id
  order by media desc;
  
SELECT *
FROM vistmarketing;


#ejercicio3
#Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"
SELECT * FROM transactions.vistmarketing WHERE country = 'Germany';

#NIVEL3
# EJERCICIO 1
# Tabla company se debe eliminar la columna web site 
select *
from transactions.company;

ALTER TABLE company
DROP COLUMN website;

# cambiar el nombre a la tabla USER

rename table user to data_user;

show tables;
# renombrar en la tabla data_user email por personal_emailtransaction
ALTER TABLE data_user CHANGE email personal_email VARCHAR(150);
# para este caso se tiene clave primaria y foreign como la misma procedemos a eliminarla
#Eliminar la FK data_user_ibfk_1
ALTER TABLE data_user
DROP FOREIGN KEY data_user_ibfk_1;

SELECT *
FROM  data_user;

#En la tabla CREDI_CARD cambiar los siguientes campos Id a varchar(20,iban a VARCHAR(50), pin a VARCHAR(4), cvv a INT, expiring_date a VARCHAR (10).
ALTER TABLE transactions.credit_card MODIFY COLUMN id VARCHAR(20);
ALTER TABLE credit_card MODIFY COLUMN iban VARCHAR(50);
ALTER TABLE credit_card MODIFY COLUMN pin VARCHAR(4);
ALTER TABLE credit_card MODIFY COLUMN cvv INT;
ALTER TABLE credit_card MODIFY COLUMN expiring_date VARCHAR(10);
 #Eliminar el campo pan.
ALTER TABLE credit_card DROP COLUMN pan;
-- Agrego el campo fecha_actual con tipo DATE
ALTER TABLE credit_card ADD fecha_actual DATE;
#Visualización:
SHOW COLUMNS
FROM credit_card;

describe credit_card;
describe transaction;
alter table transaction
drop foreign key fk_credit_card;



#insertando el usuraio q me falta 
insert into transactions.data_user(id)
values ('9999');

alter table transaction
add constraint fk_user_id 
foreign key (user_id) 
references data_user(id);

alter table transaction drop primary key,
add primary key (id, credit_card_id, user_id);


#vista llamada "InformeTecnico" 
create view informetecnico as
  select transaction.id,data_user.name, data_user.surname,credit_card.iban, company.company_name
  from transactions.transaction
  join transactions.data_user on transaction.id = data_user.id
  join transactions.credit_card on transaction.credit_card_id = credit_card.id
  join transactions.company on transaction.company_id = company.id;
  
SELECT *
FROM informetecnico
ORDER BY transaction.id DESC;

