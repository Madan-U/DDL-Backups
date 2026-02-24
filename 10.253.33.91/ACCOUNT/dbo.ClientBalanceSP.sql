-- Object: PROCEDURE dbo.ClientBalanceSP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ClientBalanceSP    Script Date: 02/22/2002 1:56:04 PM ******/

/************************************************************************************************************************************************************************************************
Created by vaishali on 28/02/2001 Calculated the debit and credit amount for client

Recent Changes are done by Vaishali on 19/11/2001 This sp is used in TrialBalancePrint Control

*************************************************************************************************************************************************************************************************/

CREATE Procedure ClientBalanceSP
@fromdate as varchar(21),
@todate as varchar(21),
@fromamt money,
@toamt money,
@flag tinyint 

AS

If @flag = 1
begin 
	SELECT bal = round(Sum(debit) - Sum(credit) ,2)
        	FROM partydrcrview p, ACMAST a
        	where p.vdt >= @fromdate and p.vdt <= @todate  and a.accat = '4' and p.cltcode = a.cltcode	
	Having Abs(Sum(debit) - Sum(credit)) >= @fromamt	
	and Abs(Sum(debit) - Sum(credit)) <= @toamt
end 



--COMMENTED BY SHEETAL ON 15-02-2002  ADDED FROM DATE AND TO DATE AS PARAMETERS 
/*
@tdate as varchar(21),
@fromamt money,
@toamt money,
@flag tinyint 

As

*/
/*already commented
If @flag = 1
begin 
	SELECT bal =( Sum(debit) - Sum(credit) )
        	FROM partydrcrview p, ACMAST a,PARAMETER
       	 where p.vdt >= sdtcur and p.vdt <= @tdate
	 and a.accat = '4' and curyear = '1' and p.cltcode = a.cltcode
end 

If @flag = 2
begin 
	SELECT bal = ( Sum(debit) - Sum(credit) )
        FROM partydrcrview p, ACMAST a,PARAMETER
        where p.vdt >= sdtcur and p.vdt <= @tdate
        and a.accat = '4' and curyear = '1' and p.cltcode = a.cltcode
	Having Abs(Sum(debit) - Sum(credit)) >= @fromamt
end 

If @flag = 3
begin 
	SELECT bal =( Sum(debit) - Sum(credit) )
        FROM partydrcrview p, ACMAST a,PARAMETER
        where p.vdt >= sdtcur and p.vdt <= @tdate
        and a.accat = '4' and curyear = '1' and p.cltcode = a.cltcode
	Having Abs(Sum(debit) - Sum(credit)) <= @toamt
end 

already commented*/

/*
If @flag = 1
begin 
	SELECT bal = round(Sum(debit) - Sum(credit) ,2)
        	FROM partydrcrview p, ACMAST a,PARAMETER
        	where p.vdt >= sdtcur and p.vdt <= @tdate
       	 and a.accat = '4' and curyear = '1' and p.cltcode = a.cltcode	
	Having Abs(Sum(debit) - Sum(credit)) >= @fromamt	
	and Abs(Sum(debit) - Sum(credit)) <= @toamt
end 
*/

GO
