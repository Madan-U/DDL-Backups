-- Object: PROCEDURE dbo.activecli
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure [dbo].[activecli](@df as datetime, @dt as datetime )
as
select x.branch_cd,x.sub_broker,x.party_code,x.Short_name,x.Status,x.remarks,x.maxdate,x.mindate 
from (select distinct b.branch_cd,b.sub_broker,party_code=isnull(A.Party_code,b.party_code), 
b.Short_Name,e.status,remarks=e.pname,d.maxdate,d.mindate 
from (select x.*,y.party_code from Client1 x, client2 y where x.cl_Code=y.cl_code and
y.party_code in (Select distinct party_code from cmbillvalan 
where Sauda_Date >= @df and Sauda_Date <= @dt)) b
left outer join 

(select cl_code=party_code, pname=pan_gir_no, status='Duplicate PAN No.' from 
(select x.*,y.party_code  from Client1 x, client2 y, 
(select * from angelfo.nsefo.dbo.client5 where activefrom <= @df and Inactivefrom >= @dt) z 
where x.cl_Code=y.cl_code and x.cl_code = z.cl_code and
y.party_code in (Select distinct party_code from cmbillvalan 
where Sauda_Date >= @df and Sauda_Date <= @dt ))
cli1 where Pan_gir_no in 
( select Pan_gir_no from 
(select x.pan_gir_no from Client1 x, client2 y where x.cl_Code=y.cl_code and
y.party_code in (Select distinct party_code from cmbillvalan 
where Sauda_Date >= @df and Sauda_Date <= @dt )) cl1
where Pan_gir_no is not null and LEn(Pan_gir_no) > 0 
group by Pan_gir_no having count(Pan_gir_no) > 1 
) union 


(
select cl_code=party_code, 
pname=replace(replace(REPLACE(short_name,' ',' '),' ',' '),'.',' '), status='Duplicate Name' 
from client1, client2 where client1.cl_Code=client2.cl_code
and replace(replace(REPLACE(short_name,' ',' '),' ',' '),'.',' ') in 
( 
select shortname=replace(replace(REPLACE(short_name,' ',' '),' ',' '),'.',' ') from 
(
select x.short_name  from Client1 x, client2 y where x.cl_Code=y.cl_code and
y.party_code in (Select distinct party_code from cmbillvalan 
where Sauda_Date >= @df and Sauda_Date <= @dt )
) aa

group by replace(replace(REPLACE(short_name,' ',' '),' ',' '),'.',' ') having 
count(replace(replace(REPLACE(short_name,' ',' '),' ',' '),'.',' ')) > 1 )) ) e LEFT OUTER JOIN 
(Select * from cmbillvalan where Sauda_Date >= @df and Sauda_Date <= @dt) a 
left outer join (select party_code,maxdate=max(sauda_date), mindate=min(sauda_date) from cmbillvalan
group by party_code) d on d.party_code=a.party_code ON A.PARTY_cODE = E.CL_CODE on e.cl_Code=b.cl_code, 
AngelNseCM.msajag.dbo.ClientMaster c where b.Cl_code=c.Cl_code ) x where x.mindate is not null order by x.remarks

GO
