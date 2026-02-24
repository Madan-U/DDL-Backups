-- Object: PROCEDURE dbo.rpt_Newcashbookprinting
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_Newcashbookprinting    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_Newcashbookprinting    Script Date: 11/28/2001 12:23:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_Newcashbookprinting    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cashbookprinting    Script Date: 08/24/2001 7:43:56 AM ******/

/****** Object:  Stored Procedure dbo.rpt_cashbookprinting    Script Date: 08/13/2001 6:16:53 AM ******/
CREATE PROCEDURE rpt_Newcashbookprinting
@cltcode  as varchar(10),
@fromdate as datetime,
@todate as datetime, 
@vdtedtflag as integer

AS

IF @vdtedtflag = 0 
BEGIN
          	SELECT convert(varchar,l.vdt,103),isnull(a.longname,''),L.VNO1,L.VNO,
           	Debit = (Case When l.DRCR = 'c' Then  Vamt  Else  0 End),
           	Credit = (Case When l.DRCR='d' Then  Vamt   Else  0 End),
	balamt = (Select sum(balamt) from ledger l1 where cltcode=@cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp),
           	/*Narration = isnull((select l3.narr from ledger3 l3 where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.lno = l3.naratno),'')*/
	Narration = (case when (select l3.narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno= l.lno ) is not null 
		      then (select l3.narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno= l.lno)
		      else (select l3.narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno )
		     end )

           	FROM LEDGER L,acmast a 
           	WHERE L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO )
           	AND L.CLTCODE <> @cltcode
           	and l.vdt >= @fromdate 
           	and l.vdt <= @todate  
           	AND l.VTYP <> 18 and a.cltcode=l.cltcode 
           	ORDER BY L.VDT,L.VTYP,L.VNO
END

ELSE IF @vdtedtflag = 1
BEGIN
            SELECT convert(varchar,l.edt,103),isnull(a.longname,''),L.VNO1,L.VNO,
           	Debit = (Case When l.DRCR = 'c' Then  Vamt  Else  0 End),
           	Credit = (Case When l.DRCR='d' Then  Vamt   Else  0 End),
	balamt = (Select sum(balamt) from ledger l1 where cltcode=@cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp),
           	/*Narration = isnull((select l3.narr from ledger3 l3 where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.lno = l3.naratno),'')*/
	Narration = (case when (select l3.narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno= l.lno ) is not null 
		      then (select l3.narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno= l.lno)
		      else (select l3.narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno )
		     end )

           	FROM LEDGER L,acmast a 
           	WHERE L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO )
           	AND L.CLTCODE <> @cltcode
           	and l.edt >= @fromdate 
           	and l.edt <= @todate  
           	AND l.VTYP <> 18 and a.cltcode=l.cltcode 
           	ORDER BY L.EDT,L.VTYP,L.VNO	
END

GO
