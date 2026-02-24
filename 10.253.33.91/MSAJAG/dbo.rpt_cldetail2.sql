-- Object: PROCEDURE dbo.rpt_cldetail2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_cldetail2    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetail2    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetail2    Script Date: 20-Mar-01 11:38:54 PM ******/





/****** Object:  Stored Procedure dbo.rpt_cldetail2    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetail2    Script Date: 12/27/00 8:58:53 PM ******/
/* changed by mousami on 05/03/2001 
     added family login */

CREATE PROCEDURE 
rpt_cldetail2
@statusid varchar(15),
@statusname varchar(25),
@dpid varchar(12),
@cldpno varchar(12)
AS
if @statusid='broker'
begin
  select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
 c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,c2.BankId ,c2.CltDpid 
 from client1 c1,client4 c2 
 where c1.cl_code = c2.cl_code 
 and c2.BankId =@dpid 
and c2.CltDpid=@cldpno
and c2.instru = '1'
and c2.depository = 'NSDL'
end
if @statusid='subbroker'
begin
 select distinct  c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
 c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,c2.BankId ,c2.CltDpid 
 from client1 c1,client4 c2 ,subbrokers sb
 where c1.cl_code = c2.cl_code 
 and c2.BankId=@dpid 
and c2.CltDpid =@cldpno
and c2.instru = '1'
and c2.depository = 'NSDL'
and sb.sub_broker=@statusname
and sb.sub_broker=c1.sub_broker
end
if @statusid='branch'
begin
select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,c2.BankId ,c2.CltDpid
from client1 c1,client4 c2 ,branches br
 where c1.cl_code = c2.cl_code 
 and c2.BankId = @dpid 
and c2.CltDpid =@cldpno
and c2.instru = '1'
and c2.depository = 'NSDL'
and br.branch_cd=@statusname
and br.short_name=c1.trader
end
if @statusid='trader'
begin
select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,c2.BankId ,c2.CltDpid
from client1 c1,client4 c2  
 where c1.cl_code = c2.cl_code 
 and c2.BankId = @dpid 
and c2.CltDpid=@cldpno
and c2.instru = '1'
and c2.depository = 'NSDL'
 and c1.trader =@statusname
end
if @statusid='trader'
begin
select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,c2.BankId ,c2.CltDpid
from client1 c1,client4 c2  
 where c1.cl_code = c2.cl_code 
 and c2.BankId = @dpid 
and c2.CltDpid = @cldpno
and c2.instru = '1'
and c2.depository = 'NSDL'
 and c2.party_code= @statusname
end
if @statusid='family'
begin
  select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
 c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,c2.BankId ,c2.CltDpid 
 from client1 c1,client4 c2 , client2 cl2
 where c1.cl_code = c2.cl_code 
 and c2.BankId =@dpid 
and c2.CltDpid=@cldpno
and c2.instru = '1'
and c2.depository = 'NSDL'
and c1.cl_code=cl2.cl_code
and c1.family=@statusname
end

GO
