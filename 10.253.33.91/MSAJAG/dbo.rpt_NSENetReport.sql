-- Object: PROCEDURE dbo.rpt_NSENetReport
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_NSENetReport    Script Date: 05/08/2002 12:35:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSENetReport    Script Date: 01/14/2002 20:33:08 ******/






/****** Object:  Stored Procedure dbo.rpt_NSENetReport    Script Date: 09/07/2001 11:09:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSENetReport    Script Date: 7/1/01 2:26:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSENetReport    Script Date: 06/26/2001 8:49:12 PM ******/


/****** Object:  Stored Procedure dbo.rpt_NSENetReport    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSENetReport    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSENetReport    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSENetReport    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSENetReport    Script Date: 12/27/00 8:58:57 PM ******/

/* report : NetPosition report
   file : NSENetReport.asp */
/* displays Netposition report for a particular  settlement  type and number for a client or clients*/
CREATE PROCEDURE rpt_NSENetReport
@partycode varchar(10),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3)
AS
if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type =@settype ) > 0 
 begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,Quantity = sum(s.tradeqty),
 Amount = sum(s.amount),s.sell_buy,s.sett_no,s.sett_type 
 from settlement s,client1 c1,client2 c2 
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%'
 and s.sett_no like  ltrim(@settno)+'%' and s.sett_type like  ltrim(@settype)+'%' 
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
 end
else
 begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,Quantity = sum(s.tradeqty),
 Amount = sum(s.amount),s.sell_buy,s.sett_no,s.sett_type 
 from history s,client1 c1,client2 c2 
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code like ltrim(@partycode)+'%' and c1.short_name like  ltrim(@partyname)+'%'
 and s.sett_no like  ltrim(@settno)+'%' and s.sett_type like  ltrim(@settype)+'%' 
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
 end

GO
