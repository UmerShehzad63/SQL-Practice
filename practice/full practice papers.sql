select distinct cm_name , make 
from carmechanic.m_car_model cm 
inner join carmechanic.m_car c on 
cm.cm_id = c.model_id where c_id in (select car_id 
                            from carmechanic.m_car_evaluation)
order by make, cm_name ;



select *
from carmechanic.m_car c 
where to_char(first_sell_date , 'yyyy') = '2006'
or model_id in (select cm_id 
                    from carmechanic.m_car_model cm
                    where make = 'Opel' );
                    
3;
select license_plate_number , price
from carmechanic.m_car c inner join
carmechanic.m_car_evaluation ev on
c.c_id = ev.car_id
order by price desc nulls last
fetch first 5 rows with ties;



4;

create table insurance (
in_num char(8) constraint in_pk primary key,
car_id number(5) ,
owner_id number(5),
owner_email varchar2(40) constraint in_em not null,
start_date date,
end_date date,
monthly_cost number(5) constraint in_ch check(monthly_cost > 10000),
constraint in_fk_c foreign key (car_id) references m_car(c_id),
constraint in_fk_ow foreign key (owner_id) references m_owner(o_id)
);
drop table insurance cascade constraints;


5;
alter table m_mechanic
add bonus number(6) constraint ch check(bonus > 2000);
rollback;


6;
insert into m_car(c_id , color , first_sell_date , first_sell_price, model_id,license_plate_number)
select c_id , color , first_sell_date , first_sell_price, model_id,license_plate_number
from carmechanic.m_car c
inner join carmechanic.m_owns o on 
o.car_id = c.c_id inner join carmechanic.m_owner ow
on ow.o_id = o.owner_id 
where o_name like 'Jakab %' and 
color in ('blue' , 'gray');
create table m_car as select * from carmechanic.m_car where 0 =1;
rollback;


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
create view v1 as 
select license_plate_number
from carmechanic.m_car c
where color = 'gray'
order by first_sell_price desc nulls last
fetch first row with ties;
drop view v1;



9;
create view v1 as;
select cm_name , make
from carmechanic.m_car c inner join 
carmechanic.m_car_model cm on 
c.model_id = cm.cm_id
group by cm_name , make
order by count(c_id) desc nulls last
fetch first row only;


10;
revoke select on m_mechanic from dzsoni;
grant select on m_mechanic to dzsoni;


                     *************************************
                     
1;
select distinct license_plate_number
from carmechanic.m_car c inner join
carmechanic.m_repair re on c.c_id = re.car_id
where repair_cost > (select max(repair_cost)
                    from carmechanic.m_car c inner join 
                    carmechanic.m_car_model cm on 
                    c.model_id = cm.cm_id inner join 
                    carmechanic.m_repair re  on 
                    re.car_id = c.c_id 
                    where make = 'Toyota');
                    
                    
2;
select distinct c_id , color , first_sell_date , model_id , license_plate_number
            from carmechanic.m_owns o inner join 
            carmechanic.m_owner ow on 
            o.owner_id = ow.o_id  inner join 
            carmechanic.m_car c on c.c_id = o.car_id
            inner join carmechanic.m_repair re on 
            re.car_id = c.c_id inner join carmechanic.m_workshop ws
            on ws.w_id = re.workshop_id
            where ow.address like 'Eger%'
            and ws.address like 'Eger%'
 ;



3;
select model_id ,make ,cm_name, sum(repair_cost)
from carmechanic.m_car c inner join 
carmechanic.m_repair re on 
re.car_id = c.c_id  inner join 
carmechanic.m_car_model cm on
c.model_id = cm.cm_id
group by model_id ,make ,cm_name
order by sum(repair_cost) asc
fetch first 5 rows with ties;



4;
create table relative (
re_id char(10) constraint re_pk primary key,
name varchar2(40) constraint re_nm not null,
gender varchar2(10) ,
birth_date date , 
mechanic number(5),
constraint re_fk foreign key (mechanic) references m_mechanic(m_id)
)
drop table relative;


5;
drop table m_workshop cascade constraints;
drop table m_mechanic cascade constraints;
drop table m_works_for cascade constraints;



6;
create table m_car_model as select * from carmechanic.m_car_model where 0=1;
insert into m_car_model
select cm_id , cm_name , make , details
from carmechanic.m_car_model cm 
 left outer join 
carmechanic.m_car c on c.model_id = cm.cm_id
where c_id is null

;                    
rollback;

7;
update m_repair re
set end_date = sysdate,
    repair_cost = to_number(sysdate - start_date) * (select 0.1 * first_sell_price
                                            from carmechanic.m_car c where
                                            re.car_id = c.c_id)
                                            
where end_date is null and
workshop_id = (select w_id
                from carmechanic.m_workshop 
                where w_name = 'Kerekes Alex Szervize');
rollback;




8;
create view v1 as ;
select license_plate_number
from carmechanic.m_car 
where color = 'gray'
order by first_sell_price desc nulls last
fetch first row with ties
;

9;
create view v2 as;
select color , license_plate_number , first_sell_price
from carmechanic.m_car 
where (color , first_sell_price )in (select color, max(first_sell_price)
                from carmechanic.m_car c
                group by color )

;


10;
revoke all privileges on m_car from public;




    ***************************************
    
    
    
1;
select distinct m_name , address , tax_number 
from carmechanic.m_mechanic m inner join
carmechanic.m_works_for wf on 
wf.mechanic_id = m.m_id
where salary < (select min(salary) 
                from carmechanic.m_works_for wf
                inner join carmechanic.m_workshop w on
                wf.workshop_id = w.w_id
                where w.w_name = 'Harmat Kft.' );
    
    
2;
select o_name from carmechanic.m_owner 
where o_id in (
                select distinct o_id 
                from carmechanic.m_owner ow inner join
                carmechanic.m_owns o on ow.o_id = o.owner_id
                inner join carmechanic.m_car c on c.c_id = o.car_id 
                inner join carmechanic.m_car_model cm on cm.cm_id = c.model_id
                where make != 'Opel');
                
                
3;
select model_id , avg(price)
from carmechanic.m_car c inner join 
carmechanic.m_car_evaluation ev on 
c.c_id = ev.car_id 
group by model_id
order by avg(price) asc 
fetch first 3 rows with ties
;
              

4;
create table work_plan(
workday date  default sysdate,
mechanic_id number(5) ,
workshop_id number(5),
constraint wk_fk_m foreign key (mechanic_id) references m_mechanic(m_id),
constraint wk_fk_w foreign key (workshop_id) references m_workshop(w_id),
constraint wk_pk primary key (workday , mechanic_id)
);
create table m_mechanic as select * from carmechanic.m_mechanic;
create table m_workshop as select * from carmechanic.m_workshop;
alter table m_mechanic add primary key (m_id);
alter table m_workshop add primary key (w_id);
            
            

5;
drop table m_owner ;
drop table m_owns cascade constraints;


6;
delete from 
m_works_for wf 
where workshop_id in (select w_id
                    from carmechanic.m_workshop w
                    where w_name = 'Kerekes Alex Szervize'
                    )
and end_of_employment is null;
rollback;



7;
update m_repair re
set repair_cost = repair_cost - (select 0.1* first_sell_price
                            from carmechanic.m_car c
                            where c.c_id = re.car_id)
where car_id in (select c_id 
                from carmechanic.m_car c
                where color in ('red' , 'black')
                and first_sell_price is not null)
;
rollback;


8;
create view v1 as ;
select w_name , to_number(end_date - start_date)repair_time
from carmechanic.m_workshop ws inner join
carmechanic.m_repair re on ws.w_id = re.workshop_id
order by repair_time desc nulls last
fetch first row with ties




9;
create view v1 as ;
select to_char(evaluation_date , 'yyyy')
from carmechanic.m_car_evaluation ev
group by to_char(evaluation_date , 'yyyy')
order by count(car_id) desc nulls last
fetch first row with ties;


10;
grant all privileges on m_car to public;




        ****************************************************************
        



1;
select m_name , address , tax_number
from carmechanic.m_works_for wf inner join
carmechanic.m_mechanic m on m.m_id = wf.mechanic_id
where salary < ( select min(salary)
                from carmechanic.m_works_for wf 
                inner join carmechanic.m_workshop w
                on wf.workshop_id = w.w_id
                where w_name = 'Harmat Kft.')
;



2;
select *
from carmechanic.m_car 
where to_char(first_sell_date , 'yyyy') = '2006'
or model_id in (select cm_id
                from carmechanic.m_car_model cm
                where make = 'Opel')
;


3;
select license_plate_number , price
from carmechanic.m_car c inner join carmechanic.m_car_evaluation ev
on c.c_id = ev.car_id where (c_id , price) in 
                            (select car_id , price
                            from carmechanic.m_car_evaluation ev
                            inner join carmechanic.m_car c on 
                            c.c_id = ev.car_id 
                            order by price asc
                            fetch first 10 rows with ties)
order by price desc nulls last
;


4;
drop table work_plan;
create table work_plan(
workday date default sysdate,
mechanic_id number(5) ,
workshop_id number(5) ,
constraint wp_pk primary key (workday , mechanic_id),
constraint wp_fk_m foreign key (mechanic_id) references m_mechanic(m_id),
constraint wp_fk_w foreign key (workshop_id) references m_workshop(w_id)
);
create table m_workshop as select * from carmechanic.m_workshop;





5;
drop table m_mechanic cascade constraints;




6;
delete from 
m_repair
where car_id in (select c_id
                from carmechanic.m_car where color = 'black')
and to_char(end_date , 'yyyy') = '2018';

rollback;




7;
update m_mechanic
set address = (select address
                from carmechanic.m_mechanic
                order by birth_date asc
                fetch first row only)
where m_id = (select m_id
                from carmechanic.m_mechanic
                order by birth_date desc
                fetch first row only)
;
rollback;
create table m_mechanic as select * from carmechanic.m_mechanic;




8;
create view v1 as;
select w_name , ws.address , m_name , m.address
from carmechanic.m_workshop ws inner join
carmechanic.m_mechanic m on ws.manager_id = m.m_id
where ws.address like 'Debrecen%'
and m.address not like 'Debrecen%';




9;





10;
grant select on m_mechanic to dzsoni;




             *******************************************
    
    
    
    
    
    
    
    
    
    
1;
select *
from carmechanic.m_repair re 
inner join carmechanic.m_car c on 
c.c_id = re.car_id 
where repair_cost < (select min(repair_cost)
                    from carmechanic.m_repair re 
                    inner join carmechanic.m_car c on 
                    c.c_id = re.car_id inner join 
                    carmechanic.m_car_model cm 
                    on cm.cm_id = c.model_id 
                    where make = 'Suzuki');
                    
                    
                    
2;
select w_id , w_name 
from carmechanic.m_workshop 
where w_id not in (
                        select distinct w_id 
                        from carmechanic.m_works_for wf 
                        inner join carmechanic.m_mechanic m on 
                        m.m_id = wf.mechanic_id inner join 
                        carmechanic.m_workshop ws on 
                        ws.w_id = wf.workshop_id
                        where m.address  like 'Eger%');
                        
                        
                        
3;
select model_id,cm_name,make , sum(repair_cost)
from carmechanic.m_car c inner join 
carmechanic.m_repair re on c.c_id = re.car_id
inner join carmechanic.m_car_model cm on 
cm.cm_id = c.model_id
group by model_id ,cm_name,make 
order by sum(repair_cost) asc
fetch first 5 rows with ties;



4;
create table training (
tr_id char(10),
name varchar2(20),
description varchar2(50),
start_date date , 
end_date date ,
cost number(5),
mechanic_id number(5),
constraint tr_fk foreign key (mechanic_id) references m_mechanic(m_id),
constraint tr_pk primary key (tr_id ,mechanic_id)
);
drop table training;
alter table m_mechanic add primary key (m_id);



5;
select * from m_mechanic;
alter table m_mechanic
drop column phone 
;


6;
drop table m_car_model;
create table m_car_model as select * from carmechanic.m_car_model where 0=1;
insert into m_car_model
select cm_id , cm_name , make , details
from carmechanic.m_car_model cm left outer join
carmechanic.m_car c on c.model_id = cm.cm_id
where c_id is  null;
rollback;


7;
drop table m_repair;
create table m_repair as select * from carmechanic.m_repair;
update m_repair re
set end_date = sysdate,
    repair_cost = to_number(sysdate - start_date) * (select 0.1 * first_sell_price
                                    from carmechanic.m_car c 
                                    where c.c_id = re.car_id)
where end_date is null and 
workshop_id =  (select w_id from carmechanic.m_workshop       
            where w_name = 'Kerekes Alex Szervize');
            
rollback;




8;
create view v1 as ;
select cm_name ,make
from carmechanic.m_car_model cm 
left outer join carmechanic.m_car c
on c.model_id = cm.cm_id
where c_id is null;



9;
create view v1 as ;
select license_plate_number ,nvl(o_name , 'no owner')
from carmechanic.m_car c left outer join
carmechanic.m_owns o on o.car_id = c.c_id 
left outer join carmechanic.m_owner ow on 
ow.o_id = o.owner_id 
where (car_id , date_of_buy) in 
                    (select car_id , max(date_of_buy)
                    from carmechanic.m_car c inner join
                    carmechanic.m_owns o on o.car_id = c.c_id 
                    inner join carmechanic.m_owner ow on 
                    ow.o_id = o.owner_id
                    group by car_id )
or c_id in (select c_id
                    from carmechanic.m_car c left outer join
                    carmechanic.m_owns o on o.car_id = c.c_id 
                    left outer join carmechanic.m_owner ow on 
                    ow.o_id = o.owner_id
                    where o_id is null)

;
create table m_owns as select * from carmechanic.m_owns;
grant insert , update on m_owns to dzsoni;



            *************************************************



1;
select distinct cm_name , make 
from carmechanic.m_car_model cm inner join
carmechanic.m_car c on c.model_id = cm.cm_id
where c_id in (select car_id from carmechanic.m_car_evaluation)
order by make , cm_name;




2;
select w_name , w_id
from carmechanic.m_workshop 
where w_id not in (select workshop_id 
                    from carmechanic.m_works_for wf
                    inner join carmechanic.m_mechanic m
                    on m.m_id = wf.mechanic_id
                    where address like 'Eger%');




3;
select model_id , avg(price)
from carmechanic.m_car_evaluation ev inner join
carmechanic.m_car c on c.c_id = ev.car_id
group by model_id
order by avg(price)
fetch first 3 rows with ties;



4;
create table insurance(
in_number char(8) constraint in_pk primary key ,
car_id number(5),
owner_id number(5),
owner_email varchar2(40) constraint in_nn not null,
start_date date,
end_date date,
monthly_cost number(5) constraint in_ch check(monthly_cost > 10000) ,
constraint in_fk_c foreign key (car_id) references m_car(c_id),
constraint in_fk_o foreign key (owner_id) references m_owner(o_id)
);
create table m_owner as select * from carmechanic.m_owner;
alter table m_owner add primary key(o_id);
create table m_car as select * from carmechanic.m_car;
alter table m_car add primary key(c_id);
drop table insurance;




5;
alter table m_owns
drop  primary key;


6;
create table m_car_make as select * from carmechanic.m_car_make;
delete from 
m_car_make 
where brand not in (select make
                    from carmechanic.m_car_model);
rollback;




7;
update m_repair re
set repair_cost = repair_cost - (select 0.1 * first_sell_price
                                from carmechanic.m_car c
                                where c.c_id = re.car_id)
where car_id in (select c_id
            from carmechanic.m_car c
            where color in ('red','black')
            and first_sell_price is not null);
rollback;






8;
create view v1 as;
select w_name , (end_date - start_date)repair_time
from carmechanic.m_repair re inner join
carmechanic.m_workshop w on 
re.workshop_id = w.w_id
order by repair_time desc nulls last
fetch first row with ties;



9;
create view v2 as ;
select to_char(evaluation_date ,'yyyy') , count(car_id)
from carmechanic.m_car_evaluation ev
group by to_char(evaluation_date ,'yyyy')
order by count(car_id) desc nulls last
fetch first row with ties;




10;
grant all privileges on m_car to public;
revoke all privileges on m_car from public;







        ***************************************************
        



1;
select distinct cm_name , make 
from carmechanic.m_car c inner join
carmechanic.m_car_model cm on
cm.cm_id = c.model_id
where c_id in (select car_id from 
            carmechanic.m_car_evaluation);
            
            
            
            
            
2;
select c_id , color , first_sell_date , first_sell_price , model_id ,license_plate_number
from carmechanic.m_car c inner join 
carmechanic.m_car_model cm on 
c.model_id = cm.cm_id 
where to_char(first_sell_date , 'yyyy') = '2006'
or make = 'Opel';


3;
select license_plate_number , price
from carmechanic.m_car_evaluation ev
inner join carmechanic.m_car c on ev.car_id = c.c_id
order by price desc nulls last
fetch first 5 rows with ties;



4;
create table insurance(
in_number char(8) constraint in_pk primary key,
car_id number(5) ,
owner_id number(5),
owner_email varchar2(40) constraint in_nn not null,
start_date date ,
end_date date,
monthly_cost number(5) constraint in_ch check(monthly_cost > 10000),
constraint in_fkc foreign key (car_id) references m_car(c_id),
constraint in_fko foreign key (owner_id) references m_owner(o_id)
);
drop table insurance;




5;
alter table m_mechanic
drop column phone;
create table m_mechanic as select * from carmechanic.m_mechanic;




6;
drop table m_car_model;
create table m_car_model as select * from carmechanic.m_car_model where 0=1;
insert into m_car_model
select *
from carmechanic.m_car_model cm 
where details like '%airbag%'

;
rollback;



7;
update m_repair
set repair_cost = 1.1 *repair_cost
where workshop_id = (select w_id 
                from carmechanic.m_workshop 
                where w_name = 'Kobela Bt.')
and start_date >= to_date('01012018' , 'ddmmyyyy')
and end_date <= to_date('31032019' , 'ddmmyyyy')
;
rollback;



8;










9;
create view v2 as ;
select to_char(evaluation_date ,'yyyy') , count(car_id)
from carmechanic.m_car_evaluation ev
group by to_char(evaluation_date ,'yyyy')
order by count(car_id) desc nulls last
fetch first row with ties;



10;
grant all privileges on m_car to public;
revoke all privileges on m_car from public;







            **************************************
            

1;
select distinct cm_name , make
from carmechanic.m_car_model cm 
inner join carmechanic.m_car c on 
cm.cm_id = c.model_id where
c_id in (select car_id from carmechanic.m_car_evaluation)
order by make , cm_name;




2;
select *
from carmechanic.m_car where c_id not in 
                        (select car_id from 
                        carmechanic.m_car_evaluation); 



3;
select m_name , salary
from carmechanic.m_works_for wf inner join
carmechanic.m_mechanic m on m.m_id = wf.mechanic_id
where workshop_id = (select w_id
                    from carmechanic.m_workshop
                    where w_name = 'Kobela Bt.')
order by salary desc nulls last
fetch first 2 rows with ties;




4;
create table insurance(
in_number char(8) constraint in_pk primary key,
car_id number(5) ,
owner_id number(5),
owner_email varchar2(40) constraint in_nn not null,
start_date date ,
end_date date,
monthly_cost number(5) constraint in_ch check(monthly_cost > 10000),
constraint in_fkc foreign key (car_id) references m_car(c_id),
constraint in_fko foreign key (owner_id) references m_owner(o_id)
);
drop table insurance;




5;
drop table m_owner cascade constraints;
drop table m_owns;



6;
create table m_owner as select * from carmechanic.m_owner where 0=1;
insert into m_owner
select *
from carmechanic.m_owner 
where o_id in (select distinct o_id
                from carmechanic.m_owner ow 
                inner join carmechanic.m_owns o
                on o.owner_id = ow.o_id inner join 
                carmechanic.m_car c on c.c_id = o.car_id
                inner join carmechanic.m_car_model cm
                on cm.cm_id = c.model_id
                where make = 'Toyota');
rollback;





7;
update m_repair re
set repair_cost = repair_cost - (select 0.1 * first_sell_price
                                from carmechanic.m_car c
                                where c.c_id = re.car_id)
where car_id in (select c_id
            from carmechanic.m_car c
            where color in ('red','black')
            and first_sell_price is not null);
rollback;



8;
create view v1 as;
select make , cm_name
from carmechanic.m_car_model cm
left outer join carmechanic.m_car c 
on c.model_id = cm.cm_id
where c_id is null;




9;
create view v1 as;
select make , cm_name 
from carmechanic.m_car c inner join
carmechanic.m_car_model cm on 
c.model_id = cm.cm_id 
group by make , cm_name
order by count(c_id) desc nulls last
fetch first row with ties;



10;
revoke select on m_mechanic from dzsoni;
grant select on m_mechanic to dzsoni;









