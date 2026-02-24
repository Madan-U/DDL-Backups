-- Object: PROCEDURE dbo.sbscripname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbscripname    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbscripname    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbscripname    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbscripname    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbscripname    Script Date: 12/27/00 8:59:01 PM ******/

/*** file :positionreport.asp
     report :client position 
displays details of asettlement for a particular client
**/
CREATE PROCEDURE sbscripname
@subbroker varchar(15),
@partycode varchar(10),
@partyname varchar(21),
@scripname varchar(10),
@settno varchar(7),
@settype varchar(3)
AS
select s.party_code,c1.short_name,s.scrip_cd,s.series,Quantity = sum(s.tradeqty),
Amount = sum(s.amount),s.sell_buy from settlement s,client1 c1,client2 c2 ,subbrokers sb 
where s.party_code = c2.party_code 
and c1.cl_code = c2.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker  and s.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+ '%' and 
s.scrip_cd like ltrim(@scripname)+ '%' and s.sett_no = @settno and s.sett_type= @settype 
group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy

GO
