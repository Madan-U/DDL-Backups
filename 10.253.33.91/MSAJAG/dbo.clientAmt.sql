-- Object: PROCEDURE dbo.clientAmt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.clientAmt    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.clientAmt    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.clientAmt    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.clientAmt    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.clientAmt    Script Date: 12/27/00 8:58:47 PM ******/

/****** Object:  Stored Procedure dbo.clientAmt    Script Date: 12/18/99 8:24:07 AM ******/
create procedure clientAmt (@sett_no varchar(15), @sett_type varchar(1)
,@party varchar(10)) as
 select settlement.party_code 'PartyCode',c1.short_name 'PartyName',
 sum(Amount) 'Amount',settlement.sett_no,settlement.setT_type from settlement ,client1 c1,client2 c2 
 where C1.CL_CODE=C2.CL_CODE AND settlement.PARTY_CODE=C2.PARTY_CODE and 
 settlement.PARTY_CODE like @PARTY and 
 settlement.sett_no like @sett_no and settlement.sett_type like @sett_type 
 group by settlement.party_code,c1.short_name,settlement.sett_no,settlement.setT_type
HAVING SUM(AMOUNT) > 0
union
 select history.party_code 'PartyCode',c1.short_name 'PartyName',
 sum(Amount) 'Amount', history.sett_no,history.sett_type from history,client1 c1,client2 c2 
 where C1.CL_CODE=C2.CL_CODE AND history.PARTY_CODE = c2.party_code
 and history.PARTY_CODE like @PARTY and 
 history.sett_no like @sett_no and history.sett_type like @sett_type
 group by history.party_code,c1.short_name , history.sett_no,history.sett_type
HAVING SUM(AMOUNT) > 0
 order by sum(Amount) desc

GO
