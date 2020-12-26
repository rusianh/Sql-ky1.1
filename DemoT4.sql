/****** Script for SelectTopNRows command from SSMS  ******/
SELECT CarMake,modelyear,carmodel 
  FROM Car
  where not (carmodel like '%[^h]Land__' or carmake like 'Isu%') and carmake='Honda'
  --modelyear>2000
  order by modelyear;
--select * from newcar2000;

-- Nam san xuat cu & moi nhat
select carmake as "Hang Xe",carmodel as "Dong Xe",min(modelyear) as "Nam Dau San Xuat", max(modelyear) as "Nam San Xuat Moi Nhat" from car
group by carmake,carmodel
order by max(modelyear) asc;
-- test
select * from car where carmake='Hyundai' and carmodel='Accent';

-- Moi nam hang xe san xuat bao nhieu xe?
select carmake, modelyear, count(*), count(carmodel), count(1), count(2), count(1000) from car
group by carmake,modelyear;
-- test
select * from car where carmake='Pontiac' and modelyear='1986';
-- update
update car set carmodel=null where id=590;

with car500 as (select * from car where id<500)
select * from car500 where modelyear>2005;

select * from car where modelyear>2005 and id<500;

select * from (select carmake,carmodel,modelyear from car where id<500) as car500 where modelyear>2005;

select * from car;
-- Chi co aggregate, khong co field -> khong can group by
select min(modelyear),max(modelyear) from car;


select carmake, modelyear, count(carmodel), count(1) from car
--where count(1)>3
group by carmake,modelyear having count(1)>3;
select carmake, modelyear, count(carmodel), count(1) from car
group by carmake,modelyear 
--with cube
with rollup
;

select carmake,avg(cast(modelyear as int)) from car group by carmake with rollup;

-- Tim cac xe co nam san xuat > trung binh nam san xuat cua tat ca cac xe?
-- Tim xe co nam san xuat > nam 2000
select * from car where modelyear>2000;
-- Trung binh nam san xuat cua tat ca xe
select avg(cast(modelyear as int)) from car;
-- Xu ly dieu kien ban dau = cach gop 2 query lai
select * from car where modelyear>(select avg(cast(modelyear as int)) from car);
-- Lay tat ca xe co id la id cua xe BMW
-- Lay tat ca xe co id nam trong danh sach 1,2,5,7
select * from car where id in (1,2,5,7);
-- Lay danh sach id cua xe BMW
select * from car where carmake='BMW';
select id from car where carmake='BMW';
-- Xu ly yeu cau ban dau
select * from car where id in (select id from car where carmake='BMW');

-- Lay ra tat ca xe, nam san xuat, trung binh nam san xuat cua tat ca xe co trong bang CAR, so sanh nam san xuat voi nam trung binh, neu > thi ghi la xe moi, < ghi la xe cu
select *,(select avg(cast(modelyear as int)) from car) as trungbinhnam
,CASE WHEN cast(modelyear as int) > (select avg(cast(modelyear as int)) from car) THEN 'Xe moi' ELSE 'Xe cu' END
from car;

select *, case when cast(modelyear as int) > trungbinhnam then 'Xe moi' when cast(modelyear as int) = trungbinhnam then 'Xe trung binh' else 'Xe cu' END as DanhGia FROM (
select *,(select avg(cast(modelyear as int)) from car) as trungbinhnam
from car) as a;
-- DL xe Audi
select * from car where carmake='Audi';
-- DL xe BMW
select * from car where carmake='BMW';
-- DL cua xe Audi va BMW
select * from car where carmake='BMW' or carmake='Audi';
select * from car where carmake='BMW' and modelyear>2000
union all
select * from car where carmake='Audi' and modelyear>2005;