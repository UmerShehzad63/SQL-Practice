1;
select m_name , address , tax_number
from carmechanic.m_works_for wf inner join
carmechanic.m_mechanic m on 
m.m_id = wf.mechanic_id 
where salary < (select min(salary)
                    from carmechanic.m_works_for w inner join
                    carmechanic.m_workshop ws on 
                    ws.w_id = w.workshop_id
                    group by w_name 
                    having w_name = 'Harmat Kft.')
                    
    
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
order by avg(price)
fetch first 3 rows with ties;


4;
create table work_plan(
workday date default sysdate,
mechanic number(5) ,
workshop number(5),
constraint wp_pk primary key(workday , mechanic),
constraint wp_fk_m foreign key (mechanic) references m_mechanic(m_id),
constraint wp_fk_w  foreign key (workshop) references m_workshop(w_id))
;


5;
drop table m_owns cascade constraints; 
drop table m_owner cascade constraints;



6;
create table m_works_for as select * from carmechanic.m_works_for;
delete
from m_works_for wf
where workshop_id in (select w_id 
                        from carmechanic.m_workshop ws
                        where w_name = 'Kerekes Alex Szervize')
and end_of_employment is null;



7;
update m_repair re
set repair_cost = repair_cost - (select 0.1 *first_sell_price
                    from carmechanic.m_car c where
                    c.c_id = re.car_id)
where car_id in (select c_id 
                from carmechanic.m_car c 
                where color in ('black' , 'red')
                and first_sell_price is not null);


             
8;
create view v1 as ;
select w_name , to_number(end_date - start_date)repair_time
from carmechanic.m_workshop ws inner join
carmechanic.m_repair re on ws.w_id = re.workshop_id
order by repair_time desc nulls last
fetch first row with ties
;



9;
create view lpn as
select license_plate_number , first_sell_price , color
from carmechanic.m_car c 
where first_sell_price in (select max(first_sell_price)
                            from carmechanic.m_car c 
                            group by color);
                            
                            
10;
revoke all privileges on m_car from public;
