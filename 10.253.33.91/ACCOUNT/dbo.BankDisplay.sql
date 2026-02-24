-- Object: PROCEDURE dbo.BankDisplay
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.BankDisplay    Script Date: 01/28/2002 3:46:44 PM ******/
/**************************************************************************************************************************************************************************************************
THIS SP  IS USED IN THE BANK DISPLAY REPORT 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Modification Done By Sheetal On 25/01/2002
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Added two new parameters viz: @flag and @costcode. 
These are used to display the bank transactions either for all the branches or for a particular branch 
Depending on the @flag value 
If @flag = 0  then show bank transaction for all the branches
If @flag = 1 then show bank transaction for a selected branch (i.e for the passed costcode )
***************************************************************************************************************************************************************************************************/

CREATE Procedure BankDisplay
@tstrtDate   datetime,
@tEndDate   datetime,
@tCode  varchar(10),
@vdtedtflag tinyint,
@flag integer,
@costcode smallint

As

if @vdtedtflag = 0 
begin
	if @flag = 0 
	begin
		select vdt =l.vdt,vtyp,l.vno,acname ,cltcode ,vamt ,
		drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		chequeno= isnull((case when (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype) is not null
				          then (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype)
				          else (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype = l.booktype) end),''),
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l3.booktype = l.booktype) is not null 
	    		                then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l3.booktype = l.booktype)
    	    		                else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.booktype = l.booktype and l3.naratno = 0) end ),'')
		from ledger l 
		where vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
		and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
		and cltcode not like @tCode and l.booktype = ( select booktype from acmast a where a.cltcode = @tcode ) 
		and vdt >= @tstrtDate  and vdt <= @tEndDate	and vtyp <> 18  
		order by vdt,vtyp ,vno
	end
	Else if @flag = 1 
	begin
		select vdt =l.vdt,vtyp,l.vno,acname ,l.cltcode ,vamt ,
		drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		chequeno= isnull((case when (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype) is not null
			                            then (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype)
			                            else (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype = l.booktype)	end),''),
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l3.booktype = l.booktype) is not null 
	    		                then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l3.booktype = l.booktype)
    	    	                                  else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno  and l3.booktype = l.booktype and l3.naratno = 0) end ),'')
		from ledger l , ledger2 l2
		where l.vtyp = l2.vtype and l.vno = l2.vno and l.booktype = l2.booktype and l.lno = l2.lno 
		and l.vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
		and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
		and l.cltcode not like @tCode and l.booktype = ( select booktype from acmast a where a.cltcode = @tcode ) 
		and vdt >= @tstrtDate  and vdt <= @tEndDate	and costcode = @costcode
		and vtyp <> 18  
		order by vdt,vtyp ,l.vno
	end
end

if @vdtedtflag = 1
begin
	if @flag = 0 
	begin
		select vdt = l.edt ,vtyp,l.vno,acname ,cltcode ,vamt ,
		drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		chequeno= isnull((case when (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype) is not null
				          then (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype)
				          else (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype = l.booktype)	end),''),
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l3.booktype = l.booktype) is not null 
	    	 	                then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l3.booktype = l.booktype)
    	    		                else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno  and l3.booktype = l.booktype and l3.naratno = 0) end ),'')
		from ledger l  
		where vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
		and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
		and cltcode not like @tCode and l.booktype = ( select booktype from acmast a where a.cltcode = @tcode ) 
		and edt >= @tstrtDate  and edt <= @tEndDate	and vtyp <> 18  
		order by edt,vtyp ,vno
	end 
	Else if @flag = 1 
	begin
		select vdt = l.edt ,vtyp,l.vno,acname ,l.cltcode ,vamt ,
		drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
		chequeno= isnull((case when (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype) is not null
				          then (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype)
				          else (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype = l.booktype)	end),''),
		narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l3.booktype = l.booktype) is not null 
	    	 	                then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l3.booktype = l.booktype)
    	    		                else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.booktype = l.booktype and l3.naratno = 0) end ),'')
		from ledger l ,ledger2 l2 
		where l.vtyp = l2.vtype and l.vno = l2.vno and l.booktype = l2.booktype and l.lno = l2.lno 
		and l.vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
		and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
		and l.cltcode not like @tCode and l.booktype = ( select booktype from acmast a where a.cltcode = @tcode ) 
		and edt >= @tstrtDate  and edt <= @tEndDate	and costcode = @costcode
		and vtyp <> 18  
		order by edt,vtyp ,l.vno
	
	end 
end

/*
if @vdtedtflag = 0 
begin
	select vdt =l.vdt,vtyp,l.vno,acname ,cltcode ,vamt ,
	drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l.lno = l1.lno  and l.booktype = l1.booktype),
	balamt= (select sum(balamt) from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ), 
	chequeno= isnull((case when (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype) is not null
			then (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype)
			else (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype = l.booktype)
			end),''),
	narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l1.booktype = l.booktype) is not null 
	    	then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l1.booktype = l.booktype)
    	    	else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l1.booktype = l.booktype ) end ),'')
	from ledger l  
	where vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
	and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
	and cltcode not like @tCode and booktype = ( select booktype from acmast a where a.cltcode = @tcode ) 
	and vdt >= @tstrtDate  
	and vdt <= @tEndDate
	and vtyp <> 18  
	order by vdt,vtyp ,vno
end

if @vdtedtflag = 1
begin
	select vdt = l.edt ,vtyp,l.vno,acname ,cltcode ,vamt ,
	drcr = (select drcr from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ),
	balamt= (select sum(balamt) from ledger l1 where cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp ), 
	chequeno= isnull((case when (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype) is not null
			          then (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.lno = l.lno and l1.booktype = l.booktype)
			          else (select ddno from ledger1 l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype = l.booktype)
			end),''),
	narr= isnull((case when (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l1.booktype = l.booktype) is not null 
	    	                then (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno and l1.booktype = l.booktype)
    	    	                else (select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno  and l1.booktype = l.booktype) end ),'')
	from ledger l  
	where vno in(select vno from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
	and vtyp in(select vtyp from ledger l1 where  cltcode=@tCode and l.vno=l1.vno and l.vtyp=l1.vtyp and l1.booktype = l.booktype)   
	and cltcode not like @tCode and booktype = ( select booktype from acmast a where a.cltcode = @tcode ) 
	and edt >= @tstrtDate  and edt <= @tEndDate	and vtyp <> 18  
	order by edt,vtyp ,vno
end
*/

GO
