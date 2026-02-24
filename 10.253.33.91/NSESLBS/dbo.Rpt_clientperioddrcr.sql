-- Object: PROCEDURE dbo.Rpt_clientperioddrcr
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_clientperioddrcr    Script Date: 01/15/2005 1:28:35 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_clientperioddrcr    Script Date: 12/16/2003 2:31:45 Pm ******/



/****** Object:  Stored Procedure Dbo.rpt_clientperioddrcr    Script Date: 05/08/2002 12:35:09 Pm ******/



/*
Modified By Neelambari On 17 Oct 2001
Changed Date Format To Datetime
*/

/* Report : Allpartyledger
   File : Ledgerview.asp
Calculates Debit And Credit Totals Of A Client For A Particular Period */

/*
Modified By Neelambari On 17 Oct 2001
Changed The Date Format
*/
/*changed By Mousami On 01/03/2001
Added Hardcoding For Account Databse*/

/* Report : Allpartyledger
   File : Ledgerview.asp
*/
/* Changed By Mousami On 16 July 2001 
     Added Fromdt Parameter
     Calculates Balance Of Client For This Financial Year Including Opening Entry Till Date */


/*changed By Mousami On 01/03/2001
Added Hardcoding For Account Databse*/

/*     Calculates Balance Of Client For This Financial Year Including Opening Entry Till Date */


Create Procedure Rpt_clientperioddrcr
@fromdt Datetime,
@todt Datetime,
@cltcode Varchar(10),
@sortby Varchar(3)

As
If @sortby = 'vdt' 
Begin
	Select Drtot=isnull((case Drcr When 'd' Then Sum(vamt) End),0), 
	Crtot=isnull((case Drcr When 'c' Then Sum(vamt) End),0) 
	From Account.dbo.ledger 
	Where (vdt >=@fromdt And Vdt <=@todt + ' 23:59:59')
	And Cltcode=@cltcode
	Group By Drcr 
End 
Else
Begin
	Select Drtot=isnull((case Drcr When 'd' Then Sum(vamt) End),0), 
	Crtot=isnull((case Drcr When 'c' Then Sum(vamt) End),0) 
	From Account.dbo.ledger 
	Where (edt >=@fromdt And Edt <=@todt + ' 23:59:59')
	And Cltcode=@cltcode
	Group By Drcr 
End

GO
