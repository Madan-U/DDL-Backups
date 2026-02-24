-- Object: PROCEDURE citrus_usr.pr_DPb9_optimise
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create  proc [citrus_usr].[pr_DPb9_optimise] (@pa_dbpath varchar(8000)) 
as
begin
drop table dps8_source111
DROP TABLE dps8_source10    
DROP TABLE dps8_source1  
truncate table dps8_source  
set dateformat ymd

declare @@SSQL varchar(1000)  
     
SET @@SSQL = 'BULK INSERT vwdps8_source FROM ''' + @pa_dbpath +  ''' WITH      
(      
      
FIELDTERMINATOR=''\n'',      
ROWTERMINATOR = ''\n''        
)'      
      
--PRINT @@SSQL      
EXEC (@@SSQL)    
  --1

SELECT ID , value 
, convert(varchar(16),case when left(value,2) ='00' then citrus_usr.fn_splitval_by(value,2,'~') else '' end) boid   
, convert(varchar(16),case when left(value,2) ='00' then citrus_usr.fn_splitval_by(value,7,'~') else '' end) lastmoddate   
INTO dps8_source10 
FROM dps8_source order by id     
--alter table dps8_source1 alter column [value] varchar(5000)  
create index ix1 on dps8_source10(id)  
create index ix2 on dps8_source10(value)  
create index ix3 on dps8_source10(boid)  
create index ix4 on dps8_source10(lastmoddate)  
--2

  
  
  
select id, value ,(select top 1 boid from dps8_source10 b where a.id >= b.id and B.boid  <> '' order by id desc) boid   
,(select top 1 lastmoddate from dps8_source10 b where a.id >= b.id and B.lastmoddate  <> '' order by id desc) lastmoddate   
into dps8_source111 from   dps8_source10 a  
where  left(value,1) not in ('H','T')   
order by id   
--3


select id, value , a.boid   
,a.lastmoddate   
into dps8_source1
 from dps8_source111 a 
, (
select boid,left(value,2) pcd
--,max(lastmoddate) lastmoddate 
,replace(convert(varchar(11),max(convert(datetime,substring(lastmoddate,5,4)+'-'+substring(lastmoddate,3,2)+'-'+substring(lastmoddate,1,2)+' ' + substring(lastmoddate,9,2)+':'+ substring(lastmoddate,11,2)+':'+substring(lastmoddate,13,2))) ,103) ,'/','')
+replace(CONVERT(VARCHAR(8), max(convert(datetime,substring(lastmoddate,5,4)+'-'+substring(lastmoddate,3,2)+'-'+substring(lastmoddate,1,2)+' ' + substring(lastmoddate,9,2)+':'+ substring(lastmoddate,11,2)+':'+substring(lastmoddate,13,2))) , 108),':','') lastmoddate 
from dps8_source111  
group by boid,left(value,2)) b
where a.boid = b.boid 
and isnull(replace(convert(varchar(11),convert(datetime,substring(a.lastmoddate,5,4)+'-'+substring(a.lastmoddate,3,2)+'-'+substring(a.lastmoddate,1,2)+' ' + substring(a.lastmoddate,9,2)+':'+ substring(a.lastmoddate,11,2)+':'+substring(a.lastmoddate,13,2)) ,103) ,'/','')
+replace(CONVERT(VARCHAR(8), convert(datetime,substring(a.lastmoddate,5,4)+'-'+substring(a.lastmoddate,3,2)+'-'+substring(a.lastmoddate,1,2)+' ' + substring(a.lastmoddate,9,2)+':'+ substring(a.lastmoddate,11,2)+':'+substring(a.lastmoddate,13,2)) , 108),':','') ,'') = isnull(b.lastmoddate ,'')
and pcd = left(value,2)
order by id  
--4
 --select * from dps8_source1
 --5
update dps8_source1 set value =  value  + '~' + boid + '~' where left(dps8_source1.value ,2) <> '00'   
--6



truncate table dpb9_source1
insert into dpb9_source1
select value from dps8_source1 order by id 

--7
  


end

GO
