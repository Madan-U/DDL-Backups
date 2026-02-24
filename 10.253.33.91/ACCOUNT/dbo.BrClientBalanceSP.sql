-- Object: PROCEDURE dbo.BrClientBalanceSP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BrClientBalanceSP    Script Date: 02/22/2002 1:56:03 PM ******/

/************************************************************************************************************************************************************************************************
Created by Sheetal 21/02/2002 Calculated the debit and credit amount for client
This sp is used in TrialBalancePrint Control

*************************************************************************************************************************************************************************************************/

CREATE Procedure BrClientBalanceSP
@fromdate as varchar(21),
@todate as varchar(21),
@fromamt money,
@toamt money,
@flag tinyint,
@costcode smallint 

AS

If @flag = 1
begin 
	SELECT bal = round(Sum(debit) - Sum(credit) ,2)
        	FROM partydrcrbranchwise p, ACMAST a
        	where p.vdt >= @fromdate and p.vdt <= @todate  and a.accat = '4' and p.cltcode = a.cltcode	
	and costcode = @costcode	
	Having Abs(Sum(debit) - Sum(credit)) >= @fromamt 
	and Abs(Sum(debit) - Sum(credit)) <= @toamt
end

GO
