-- Object: PROCEDURE dbo.rpt_albmdelchrg
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmdelchrg    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmdelchrg    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmdelchrg    Script Date: 20-Mar-01 11:38:53 PM ******/







/* report : bill report 
    file : walbmbillreport.asp
    shows albmdelchrg of a client	
*/
/* changed by mousami on 07/02/2001 
     added few columns to list of select 
*/
CREATE PROCEDURE rpt_albmdelchrg

@partycode varchar(10)
AS

select albmdelchrg,Turnover_tax , Sebi_Turn_tax, Insurance_Chrg,  Other_chrg, BrokerNote  from client2 where party_code=@partycode

GO
