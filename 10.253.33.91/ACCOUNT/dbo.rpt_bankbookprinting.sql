-- Object: PROCEDURE dbo.rpt_bankbookprinting
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_bankbookprinting    Script Date: 01/18/2002 1:38:09 PM ******/
/****** Object:  Stored Procedure dbo.rpt_bankbookprinting    Script Date: 01/04/1980 1:40:39 AM ******/
/****** Object:  Stored Procedure dbo.rpt_bankbookprinting    Script Date: 11/28/2001 12:23:46 PM ******/
/****** Object:  Stored Procedure dbo.rpt_bankbookprinting    Script Date: 29-Sep-01 8:12:05 PM ******/
/****** Object:  Stored Procedure dbo.rpt_bankbookprinting    Script Date: 09/21/2001 2:39:21 AM ******/
/****** Object:  Stored Procedure dbo.rpt_bankbookprinting    Script Date: 08/29/2001 6:51:58 AM ******/
/****** Object:  Stored Procedure dbo.rpt_bankbookprinting    Script Date: 08/13/2001 6:16:47 AM ******/
/***************************************************************************************************
This is stored procedure used to get bankbook printing for perticular branches
-------------------------------------------------------------------------------
CHANGED BY MANISH RUNWAL ON 29/1/2002 
Depending on the @AllFlag value 
If @Allflag = 0  then show bank transaction for all the branches
If @Allflag = 1 then show bank transaction for a selected branch (i.e for the passed costcode )
***************************************************************************************************/

CREATE PROCEDURE rpt_bankbookprinting
@cltcode as varchar(10),
@fromdate as datetime,
@todate as datetime,
@vdtedtflag as integer,
@AllFlag as integer,
@Costcode as integer

AS

IF @vdtedtflag = 0
BEGIN
	/*If any one select to show all records */
	if @allFlag = 0
	begin
	 	SELECT Vdt = convert(varchar,l.vdt,103), cltcode = isnull(a.cltcode,''), longname = isnull(a.longname,''),L.VNO,l.vtyp,voudt=l.vdt,
			ddno= isnull((case when (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno) is not null
				then (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno)
				else (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype )
				end),''),
	         	Debit = (Case When l.DRCR = 'C' Then  Vamt  Else  0 End),
	           	Credit = (Case When l.DRCR='D' Then  Vamt   Else  0 End), 
			balamt= (select sum(balamt) from ledger l1 where cltcode= @cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype=l3.booktype AND l3.naratno=0),''),
			LNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype=l3.booktype AND  l3.naratno = l.lno ) ,'') /*,Year(L.VDT),Month(L.VDT),Day(L.VDt)	*/
		FROM LEDGER L,acmast a
	           	WHERE L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO) 
	           	AND L.CLTCODE <> @cltcode and l.booktype = ( select booktype from acmast a where a.cltcode =  @cltcode )
	           	and l.vdt >= @fromdate + ' 00:00:00'
		 	and l.vdt <= @todate + ' 23:59:59'
	           	AND l.VTYP <> 18 and a.cltcode=l.cltcode 
	           	ORDER BY VOUDT /*,L.VTYP,L.VNO*/
	end 
	/*If branch = perticular branch */
	IF @allflag = 1
	begin
		SELECT Vdt = convert(varchar,l.vdt,103), l.cltcode /* = isnull(a.cltcode,'')*/ , longname = isnull(a.longname,''),L.VNO,l.vtyp,voudt=l.vdt,
			ddno= isnull((case when (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno) is not null
				then (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno)
				else (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype )
				end),''),
	         	Debit = (Case When l.DRCR = 'C' Then  Vamt  Else  0 End),
	           	Credit = (Case When l.DRCR='D' Then  Vamt   Else  0 End), 
			balamt= (select sum(balamt) from ledger l1 where cltcode= @cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype=l3.booktype AND l3.naratno=0),''),
			LNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype=l3.booktype AND  l3.naratno = l.lno ) ,'') /*,Year(L.VDT),Month(L.VDT),Day(L.VDt)	*/
		FROM LEDGER L,acmast a
	           	WHERE L.vno IN (SELECT distinct ledger.Vno FROM  LEDGER, ledger2 l2 WHERE l2.CLTCODE = '02057' AND ledger.VNO = L2.VNO and ledger.vtyp = l2.vtype and ledger.booktype = l2.booktype and costcode = @costcode)
			and L.VTYP IN ( SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO 
			and vtyp in (select distinct vtype from ledger2 where costcode = @costcode ))
	           	AND L.CLTCODE <> @cltcode and l.booktype = ( select booktype from acmast a where a.cltcode =  @cltcode 
			and booktype in (select distinct booktype from ledger2 where costcode = @costcode) ) 
	           	and l.vdt >= @fromdate + ' 00:00:00'
		 	and l.vdt <= @todate + ' 23:59:59'
	           	AND l.VTYP <> 18 and a.cltcode=l.cltcode 

	           	ORDER BY VOUDT /*,L.VTYP,L.VNO*/
	end 
END   	

ELSE IF @vdtedtflag = 1
BEGIN
	/*If any one select to show all records */
	if @allflag = 0 
	begin 
		SELECT Vdt = convert(varchar,l.vdt,103), Edt = convert(varchar,l.edt,103), cltcode = isnull(a.cltcode,''), longname = isnull(a.longname,''),L.VNO,l.vtyp,effdt=l.edt,
			ddno = isnull((case when (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno) is not null
				then (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno)
				else (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype )
				end),''),
			Debit = (Case When l.DRCR = 'C' Then  Vamt  Else  0 End),
			Credit = (Case When l.DRCR='D' Then  Vamt   Else  0 End), 
			balamt= (select sum(balamt) from ledger l1 where cltcode= @cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
			CNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype=l3.booktype AND l3.naratno=0),''),
			LNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype=l3.booktype AND  l3.naratno = l.lno ) ,'')/*,Year(L.VDT),Month(L.VDT),Day(L.VDt)	*/
		FROM LEDGER L,acmast a
			WHERE L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO )
			AND L.CLTCODE <> @cltcode and l.booktype = ( select booktype from acmast a where a.cltcode =  @cltcode ) 
			and l.edt >= @fromdate + ' 00:00:00'
			and l.edt <= @todate + ' 23:59:59'
			AND l.VTYP <> 18 and a.cltcode=l.cltcode 
			ORDER BY  EFFDT/*,L.VTYP,L.VNO*/
	end 
	/*If branch = perticular branch */
	else if @allflag = 1
	begin
		SELECT Vdt = convert(varchar,l.vdt,103), Edt = convert(varchar,l.edt,103), l.cltcode /* = isnull(a.cltcode,'')*/ , longname = isnull(a.longname,''),L.VNO,l.vtyp,effdt=l.edt,
			ddno = isnull((case when (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno) is not null
				then (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno)
				else (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype )
				end),''),
			Debit = (Case When l.DRCR = 'C' Then  Vamt  Else  0 End),
			Credit = (Case When l.DRCR='D' Then  Vamt   Else  0 End), 
			balamt= (select sum(balamt) from ledger l1 where cltcode= @cltcode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
			CNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype=l3.booktype AND l3.naratno=0),''),
			LNarration =isnull((select l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype=l3.booktype AND  l3.naratno = l.lno ) ,'')/*,Year(L.VDT),Month(L.VDT),Day(L.VDt)	*/
		FROM LEDGER L,acmast a
			WHERE L.vno IN (SELECT distinct ledger.Vno FROM  LEDGER, ledger2 l2 WHERE l2.CLTCODE = '02057' AND ledger.VNO = L2.VNO and ledger.vtyp = l2.vtype and ledger.booktype = l2.booktype and costcode = @costcode)
			and L.VTYP IN (SELECT VTYP FROM LEDGER WHERE CLTCODE = @cltcode AND VNO = L.VNO 
			and vtyp in (select distinct vtyp from ledger2 where costcode = @costcode))
			AND L.CLTCODE <> @cltcode and l.booktype = ( select booktype from acmast a where a.cltcode =  @cltcode 
			and booktype in (select distinct booktype from ledger2 where costcode = @costcode)) 
			and l.edt >= @fromdate + ' 00:00:00'
			and l.edt <= @todate + ' 23:59:59'
			AND l.VTYP <> 18 and a.cltcode=l.cltcode 
			ORDER BY  EFFDT/*,L.VTYP,L.VNO*/
	end 
END

GO
