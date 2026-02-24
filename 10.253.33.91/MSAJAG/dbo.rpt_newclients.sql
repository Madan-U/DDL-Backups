-- Object: PROCEDURE dbo.rpt_newclients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_newclients    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclients    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclients    Script Date: 20-Mar-01 11:39:01 PM ******/





/****** Object:  Stored Procedure dbo.rpt_newclients    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclients    Script Date: 12/27/00 8:58:56 PM ******/

/* report : transactionreport
   file : newclients.asp
*/
/* displays new clients introduced today */
CREATE PROCEDURE rpt_newclients
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid = "broker" 
begin
select distinct party_code from trade4432 where party_code not in (select party_code from client2) 
end
if @statusid = "branch" 
begin
select distinct party_code from trade4432 where party_code not in (select party_code from client2) 
end
if @statusid = "trader" 
begin
select distinct party_code from trade4432 where party_code not in (select party_code from client2) 
end

GO
