-- Object: PROCEDURE dbo.rpt_cashbookprinting
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_cashbookprinting    Script Date: 01/04/1980 1:40:40 AM ******/


/****** Object:  Stored Procedure dbo.rpt_cashbookprinting    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cashbookprinting    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cashbookprinting    Script Date: 09/21/2001 2:39:21 AM ******/


/****** Object:  Stored Procedure dbo.rpt_cashbookprinting    Script Date: 08/24/2001 7:43:56 AM ******/

/****** Object:  Stored Procedure dbo.rpt_cashbookprinting    Script Date: 08/13/2001 6:16:53 AM ******/

/****** Object:  Stored Procedure dbo.rpt_cashbookprinting    Script Date: 04/FEB/2002 1:40:40 AM ******/
/********************************************************************************
Some changes are made By Manish Runwal on 30/1/2002
Added Two parameter for Branch wise selection and one flag is used to get all or not
Depending on the @flag value 
If @flag = 0  then Cash book transaction for all the branches
If @flag = 1 then show Cash book transaction for a selected branch (i.e for the passed costcode )
**********************************************************************************/
CREATE PROCEDURE rpt_cashbookprinting
@cltcode  as varchar(10),
@fromdate as datetime,
@todate as datetime, 
@vdtedtflag as integer,
@flag as integer,
@Costcode as varchar(12)

AS
IF @vdtedtflag = 0 
BEGIN
	if @flag = 0
	/*If All Branches then show all */
	BEGIN
          		SELECT vdt = convert(varchar,l.vdt,103),cltcode = isnull(l.cltcode,''), Acname = isnull(a.longname,''),L.VNO1,L.VNO,voudt=l.vdt,
	           	Debit = (Case When l.DRCR = 'c' Then  Vamt  Else  0 End),
	           	Credit = (Case When l.DRCR='d' Then  Vamt   Else  0 End),
		balamt = (Select sum(balamt) from ledger l1 where cltcode=@cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND  l3.naratno = l.lno ) ,'') 
	           	FROM LEDGER L,acmast a 
	           	WHERE L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO )
	           	AND L.CLTCODE <> @cltcode and l.booktype = ( select booktype from acmast a where a.cltcode =  @cltcode ) 
	           	and l.vdt >= @fromdate + ' 00:00:00'
	           	and l.vdt <= @todate  + ' 23:59:59'
	           	AND l.VTYP <> 18 and a.cltcode=l.cltcode 
	           	ORDER BY VOUDT
	END	
	/*If selected Branch then shows perticular */
	ELSE IF @flag = 1
	BEGIN 
		SELECT vdt = convert(varchar,l.vdt,103),cltcode = isnull(l.cltcode,''), Acname = isnull(a.longname,''),L.VNO1,L.VNO,voudt=l.vdt,
           		Debit = (Case When l.DRCR = 'c' Then  Vamt  Else  0 End),
	           	Credit = (Case When l.DRCR='d' Then  Vamt   Else  0 End),
		balamt = (Select sum(balamt) from ledger l1 where cltcode=@cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND  l3.naratno = l.lno ) ,'') 
	           	FROM LEDGER L,acmast a 
	           	WHERE L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO 
		and vtyp in (select distinct vtype from ledger2 where costcode = @costcode) )
	           	AND L.CLTCODE <> @cltcode and l.booktype = ( select booktype from acmast a where a.cltcode =  @cltcode 
		and booktype in ( select distinct booktype from ledger2 where costcode = @costcode ) ) 
	           	and l.vdt >= @fromdate + ' 00:00:00'
           		and l.vdt <= @todate  + ' 23:59:59'
	           	AND l.VTYP <> 18 and a.cltcode=l.cltcode 
           		ORDER BY VOUDT
	END 
END

ELSE IF @vdtedtflag = 1
BEGIN
	if @flag = 0
	BEGIN
    	            SELECT vdt = convert(varchar,l.vdt,103),edt = convert(varchar,l.edt,103), cltcode = isnull(l.cltcode,''),Acname=isnull(a.longname,''),L.VNO1,L.VNO,effdt = l.edt,
	           	Debit = (Case When l.DRCR = 'c' Then  Vamt  Else  0 End),
	           	Credit = (Case When l.DRCR='d' Then  Vamt   Else  0 End),
		balamt = (Select sum(balamt) from ledger l1 where cltcode=@cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND  l3.naratno = l.lno ) ,'') 
	         	FROM LEDGER L,acmast a 
	           	WHERE L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO )
	           	AND L.CLTCODE <> @cltcode and l.booktype = ( select booktype from acmast a where a.cltcode =  @cltcode ) 
	           	and l.edt >= @fromdate  + ' 00:00:00'
	           	and l.edt <= @todate   + ' 23:59:59'
	           	AND l.VTYP <> 18 and a.cltcode=l.cltcode 
	           	ORDER BY EFFDT
	END
	if @flag = 1
	BEGIN
	            SELECT vdt = convert(varchar,l.vdt,103),edt = convert(varchar,l.edt,103), cltcode = isnull(l.cltcode,''),Acname=isnull(a.longname,''),L.VNO1,L.VNO,effdt = l.edt,
	           	Debit = (Case When l.DRCR = 'c' Then  Vamt  Else  0 End),
	           	Credit = (Case When l.DRCR='d' Then  Vamt   Else  0 End),
		balamt = (Select sum(balamt) from ledger l1 where cltcode=@cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND  l3.naratno = l.lno ) ,'') 
	         	FROM LEDGER L,acmast a 
           		WHERE L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO 
		and vtyp in (select distinct vtype from ledger2 where costcode = @costcode) )
	           	AND L.CLTCODE <> @cltcode and l.booktype = ( select booktype from acmast a where a.cltcode =  @cltcode 
		and booktype in ( select distinct booktype from ledger2 where costcode = @costcode ) ) 
	           	and l.edt >= @fromdate  + ' 00:00:00'
	           	and l.edt <= @todate   + ' 23:59:59'
           		AND l.VTYP <> 18 and a.cltcode=l.cltcode 
	           	ORDER BY EFFDT
	END
END


/* IF @vdtedtflag = 0 
BEGIN
          	SELECT vdt = convert(varchar,l.vdt,103),cltcode = isnull(l.cltcode,''), Acname = isnull(a.longname,''),L.VNO1,L.VNO,
           	Debit = (Case When l.DRCR = 'c' Then  Vamt  Else  0 End),
           	Credit = (Case When l.DRCR='d' Then  Vamt   Else  0 End),
		balamt = (Select sum(balamt) from ledger l1 where cltcode=@cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp),
           	CNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND  l3.naratno = l.lno ) ,'') 
           	FROM LEDGER L,acmast a 
           	WHERE L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO )
           	AND L.CLTCODE <> @cltcode and l.booktype = ( select booktype from acmast a where a.cltcode =  @cltcode ) 
           	and l.vdt >= @fromdate + ' 00:00:00'
           	and l.vdt <= @todate  + ' 23:59:59'
           	AND l.VTYP <> 18 and a.cltcode=l.cltcode 
           	ORDER BY VDT
		
END

ELSE IF @vdtedtflag = 1
BEGIN
            SELECT vdt = convert(varchar,l.vdt,103),edt = convert(varchar,l.edt,103), cltcode = isnull(l.cltcode,''),Acname=isnull(a.longname,''),L.VNO1,L.VNO,
           	Debit = (Case When l.DRCR = 'c' Then  Vamt  Else  0 End),
           	Credit = (Case When l.DRCR='d' Then  Vamt   Else  0 End),
	balamt = (Select sum(balamt) from ledger l1 where cltcode=@cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp),
           	CNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND l3.naratno=0),''),
	LNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND  l3.naratno = l.lno ) ,'') 
           	FROM LEDGER L,acmast a 
           	WHERE L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO )
           	AND L.CLTCODE <> @cltcode and l.booktype = ( select booktype from acmast a where a.cltcode =  @cltcode ) 
           	and l.edt >= @fromdate  + ' 00:00:00'
           	and l.edt <= @todate   + ' 23:59:59'
           	AND l.VTYP <> 18 and a.cltcode=l.cltcode 
           	ORDER BY l.VDT
END
*/

GO
