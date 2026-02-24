-- Object: PROCEDURE dbo.ValanSummary
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ValanSummary    Script Date: 02/16/2002 5:53:51 AM ******/

/****** Object:  Stored Procedure dbo.ValanSummary    Script Date: 01/24/2002 12:12:20 PM ******/


CREATE PROCEDURE   ValanSummary
@vtyp varchar(2),
@vno varchar(12),
@booktype char(2),
@flag smallint ,
@branchflag smallint,
@costcode smallint
 AS



/*
select l.cltcode,vamt,drcr,l.acname 
from ledger l,acmast a
where  l.cltcode = a.cltcode and a.accat <> 4 and vtyp = 15
and l.booktype = @booktype
and l.vno = @vno
order by l.cltcode

*/


IF @flag = 0 
begin
--Calculate the cumulative sum of all the Clients A/C for the vtyp passed
	If @branchflag = 0 
	begin 
		select isnull(sum(vamt),0),drcr from ledger where 
		cltcode in (Select cltcode from acmast where accat = 4)  
		and vtyp = @vtyp and booktype = @booktype and vno = @vno
		group by drcr order by drcr

	end 
	else if @branchflag = 1 
	begin
		select isnull(sum(camt),0),l2.drcr 
		from ledger l, ledger2 l2
		where cltcode in (Select cltcode from acmast where accat = 4)  
		and vtype = l.vtyp and l2.vno = l.vno and l2.booktype = l.booktype and l2.lno = l.lno
		and vtyp =  @vtyp  and l.booktype = @booktype  and l.vno = @vno
		and costcode = @costcode
		group by l2.drcr order by l2.drcr
	end 
end

IF @flag = 1 
begin
--Calculate the cumulative sum of all the Clients A/C for the both the vtyp 15 and 21

	If @branchflag = 0 
	begin 
		select isnull(sum(vamt),0),drcr from ledger 
		where cltcode in (Select cltcode from acmast where accat = 4)  
		and  vtyp in (15,21) and booktype = @booktype and vno = @vno
		group by drcr order by drcr

	end 
	else if @branchflag = 1 
	begin
		select isnull(sum(camt),0),l2.drcr 
		from ledger l, ledger2 l2
		where cltcode in (Select cltcode from acmast where accat = 4)  
		and vtype = l.vtyp and l2.vno = l.vno and l2.booktype = l.booktype and l2.lno = l.lno
		and vtyp in (15,21)  and l.booktype = @booktype  and l.vno = @vno
		and costcode = @costcode
		group by l2.drcr order by l2.drcr
	end 

end

Else IF @flag = 2 
begin
--Calculate the amount of Non Clients A/C  for the vtyp passed
	
	If @branchflag = 0 
	begin 
		select l.cltcode,l.acname ,
		vamt = isnull((case when drcr = 'c' then vamt * -1 else vamt end ),0)
		from ledger l,acmast a
		where  l.cltcode = a.cltcode and a.accat <> 4 and vtyp = @vtyp
		and l.booktype = @booktype and l.vno = @vno
		order by l.cltcode

	end 
	else if @branchflag = 1 
	begin
		select l.cltcode,l.acname ,
		vamt = isnull((case when l2.drcr = 'c' then camt * -1 else camt end ),0)
		from ledger l,acmast a ,ledger2 l2
		where  l.cltcode = a.cltcode and a.accat <> 4 
		and vtype = l.vtyp and l2.vno = l.vno and l2.booktype = l.booktype and l2.lno = l.lno
		and vtyp =  @vtyp  and l.booktype = @booktype  and l.vno = @vno
		and costcode = @costcode
		order by l.cltcode
	end 
end


else if @flag = 3 
begin
--Calculate the cumulative sum of amount of Non Clients A/C for the both the vtyp 15 and 21
	If @branchflag = 0 
	begin 
		select l.cltcode,l.acname ,
		vamt = isnull( sum(case when drcr ='c' then vamt*-1 else vamt end),0)
		from ledger l,acmast a
		where  l.cltcode = a.cltcode and a.accat <> 4  
		and vtyp in (15,21) 	and l.booktype = @booktype and l.vno = @vno
		group by l.cltcode,l.acname
		order by l.cltcode

	end 
	else if @branchflag = 1 
	begin
		select l.cltcode,l.acname ,
		vamt = isnull( sum(case when l2.drcr ='c' then camt*-1 else camt end),0)
		from ledger l,acmast a ,ledger2 l2
		where  l.cltcode = a.cltcode and a.accat <> 4 
		and vtype = l.vtyp and l2.vno = l.vno and l2.booktype = l.booktype and l2.lno = l.lno
		and vtyp in (15,21) 	and l.booktype = @booktype and l.vno = @vno
		and costcode = @costcode
		group by l.cltcode,l.acname
		order by l.cltcode
	end 

end

GO
