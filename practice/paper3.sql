1;
select m_name , address , tax_number
from carmechanic.m_mechanic  m 
inner join carmechanic.m_works_for wf 
on m.m_id = wf.mechanic_id
where salary < (select min(salary)
                from carmechanic.m_works_for f
                inner join carmechanic.m_workshop ws on
                f.workshop_id = ws.w_id 
                where w_name = 'Harmat Kft.'
                group by w_name);
                
    
                

2;
select *
from carmechanic.m_car c 
where c.model_id in (select cm_id from 
                        carmechanic.m_car_model 
                        where make = 'Opel' )
or to_char(first_sell_date , 'yyyy') = '2006';



3;
select license_plate_number
from carmechanic.m_car c inner join
carmechanic.m_car_evaluation ev on
c.c_id = ev.car_id 
order by price asc
fetch first 10 rows with ties;



4;
drop table work_plan cascade constraints;
create table work_plan (
workday date default sysdate,
mechanic number(5),
workshop number(5),
constraint wp_pk primary key(workday , mechanic) ,
constraint wp_fk_m foreign key (mechanic) references m_mechanic (m_id),
constraint wp_fk_w foreign key (workshop) references m_workshop (w_id));



5;
drop table m_works_for cascade constraints ;
drop table m_workshop cascade constraints;
drop table m_mechanic cascade constraints;



6;
delete;
select * from 
m_repair
where car_id in (select c_id
                from carmechanic.m_car where color = 'black')
and to_char(end_date , 'yyyy') = '2018';

rollback;



create table m_mechanic as select * from carmechanic.m_mechanic;
7;
select * from m_mechanic
order by birth_date asc;
update m_mechanic
set address = (select address 
                from m_mechanic
                order by birth_date asc
                fetch first row only )
where m_id = (select m_id
                from m_mechanic
                order by birth_date desc
                fetch first row only );


8;
create view managers as ;
select *
from carmechanic.m_workshop w
where w.address like 'Debrecen%'
and manager_id in (select m_id 
                    from carmechanic.m_mechanic m
                    where m.address not like 'Debrecen%');
select w_name,workshop.address,m_name,mech.address , m_id , mechanic_id
from carmechanic.m_workshop workshop inner join carmechanic.m_works_for forum on workshop.w_id=forum.workshop_id
inner join carmechanic.m_mechanic mech on mech.m_id=forum.mechanic_id
where workshop.address like 'Debrecen%' and mech.address not like 'Debrecen%';


9;
create view car_model as;
select distinct(workshop_id , model_id) from (
                    select  workshop_id ,model_id, count(model_id)
                    from carmechanic.m_repair re inner join 
                    carmechanic.m_car c on c.c_id = re.car_id
                    group by workshop_id , model_id
                    order by count(model_id) desc , workshop_id)
;






;



10;

grant select on m_mechanic to dzsoni;



