-- Object: PROCEDURE dbo.CashDisplay
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.CashDisplay    Script Date: 01/28/2002 6:31:42 PM ******/
/**********************************************************************************************************************************************************************************************
THIS SP  IS USED IN THE CASH DISPLAY REPORT 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Modification Done By Sheetal On 25/01/2002
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Added two new parameters viz: @flag and @costcode. 
These are used to display the Cash transactions either for all the branches or for a particular branch 
Depending on the @flag value 
If @flag = 0  then show Cash transaction for all the branches
If @flag = 1 then show Cash transaction for a selected branch (i.e for the passed costcode )
************************************************************************************************************************************************************************************************/

CREATE Procedure CashDisplay
@tstrtDate   datetime,
@tEndDate   datetime,
@tCode  varchar(10),
@vdtedtflag tinyint,
@flag int,
@costcode smallint

As

if @vdtedtflag = 0 
begin
	if @flag = 0 
	begin
		select vdt = l.vdt,vtyp,l.vno,acname ,cltcode ,vamt ,
		drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		balamt= (select sum(balamt) from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno) is not null 
		   	                then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno)
	    	    	                else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0) end ),'')
		from ledger l  
		where vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
		and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
		and cltcode not like @tCode   and vdt >= @tstrtDate  and vdt <= @tEndDate  and vtyp <> 18 
		order by vdt,vtyp ,vno
	end 
	Else if @flag = 1
	begin
		select vdt = l.vdt,vtyp,l.vno,acname ,l.cltcode ,vamt ,
		drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		balamt= (select sum(balamt) from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno) is not null 
		    	                then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno)
	    	    	                else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0) end ),'')
		from ledger l  , ledger2 l2
		where l.vtyp = l2.vtype and l.vno = l2.vno and l.booktype = l2.booktype and l.lno = l2.lno 
		and l. vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
		and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
		and l.cltcode not like @tCode   and vdt >= @tstrtDate  and vdt <= @tEndDate and costcode = @costcode
		and vtyp <> 18 
		order by vdt,vtyp ,l.vno

	end 
end

if @vdtedtflag = 1 
begin
	if @flag = 0 
	begin
		select vdt = l.edt,vtyp,l.vno,acname ,cltcode ,vamt ,
		drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		balamt= (select sum(balamt) from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno) is not null 
		   	                then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno)
	    	    	                else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 ) end ),'')
		from ledger l  
		where vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
		and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
		and cltcode not like @tCode   and edt >= @tstrtDate  and edt <= @tEndDate  and vtyp <> 18 
		order by vdt,vtyp ,vno
	end 
	Else if @flag = 1
	begin
		select vdt = l.edt,vtyp,l.vno,acname , l.cltcode ,vamt ,
		drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		balamt= (select sum(balamt) from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno) is not null 
		    	                then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno)
	    	    	                else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 ) end ),'')
		from ledger l  , ledger2 l2
		where l.vtyp = l2.vtype and l.vno = l2.vno and l.booktype = l2.booktype and l.lno = l2.lno 
		and l. vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
		and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
		and l.cltcode not like @tCode   and edt >= @tstrtDate  and edt <= @tEndDate and costcode = @costcode
		and vtyp <> 18 
		order by vdt,vtyp ,l.vno

	end 
end
/*
if @vdtedtflag = 0 
begin
	select vdt = l.vdt,vtyp,l.vno,acname ,cltcode ,vamt ,
	drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
	balamt= (select sum(balamt) from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
	narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno) is not null 
		    then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno)
	    	    else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno ) end ),'')
	from ledger l  
	where vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
	and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
	and cltcode not like @tCode   
	and vdt >= @tstrtDate  
	and vdt <= @tEndDate
	and vtyp <> 18 
	order by vdt,vtyp ,vno
end

if @vdtedtflag = 1 
begin
	select vdt = l.edt,vtyp,l.vno,acname ,cltcode ,vamt ,
	drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
	balamt= (select sum(balamt) from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
	narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno) is not null 
		    then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno)
	    	    else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno ) end ),'')
	from ledger l  
	where vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
	and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp)   
	and cltcode not like @tCode   
	and edt >= @tstrtDate  
	and edt <= @tEndDate
	and vtyp <> 18  
	order by vdt,vtyp ,vno
end

*/

GO
