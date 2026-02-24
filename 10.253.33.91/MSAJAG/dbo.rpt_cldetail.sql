-- Object: PROCEDURE dbo.rpt_cldetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_cldetail    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetail    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetail    Script Date: 20-Mar-01 11:38:54 PM ******/





/****** Object:  Stored Procedure dbo.rpt_cldetail    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetail    Script Date: 12/27/00 8:58:53 PM ******/

/* report : client details
   file: client report.asp
gives personal details of the clients
*/
/* changed by mousami on 05/03/2001 
    added family login 
*/

CREATE PROC
rpt_cldetail
@statusid varchar(15),
@statusname varchar(25),
@partyname varchar(21),
@partycode varchar(6),
@add1 varchar(40),
@add2 varchar(40)
 AS
if @statusid='broker'
begin
 select distinct  c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city ,c1.L_Zip,
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,c1.trader,
c4.BankId ,C4.CltDpid 
from Client2 C2,client1 c1 left Outer Join client4 c4
On ( c1.cl_code = c4.cl_code )
where c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' 
 and c2.party_code like ltrim(@partycode)+'%' 
and (c1.L_Address1 like ltrim(@add1)+'%' 
 or c1.L_Address2 like ltrim(@add2)+'%' )
 order by c1.Short_Name,c2.party_code
end
if @statusid='subbroker'
begin
select distinct  c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city, c1.L_Zip,
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,c1.trader,
c4.BankId ,c4.CltDpid
from subbrokers sb,Client2 C2,client1 c1 Left Outer Join client4 c4
On ( c1.cl_code = c4.cl_code )
where c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' 
and c2.party_code like ltrim(@partycode)+'%' 
and (c1.L_Address1 like ltrim(@add1)+'%' 
or c1.L_Address2 like ltrim(@add2)+'%' )
and sb.sub_broker=c1.sub_broker
and sb.sub_Broker=@statusname
order by c1.Short_Name,c2.party_code
end
if @statusid='branch'
begin
 select distinct  c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip,
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,c1.trader,
c4.BankId ,c4.CltDpid 
from Client2 C2,branches b,client1 c1 Left Outer Join client4 c4
On ( c1.cl_code = c4.cl_code )
where c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' 
 and c2.party_code like ltrim(@partycode)+'%' 
and (c1.L_Address1 like ltrim(@add1)+'%'
 or c1.L_Address2 like ltrim(@add2)+'%' )
and b.branch_cd=@statusname
and b.short_name=c1.trader
 order by c1.Short_Name,c2.party_code
end
if @statusid='trader'
begin
 select distinct  c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip,
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,c1.trader,
c4.BankId ,c4.CltDpid 
from Client2 C2,client1 c1 Left Outer Join client4 c4
On ( c1.cl_code = c4.cl_code )
where c1.cl_code = c2.cl_code 
and c1.short_name like  ltrim(@partyname)+'%' 
 and c2.party_code like ltrim(@partycode)+'%' 
and (c1.L_Address1 like ltrim(@add1)+'%'
 or c1.L_Address2 like ltrim(@add2)+'%' )
and c1.trader=@statusname
 order by c1.Short_Name,c2.party_code
end
if @statusid='client'
begin
 select distinct  c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip,
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,c1.trader,
c4.BankId ,c4.CltDpid 
from Client2 C2,client1 c1 Left Outer Join client4 c4
On ( c1.cl_code = c4.cl_code )
where c1.cl_code = c2.cl_code 
and c1.short_name like  ltrim(@partyname)+'%' 
 and c2.party_code like ltrim(@partycode)+'%' 
and (c1.L_Address1 like ltrim(@add1)+'%'
 or c1.L_Address2 like ltrim(@add2)+'%' )
and c2.party_code=@statusname
order by c1.Short_Name,c2.party_code
end
if @statusid='family'
begin
select distinct  c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city ,c1.L_Zip,
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,c1.trader,
c4.BankId ,c4.CltDpid 
from Client2 C2,client1 c1 Left Outer Join client4 c4
On ( c1.cl_code = c4.cl_code )
where c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' 
 and c2.party_code like ltrim(@partycode)+'%' 
and (c1.L_Address1 like ltrim(@add1)+'%' 
 or c1.L_Address2 like ltrim(@add2)+'%' )
and c1.family=@statusname
 order by c1.Short_Name,c2.party_code
end

GO
