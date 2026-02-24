-- Object: PROCEDURE dbo.sbhisposrep1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbhisposrep1    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbhisposrep1    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbhisposrep1    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbhisposrep1    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbhisposrep1    Script Date: 12/27/00 8:59:00 PM ******/

/*** file :hispositionreport.asp
     report :historyposition  
displays scripwise details  of a subbroker's client for a particular settlement
 ***/
CREATE PROCEDURE 
sbhisposrep1
@partycode varchar(10),
@partyname varchar(21),
@scripname varchar(10),
@settno varchar(7),
@settype varchar(3),
@subbroker varchar(15)
 AS
select s.party_code,c1.short_name,s.scrip_cd,s.series,Quantity = sum(s.tradeqty),
Amount = sum(s.amount),s.sell_buy,s.sett_no,s.sett_type 
from history s,client1 c1,client2 c2,SUBBROKERS SB 
where s.party_code = c2.party_code and c1.cl_code = c2.cl_code and s.party_code like ltrim(@partycode)+'%' and 
c1.short_name like ltrim(@partyname)+'%' and s.scrip_cd like ltrim(@scripname)+'%' and s.sett_no = @settno
and s.sett_type = @settype  and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker
group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy

GO
