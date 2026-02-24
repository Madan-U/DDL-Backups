-- Object: PROCEDURE dbo.rpt_cldetail1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_cldetail1    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetail1    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetail1    Script Date: 20-Mar-01 11:38:54 PM ******/





/****** Object:  Stored Procedure dbo.rpt_cldetail1    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldetail1    Script Date: 12/27/00 8:59:08 PM ******/

/* report : client details
file : dpreport.asp */
/* changed by mousami on 05/03/2001
     added family login */


CREATE PROCEDURE 
rpt_cldetail1
@statusid varchar(15),
@statusname varchar(25),
@dpid varchar(12),
@cltdpno varchar(12)
AS
if @statusid='broker'
begin
select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,b.BankId ,m.CltDpno  
,b.bankname from client1 c1, multicltid m,
client4 c2 , bank b 
where c2.party_code=m.party_code and 
c1.cl_code=c2.cl_code
and m.cltdpno = c2.cltdpid
and c2.instru = '1'
and c2.depository = 'NSDL'
and b.bankid=m.dpid and m.party_code in 
(select distinct party_code from multicltid m1 where 
 m1.dpid =@dpid and m1.cltdpno like ltrim(@cltdpno)+'%')
end
if @statusid='subbroker'
begin
select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,b.BankId ,m.CltDpNo  
,b.bankname from client1 c1, multicltid m, subbrokers sb,
client4 c2 , bank b 
where c2.party_code=m.party_code and 
c1.cl_code=c2.cl_code
and m.cltdpno = c2.cltdpid
and c2.instru = '1'
and c2.depository = 'NSDL'
and b.bankid=m.dpid and m.party_code in 
(select distinct party_code from multicltid m1 where 
m1.dpid =@dpid and m1.cltdpno like  ltrim(@cltdpno)+'%')
and sb.sub_broker=@statusname
and sb.sub_broker=c1.sub_broker
end
if @statusid='branch'
begin
select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,b.BankId ,m.CltDpNo  
,b.bankname from client1 c1, multicltid m, branches br,
client4 c2 , bank b 
where c2.party_code=m.party_code and 
 c1.cl_code=c2.cl_code
and m.cltdpno = c2.cltdpid
and c2.instru = '1'
and c2.depository = 'NSDL'
and b.bankid=m.dpid and m.party_code in 
(select distinct party_code from multicltid m1 where 
m1.dpid =@dpid  and m1.cltdpno like ltrim(@cltdpno)+'%')
and br.branch_cd=@statusname
and br.short_name=c1.trader
end
if @statusid='trader'
begin
select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,b.BankId ,m.CltDpNo  
,b.bankname from client1 c1, multicltid m,  
client4 c2 , bank b 
where c2.party_code=m.party_code and 
 c1.cl_code=c2.cl_code
and m.cltdpno = c2.cltdpid
and c2.instru = '1'
and c2.depository = 'NSDL'
and b.bankid=m.dpid and m.party_code in 
(select distinct party_code from multicltid m1 where 
m1.dpid =@dpid and m1.cltdpno like ltrim(@cltdpno)+'%')
and c1.trader=@statusname 
end
if @statusid='client'
begin
select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,b.BankId ,m.CltDpNo  
,b.bankname from client1 c1, multicltid m,  
client4 c2 , bank b 
where c2.party_code=m.party_code and 
c1.cl_code=c2.cl_code
and m.cltdpno = c2.cltdpid
and c2.instru = '1'
and c2.depository = 'NSDL'
and b.bankid=m.dpid and m.party_code in 
(select distinct party_code from multicltid m1 where 
m1.dpid =@dpid and m1.cltdpno like ltrim(@cltdpno)+'%')
and c2.party_code=@statusname 
end
if @statusid='family'
begin
select distinct c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,
c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,
c1.trader,b.BankId ,m.CltDpno  
,b.bankname from client1 c1, multicltid m,
client4 c2 , bank b , client2 cl2
where c2.party_code=m.party_code and 
c1.cl_code=c2.cl_code
and m.cltdpno = c2.cltdpid
and c2.instru = '1'
and c2.depository = 'NSDL'
and b.bankid=m.dpid and m.party_code in 
(select distinct party_code from multicltid m1 where 
 m1.dpid =@dpid and m1.cltdpno like ltrim(@cltdpno)+'%')
and c1.cl_code=cl2.cl_code
and  c1.family=@statusname
end

GO
