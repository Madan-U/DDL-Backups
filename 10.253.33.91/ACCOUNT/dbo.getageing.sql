-- Object: PROCEDURE dbo.getageing
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.getageing    Script Date: 04/07/2003 11:54:17 AM ******/
/****** Object:  Stored Procedure dbo.getageing    Script Date: 02/18/2003 10:37:37 AM ******/
/* 
Report Name : New Ageing
Changes on - 07/01/2003
In order to change days slabs
*/
CREATE proc getageing
@sessionid varchar(30)
as
/* DELETE FROM ageinglist */
insert into ageinglist
select cltcode, balance=sum(balamt), agedays = 6, drcr, sessionid 
from fintempageing
where rtrim(sessionid) = rtrim(@sessionid) and agedays >= 0 and agedays <= 6 
group by cltcode, drcr, sessionid 
order by cltcode, drcr, sessionid 

insert into ageinglist
select cltcode, balance=sum(balamt), agedays = 29, drcr, sessionid
from fintempageing
where rtrim(sessionid) = rtrim(@sessionid) and agedays >= 7 and agedays <= 29 
group by cltcode, drcr, sessionid 
order by cltcode, drcr, sessionid 

insert into ageinglist
select cltcode, balance=sum(balamt), agedays = 90, drcr, sessionid
from fintempageing
where rtrim(sessionid) = rtrim(@sessionid) and agedays >= 30 and agedays <= 90
group by cltcode, drcr, sessionid 
order by cltcode, drcr, sessionid 

insert into ageinglist
select cltcode, balance=sum(balamt), agedays = 180, drcr, sessionid
from fintempageing
where rtrim(sessionid) = rtrim(@sessionid) and agedays >= 91 and agedays <= 180
group by cltcode, drcr, sessionid 
order by cltcode, drcr, sessionid 

insert into ageinglist
select cltcode, balance=sum(balamt), agedays = 181, drcr, sessionid
from fintempageing
where rtrim(sessionid) = rtrim(@sessionid) and agedays >= 181
group by cltcode, drcr, sessionid 
order by cltcode, drcr, sessionid

GO
