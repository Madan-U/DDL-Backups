-- Object: PROCEDURE dbo.LedgerExtract
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.LedgerExtract    Script Date: 01/28/2002 3:26:56 PM ******/
/**************************************************************************************************************************************************************************************************
THIS SP  IS USED IN THE LEDGER DISPLAY REPORT 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Modification Done By Sheetal On 25/01/2002
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Added two new parameters viz: @flag and @costcode. 
These are used to display the client's transactions either for all the branches or for a particular branch 
Depending on the @flag value 
If @flag = 0  then show client's transaction for all the branches
If @flag = 1 then show client's transaction for a selected branch (i.e for the passed costcode )

Modification Done By Sheetal On 11/09/2001
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Added the vdt, edt option 
This procedure gets all the ledger details   between the start and end dates specified for a particular party 


Modification Done By Sheetal On 20/03/2001
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Added the condition Voucher date >= Start Date Passed as parameter 

***************************************************************************************************************************************************************************************************/

CREATE PROCEDURE LedgerExtract    
@tstrtDate   datetime,
@tEndDate   datetime,
@tCode  varchar(10),
@vdtedtflag tinyint,
@flag integer,
@costcode smallint
AS

if @vdtedtflag = 0 
begin
	if @flag = 0 
	begin
		select convert(varchar,VDT,103),vno, vtyp,drcr,booktype,
		dramt=isnull((case drcr when 'd' then vamt end),0),
		cramt=isnull((case drcr when 'c' then vamt end),0),balamt,Vdesc, 
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno) is not null 
			    then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno)
	    		    else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0) end ),'')

		from ledger l , vmast 
		WHERE   vdt<=  @tEndDate and vdt >= @tstrtDate and CLTCODE=  @tcode
		and vmast.vtype = l.vtyp and l.vtyp <> 18
		order by   vdt  ,vtyp, vno 
	end
	Else if @flag = 1 
	begin
		select convert(varchar,VDT,103),l.vno, vtyp,l2.drcr,l.booktype,
		dramt=isnull((case l2.drcr when 'd' then camt end),0),
		cramt=isnull((case l2.drcr when 'c' then camt end),0),balamt,Vdesc, 
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno) is not null 
			    then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno)
	    		    else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0) end ),'')
		from ledger l , vmast ,ledger2 l2
		WHERE   l.vtyp = l2.vtype and l.vno = l2.vno and l.booktype = l2.booktype  and l.lno = l2.lno
		and  vdt<=  @tEndDate and vdt >= @tstrtDate and l2.CLTCODE=  @tcode and costcode = @costcode
		and vmast.vtype = l.vtyp and l.vtyp <> 18
		order by   vdt  ,vtyp, l.vno 
	end
end 


if @vdtedtflag = 1
begin
	if @flag = 0 
	begin
		select convert(varchar,EDT,103),vno, vtyp,drcr,booktype,
		dramt=isnull((case drcr when 'd' then vamt end),0),
		cramt=isnull((case drcr when 'c' then vamt end),0),balamt,Vdesc, 
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno) is not null 
			    then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno)
	    		    else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0) end ),'')
		from ledger l , vmast 
		WHERE   edt<=  @tEndDate and edt >= @tstrtDate and CLTCODE=  @tcode
		and vmast.vtype = l.vtyp and l.vtyp <> 18
		order by   edt  ,vtyp, vno 
	end
	Else if @flag = 1 
	begin
		select convert(varchar,EDT,103),l.vno, vtyp,l2.drcr,l.booktype,
		dramt=isnull((case l2.drcr when 'd' then camt end),0),
		cramt=isnull((case l2.drcr when 'c' then camt end),0),balamt,Vdesc, 
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno) is not null 
			    then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno)
	    		    else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0) end ),'')
		from ledger l , vmast ,ledger2 l2
		WHERE  l.vtyp = l2.vtype and l.vno = l2.vno and l.booktype = l2.booktype  and l.lno = l2.lno
		and  edt<=  @tEndDate and edt >= @tstrtDate and l2.CLTCODE=  @tcode and costcode = @costcode
		and vmast.vtype = l.vtyp and l.vtyp <> 18
		order by   edt  ,vtyp, l.vno 
	end 
end

GO
