-- Object: PROCEDURE dbo.ChqAckPrint
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ChqAckPrint    Script Date: 01/04/1980 1:40:36 AM ******/


/****** Object:  Stored Procedure dbo.ChqAckPrint    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.ChqAckPrint    Script Date: 09/21/2001 2:39:20 AM ******/

/****** Object:  Stored Procedure dbo.ChqAckPrint    Script Date: 09/14/2001 2:57:00 AM ******/
CREATE Procedure ChqAckPrint
@vdt varchar(11),
@cltcode varchar(10),
@vamt money,
@chqno varchar(15),
@Flag integer

As

If @flag = 1
begin
	if @vamt = 0
	begin		
		select l1.receiptno, vamt ,bnkname ,dddt = left(convert(varchar,dddt,103),11) ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,l.vdt,
		acname = l.acname ,
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
			 then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
			 else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp = '2' and  l.drcr = 'c'
		and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.vdt like @vdt + '%' and ddno like rtrim(@chqno) + '%'
		Union
		select l1.receiptno, vamt ,bnkname ,dddt = left(convert(varchar,dddt,103),11) ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr, l.vdt,
		acname = isnull((select acname from marginledger m, acmast a where vtyp = l1.vtyp and vno = l1.vno and m.booktype=l1.booktype and a.cltcode = m.party_code),''),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
			 then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
			 else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp = '19'
		and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.vdt like @vdt + '%' and ddno like rtrim(@chqno) + '%'
		order by acname, l.vdt
	end
	
	else if @vamt > 0 
	Begin
		select l1.receiptno, vamt ,bnkname ,dddt = left(convert(varchar,dddt,103),11) ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,l.vdt,
		acname = l.acname ,
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
			 then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
			 else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp = '2' and  l.drcr = 'c'
		and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.vdt like @vdt + '%'
		and vamt = @vamt and ddno like @chqno + '%'		
		Union
		select l1.receiptno, vamt ,bnkname ,dddt = left(convert(varchar,dddt,103),11) ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr, l.vdt,
		acname = isnull((select acname from marginledger m, acmast a where vtyp = l1.vtyp and vno = l1.vno and m.booktype=l1.booktype and a.cltcode = m.party_code),''),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
			 then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
			 else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp = '19' and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.vdt like @vdt + '%' and vamt = @vamt and ddno like @chqno + '%'
		order by acname, l.vdt
	End

end

else If @flag = 2
begin
	if @vamt = 0
	begin
		select l1.receiptno, vamt ,bnkname, dddt =left(convert(varchar,dddt,103),11) ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,l.vdt,
		acname = l.acname,
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
		      then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
		      else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp = '2' and  l.drcr = 'c'
		and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.cltcode = @cltcode and ddno like @chqno + '%'
		Union
		select l1.receiptno, vamt ,bnkname, dddt =left(convert(varchar,dddt,103),11) ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,l.vdt,
		acname = isnull((select acname from marginledger m, acmast a where vtyp = l1.vtyp and vno = l1.vno and m.booktype=l1.booktype and a.cltcode = m.party_code),''),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
		      then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
		      else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp = '19' and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.cltcode = @cltcode and ddno like @chqno + '%'
		order by acname, l.vdt

	end
	else if @vamt > 0 
	begin
		select l1.receiptno, vamt ,bnkname, dddt =left(convert(varchar,dddt,103),11) ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,l.vdt,
		acname = l.acname,
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
		      then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
		      else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp='2' and  l.drcr = 'c'
		and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.cltcode = @cltcode
		and vamt = @vamt and ddno like @chqno + '%'
		Union
		select l1.receiptno, vamt ,bnkname, dddt =left(convert(varchar,dddt,103),11) ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,l.vdt,
		acname = isnull((select acname from marginledger m, acmast a where vtyp = l1.vtyp and vno = l1.vno and m.booktype=l1.booktype and a.cltcode = m.party_code),''),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
		      then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
		      else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp='19'  and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.cltcode = @cltcode
		and vamt = @vamt and ddno like @chqno + '%'
		order by acname, l.vdt
	end
	
end

else If @flag = 3
begin
	if @vamt = 0
	begin
		select l1.receiptno, vamt ,bnkname ,dddt = left(convert(varchar,dddt,103),11)  ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,l.vdt,
		acname =  l.acname,
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
			then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
			else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp = '2' and  l.drcr = 'c'
		and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.vdt like @vdt + '%'
		and l.cltcode = @cltcode and ddno like @chqno + '%'
		Union
		select l1.receiptno, vamt ,bnkname ,dddt = left(convert(varchar,dddt,103),11)  ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,l.vdt,
		acname = isnull((select acname from marginledger m, acmast a where vtyp = l1.vtyp and vno = l1.vno and m.booktype=l1.booktype and a.cltcode = m.party_code),''),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
			then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
			else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp = '19'  and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.vdt like @vdt + '%'
		and l.cltcode = @cltcode and ddno like @chqno + '%'
		order by acname, l.vdt
	end
	else if @vamt > 0 
	begin
		select l1.receiptno, vamt ,bnkname ,dddt = left(convert(varchar,dddt,103),11)  ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,l.vdt,
		acname =  l.acname,
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
			then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
			else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp = '2' and  l.drcr = 'c'
		and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.vdt like @vdt + '%'
		and l.cltcode = @cltcode and vamt = @vamt and ddno like @chqno + '%'
		Union
		select l1.receiptno, vamt ,bnkname ,dddt = left(convert(varchar,dddt,103),11)  ,ddno,brnname ,l.vno,l.vtyp, l.lno,l.drcr ,l.vdt,
		acname = isnull((select acname from marginledger m, acmast a where vtyp = l1.vtyp and vno = l1.vno and m.booktype=l1.booktype and a.cltcode = m.party_code),''),
	           	CNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l3.naratno=0),''),
		LNarration =isnull((select l3.narr from ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND  l3.naratno = l1.lno ) ,'') 
/*
		narr = isnull((case when (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) is not null
			then (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype and naratno = l1.lno) 
			else (select narr from ledger3 where vtyp = l1.vtyp and vno = l1.vno and booktype=l1.booktype ) end ),'')
*/
		from ledger1 l1,ledger l 
		where l1.vtyp ='19' and l.vtyp = l1.vtyp and l.vno = l1.vno and l.booktype=l1.booktype and l.lno = l1.lno  
		and l.vdt like @vdt + '%'
		and l.cltcode = @cltcode and vamt = @vamt and ddno like @chqno + '%'
		order by acname, l.vdt
	end
end

GO
