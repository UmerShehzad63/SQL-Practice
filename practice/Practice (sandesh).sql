1;
select distinct cm_name , make
from carmechanic.m_car c  inner join
carmechanic.m_car_model cm on c.model_id = cm.cm_id
where c_id in (select car_id from carmechanic.m_car_evaluation);



2;
select *
from carmechanic.m_car c inner join
carmechanic.m_car_model cm on
cm.cm_id = c.model_id
where make = 'Opel' or
to_char(first_sell_date, 'yyyy') = '2006';



3;
select * 
from carmechanic.m_car c 
where c_id in (select car_id
                from carmechanic.m_car_evaluation
                order by price desc 
                fetch first 5 rows with ties);



4;
create table insurance (
insurance_number char(8),
car_id number(5) ,
owner_id number(5),
owner_email varchar2(40),
start_date date,
end_date date,
monthly_cost number(5) constraint in_mm check(monthly_cost >10000),
constraint in_fk_c foreign key (car_id) references m_car (c_id),
constraint in_fk_o foreign key (owner_id) references m_owner(o_id));

drop table m_owner;
drop table m_car;
create table m_owner as select * from carmechanic.m_owner;
create table m_car as select * from carmechanic.m_car;
alter table m_owner add primary key (o_id);
alter table m_car add primary key (c_id);

;



5;
alter table m_mechanic
drop column phone;
drop table m_mechanic cascade constraint;
create table m_mechanic as select * from carmechanic.m_mechanic;



6;
insert into m_car_model
select *
from carmechanic.m_car_model
where details like '%airbag%';




7;
update m_repair; 
set repair_cost = repair_cost * 1.10 
WHERE start_date > TO_DATE('01012018', 'DDMMYYYY') 
  AND start_date < TO_DATE('31032019', 'DDMMYYYY')
  AND end_date > TO_DATE('01012018', 'DDMMYYYY') 
  AND end_date < TO_DATE('31032019', 'DDMMYYYY')
and  workshop_id in (select w_id 
                    from carmechanic.m_workshop 
                    where w_name = 'Kobela Bt.');



8;
create view as;
select * 
from carmechanic.m_workshop where manager_id in (
select mechanic_id
from carmechanic.m_works_for wf  inner join 
carmechanic.m_workshop w on wf.workshop_id=w.w_id  
)
;




9;
create view most_ev as
select to_char(evaluation_date , 'yyyy') , count(car_id)
from carmechanic.m_car_evaluation ev
group by to_char(evaluation_date , 'yyyy')
order by to_char(evaluation_date , 'yyyy') desc
fetch first row with ties;




10;
grant all privileges on m_car to public;











