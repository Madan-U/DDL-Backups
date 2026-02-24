-- Object: PROCEDURE dbo.sbmtomscripname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmtomscripname    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscripname    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscripname    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscripname    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscripname    Script Date: 12/27/00 8:59:00 PM ******/

/***  file :mtomreport.asp
     report :mtom  ***/
CREATE PROCEDURE  sbmtomscripname
@subbroker varchar(15),
@partycode varchar(10),
@partyname varchar(21)
AS
 select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),
s.sell_buy,c1.short_name,c2.party_code,sum(s.N_NetRate) 
from settlement s,client1 c1,client2 c2,subbrokers sb 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code  and c1.sub_Broker=sb.sub_broker 
and sb.sub_broker =@subbroker  and
s.billno ='0' and s.sett_type='N' and s.party_code like  ltrim(@partycode)+'%'  and 
c1.short_name like ltrim(@partyname)+ '%'  
group by c1.short_name,c2.party_code,s.scrip_cd ,s.series,s.sell_buy

GO
