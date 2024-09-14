select license_plate_number
from carmechanic.m_car c inner join
carmechanic.m_repair re on 
c.c_id = re.car_id 
where repair_cost < (select min(repair_cost)
                    from carmechanic.m_car c inner join
                    carmechanic.m_repair re on 
                    re.car_id = c.c_id inner join 
                    carmechanic.m_car_model cm on
                    c.model_id = cm.cm_id 
                    where make = 'Suzuki');


2;
select *
from carmechanic.m_workshop w
where w_id not in (select workshop_id
                    from carmechanic.m_works_for wf
                    inner join carmechanic.m_mechanic m
                    on m.m_id = wf.mechanic_id inner join
                    carmechanic.m_workshop w on 
                    wf.workshop_id = w.w_id 
                    where m.address like 'Eger%');
                    
                    
                    
                    
3;
select cm_id,make , cm_name , sum(repair_cost)
from carmechanic.m_repair re 
inner join carmechanic.m_car c on 
c.c_id = re.car_id inner join carmechanic.m_car_model cm
on cm.cm_id = c.model_id 
group by cm_id ,make , cm_name
order by sum(repair_cost) asc
fetch first 5 rows with ties;



4;
alter table m_mechanic add primary key(m_id);
create table trainnig (
t_id varchar2(10) , 
name varchar2(20) ,
description varchar2(50) ,
start_date date ,
end_date date ,
cost number(5) ,
mechanic number(5),
constraint t_fk foreign key (mechanic) references m_mechanic(m_id),
constraint t_pk primary key (mechanic, t_id)) ;




5;
select * from m_mechanic;
alter table m_mechanic
drop column phone ;


6;
create table m_car_model as select * from carmechanic.m_car_model where 0 =1;
insert into m_car_model;
select * 
from carmechanic.m_car_model 
where cm_id not in (select model_id 
                    from carmechanic.m_car 
                    );

create table m_repair as select * from carmechanic.m_repair;
7;
update m_repair re
set end_date = sysdate,
repair_cost = to_number( sysdate - start_date) * (select 0.1 * first_sell_price
                                    from carmechanic.m_car c where
                                    c.c_id = re.car_id)
where workshop_id = (select w_id 
                    from carmechanic.m_workshop w 
                    where w_name = 'Kerekes Alex Szervize')
and end_date is null;



8;
create view brand as
select cm_name , make
from carmechanic.m_car_model cm left outer join
carmechanic.m_car c on c.model_id = cm.cm_id 
where c_id is null
;
                
                           
                
9;
create view lpn_ow as ;
select license_plate_number , nvl(o_name , 'no owner') owner
from carmechanic.m_car c full outer join
carmechanic.m_owns ow on c.c_id = ow.car_id full outer join
carmechanic.m_owner o on o.o_id = ow.owner_id
where license_plate_number is not null
;


10;
grant insert , update on m_owner to dzsoni;











select first_name, count(*)
from (select first_name from book_library.customers
      union all
      select first_name from book_library.authors)
group by first_name      ;

