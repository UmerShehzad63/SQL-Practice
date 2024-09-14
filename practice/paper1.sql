1;
select distinct license_plate_number
from carmechanic.m_repair re inner join 
carmechanic.m_car car on car.c_id = re.car_id
where repair_cost > (select max(repair_cost)
                from carmechanic.m_repair rep
                inner join carmechanic.m_car c on
                c.c_id = rep.car_id inner join carmechanic.m_car_model
                cm on cm.cm_id = c.model_id 
                where make = 'Toyota');



2;
select c_id , color , first_sell_date , first_sell_price , model_id , license_plate_number
from carmechanic.m_car car inner join 
carmechanic.m_owns own  on car.c_id = own.car_id
inner join carmechanic.m_owner ow on 
ow.o_id = own.owner_id inner join 
carmechanic.m_repair re on car.c_id = re.car_id inner join
carmechanic.m_workshop ws on 
ws.w_id = re.workshop_id
where ow.address like 'Eger%' and
ws.address like 'Eger%';


3;
select sum(repair_cost) , cm_id , cm_name , make
from carmechanic.m_car c inner join 
carmechanic.m_repair re on 
re.car_id = c.c_id inner join
carmechanic.m_car_model cm on 
cm.cm_id = c.model_id
group by  cm_id , cm_name ,make
order by sum(repair_cost) 
fetch first 5 rows with ties;

alter table m_mechanic 
add primary key(m_id);
4;
create table relatives (
identifier char(10) constraint re_pk primary key ,
name varchar2(40) constraint re_nn not null , 
gender varchar2(10) ,
date_of_birth date , 
connection number(5),
constraint fk foreign key(connection) references m_mechanic(m_id));

create table m_works_for as select * from carmechanic.m_works_for;
5;
drop table m_works_for cascade constraints;


6;
create table m_car_model as select * from carmechanic.m_car_model where 0 =1;
insert into m_car_model (cm_id , cm_name , make , details)
select * from carmechanic.m_car_model
where cm_id not in (select model_id
                    from carmechanic.m_car
                    where model_id is not null);


rollback;
7;
select * from m_repair;
update m_repair re
set end_date = sysdate,
repair_cost = months_between(start_date ,sysdate ) * 30 *(select 0.1*first_sell_price
                                                            from carmechanic.m_car c
                                                            where c.c_id = re.car_id)
where end_date is null and workshop_id in (select w_id
                        from carmechanic.m_workshop 
                        where w_name = 'Kerekes Alex Szervize');
roll back;
8;
create view lpn as 
select * from carmechanic.m_car c
where color = 'gray'
order by first_sell_price desc nulls last
fetch first row with ties ;
drop view lpn;
rollback;


9;
create view color as; 
select color , license_plate_number , first_sell_price 
from carmechanic.m_car
where first_sell_price in (
                            select  max(first_sell_price)
                            from carmechanic.m_car
                            group by color );
                            

10;
revoke all privileges on m_car from public;
rollback;

revoke select on m_mechanic from dzsoni;


