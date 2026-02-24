-- Object: PROCEDURE dbo.ClientBalanceEdtSP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ClientBalanceEdtSP    Script Date: 02/22/2002 1:56:04 PM ******/

/************************************************************************************************************************************************************************************************
Created by vaishali on 28/02/2001 Calculated the debit and credit amount for client

Recent Changes are done by Vaishali on 19/11/2001 This sp is used in TrialBalancePrint Control

*************************************************************************************************************************************************************************************************/

CREATE Procedure ClientBalanceEdtSP
@fromdate as varchar(21),
@todate as varchar(21),
@fromamt money,
@toamt money,
@flag tinyint 

AS

If @flag = 1
begin 
	SELECT bal = round(Sum(debit) - Sum(credit) ,2)
        	FROM partydrcredtview p, ACMAST a
        	where p.edt >= @fromdate and p.edt <= @todate  and a.accat = '4' and p.cltcode = a.cltcode	
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
	SELECT bal = (Sum(debit) - Sum(credit) )
        FROM partydrcredtview p, ACMAST a,PARAMETER
        where p.edt >= sdtcur and p.edt <= @tdate
        and a.accat = '4' and curyear = '1' and p.cltcode = a.cltcode
end 

If @flag = 2
begin 
	SELECT bal = (Sum(debit) - Sum(credit) )
        FROM partydrcredtview p, ACMAST a,PARAMETER
        where p.edt >= sdtcur and p.edt <= @tdate
        and a.accat = '4' and curyear = '1' and p.cltcode = a.cltcode
	Having Abs(Sum(debit) - Sum(credit)) >= @fromamt
end 

If @flag = 3
begin 
	SELECT bal = (Sum(debit) - Sum(credit) )
        FROM partydrcredtview p, ACMAST a,PARAMETER
        where p.edt >= sdtcur and p.edt <= @tdate
        and a.accat = '4' and curyear = '1' and p.cltcode = a.cltcode
	Having Abs(Sum(debit) - Sum(credit)) <= @toamt
end 
already commented */

/*
If @flag = 1
begin 
	SELECT bal = round(Sum(debit) - Sum(credit) ,2)
        	FROM partydrcredtview p, ACMAST a,PARAMETER
       	 where p.edt >= sdtcur and p.edt <= @tdate
       	 and a.accat = '4' and curyear = '1' and p.cltcode = a.cltcode	
	Having Abs(Sum(debit) - Sum(credit)) >= @fromamt	
	and Abs(Sum(debit) - Sum(credit)) <= @toamt
end 
*/

GO
