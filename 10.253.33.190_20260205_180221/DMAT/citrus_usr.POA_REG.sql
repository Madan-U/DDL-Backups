-- Object: VIEW citrus_usr.POA_REG
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE VIEW POA_REG
AS 
select a.* from 
(select POARegNum,masterpoaid,poam_name1,boid  from dps8_pc5
left outer join 
poam on MasterPOAId =poam_master_id )a
inner join 
(select max(POARegNum)POARegNum ,boid from dps8_pc5 group by boid )c
on c.POARegNum=a.POARegNum and a.boid=c.boid

GO
