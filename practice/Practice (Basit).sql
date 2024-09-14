1;
select distinct cm_name , make
from carmechanic.m_car_model cm inner join
carmechanic.m_car c on cm.cm_id = c.model_id
where c_id in (select car_id 
                from carmechanic.m_car_evaluation)
order by make , cm_name;

2;
select * 
from carmechanic.m_car c inner join
carmechanic.m_car_model cm 
on cm.cm_id = c.model_id
where to_char(first_sell_date , 'yyyy') = '2006'
or make = 'Opel';

3;
select license_plate_number , price
from carmechanic.m_car c inner join
carmechanic.m_car_evaluation ev on
ev.car_id = c.c_id 
order by price desc 
fetch first 5 rows with ties;

4;         NOT SOLVED;
create table insurance (
    insurance_number char(8) primary key,
    car_id number(5) ,
    owner_id number(5) ,
    owner_email varchar2(40) not null,
    start_date date ,
    end_date date,
    monthly_cost number(5) constraint ch check(monthly_cost > 10000),
    constraint fk_oid foreign key (owner_id) references m_owner (o_id),
    constraint fk_cid foreign key (car_id) references m_car(c_id)
);

5;
create table m_mechanic as select *from carmechanic.m_mechanic;

alter table m_mechanic
add bonus number(6) constraint m_bo check(bonus > 2000);
rollback;
alter table m_mechanic
drop column bonus;
6;

insert into m_car( c_id , color , first_sell_date , first_sell_price , model_id , license_plate_number)
select c_id , color , first_sell_date , first_sell_price , model_id , license_plate_number
from carmechanic.m_car c inner join 
carmechanic.m_owns o on c.c_id = o.car_id inner join
carmechanic.m_owner ow on ow.o_id = o.owner_id 
where o_name like 'Jakab %' and 
color in ('gray' , 'blue')
;
rollback;
create table m_workshop as select * from carmechanic.m_workshop;

create table m_repair as select * from carmechanic.m_repair;
7;
update m_repair re
set end_date = sysdate,
repair_cost = to_number(end_date - start_date) * (select 0.1 * first_sell_price
                                from carmechanic.m_car c
                                where c.c_id = re.car_id)
where end_date is null
and workshop_id = ( select w_id from carmechanic.m_workshop ws 
                    where w_name = 'Kerekes Alex Szervize')
;

8;                    
create view license as
select license_plate_number
from carmechanic.m_car c
where color = 'gray'
order by first_sell_price desc
fetch first row with ties;
;


9;
create view most_model as
select make , cm_name
from carmechanic.m_car_model
where cm_id = (select model_id
                from carmechanic.m_car c
                group by model_id
                order by count(*) desc
                fetch first row only);
                
                
10;
grant select on m_mechanic to dzsoni;
revoke select on m_mechanic from dzsoni;

