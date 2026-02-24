-- Object: PROCEDURE dbo.rpt_fosettlementlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fosettlementlist    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettlementlist    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettlementlist    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettlementlist    Script Date: 5/5/2001 1:24:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettlementlist    Script Date: 4/30/01 5:50:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettlementlist    Script Date: 10/26/00 6:04:44 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fosettlementlist    Script Date: 12/27/00 8:59:11 PM ******/
/*Modified by amolika on 13th April'2001 : Added condition for getting only those partcode who have done 
trading for that day*/
/*
Used In      : NSE FO
Report Name  : Margin Report
File Name    : cllist.asp
Tables Used  : fosettlement, client1, client2
Function     : Returns partycode, shortname
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fosettlementlist
AS
select distinct t.party_code, c1.short_name 
from fosettlement t , client1 c1, client2 c2 
where c1.cl_code = c2.cl_code 
and c2.party_code = t.party_code
and convert(varchar,sauda_date,106) = (select convert(varchar,getdate(),106)) 
order by t.party_code

GO
