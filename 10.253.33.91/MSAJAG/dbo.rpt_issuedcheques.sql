-- Object: PROCEDURE dbo.rpt_issuedcheques
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_issuedcheques    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_issuedcheques    Script Date: 01/04/1980 5:06:27 AM ******/





/* report : cheques
   file : todayscheq.asp
*/
/*changed by mousami on 13 dec 2001
    added a condition to match booktype also in inner query as subquery return more than one value error was coming
*/
/* displays list of cheques  issued as on particular date on a particular bank */
/*changed by mousami  on 16 oct  2001 
    added hardcoding as l3.naratno=0
    in else part of narration.
    If line no of ledger and ledger3 does not match then  take main narration 
    for main narration line number is 0
*/ 

/*
 changed by mousami on 09/02/2001 
     added family login
*/
CREATE PROCEDURE rpt_issuedcheques 
@sortbydate varchar(12),
@bankcode varchar(10),
@tdate  varchar(12) ,
@statusid varchar(15),
@statusname varchar(25)
as
if @sortbydate ='vdt'
begin

 if @statusid = 'broker' 
 begin
	 select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, l1.cltcode ,
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.lno = l1.lno and le1.booktype = l1.booktype and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype )
				end),''),
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype and  l3.naratno=0 ) 
		               end),''), l1.booktype
	 from account.dbo.ledger l1
	 where l1.vtyp=3
	 and l1.vno in ( select vno from account.dbo.ledger l 
	 where l.vdt  like ltrim(@tdate)+'%'
	 and l.vtyp in (3,20) and l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno )
	and l1.cltcode <> @bankcode
	 order by l1.acname 
 end

 if @statusid = 'branch' 
 begin
	  select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype )
				end),''),
 	  nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO  and l1.booktype = l3.booktype AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO  and l1.booktype = l3.booktype  and  l3.naratno=0) 
		               end),''), l1.booktype
	  from account.dbo.ledger l1,branches b, client1 c1,client2 c2
	  where l1.vtyp =3
	  and l1.vno in ( select vno from account.dbo.ledger l 
			  where l.vdt  like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
			  l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	  and l1.cltcode <> @bankcode
	  and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode
	  and b.branch_cd=@statusname and b.short_name=c1.trader
	  order by l1.acname 
end


 if @statusid = 'trader'
 begin
  	select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype)
				end),''),
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  and  l3.naratno=0) 
		               end),''), l1.booktype
	from account.dbo.ledger l1 ,client1 c1, client2 c2
	where l1.vtyp=3
	and l1.vno in ( select vno from account.dbo.ledger l 
	where l.vdt like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
	l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	and l1.cltcode <> @bankcode
	and c1.trader=@statusname and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode
	order by l1.acname
 end


 if @statusid = 'subbroker'
 begin
  	select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype)
				end),''),
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  and  l3.naratno=0 ) 
		               end),''), l1.booktype
	from account.dbo.ledger l1,subbrokers  sb,client1 c1, client2 c2
	where l1.vtyp =3
	and l1.vno in ( select vno from account.dbo.ledger l 
	where l.vdt  like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
	l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	and l1.cltcode <> @bankcode
	and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode
	and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
	order by l1.acname 
 
 end 


 if @statusid = 'client'
 begin
	  select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype)
				end),''),
	  nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO  and l1.booktype = l3.booktype AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  and  l3.naratno=0 ) 
		               end),''), l1.booktype
	  from account.dbo.ledger l1,  client1 c1, client2 c2
	  where l1.vtyp =3
	  and l1.vno in ( select vno from account.dbo.ledger l 
	  where l.vdt  like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
	  l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	  and l1.cltcode <> @bankcode
	  and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode
	  and l1.cltcode=@statusname
	  order by l1.acname

 end


  if @statusid = 'family' 
 begin
	  select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype)
				end),''),
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  and  l3.naratno=0) 
		               end),''), l1.booktype
	 from account.dbo.ledger l1, client1 c1, client2 c2
	 where l1.vtyp=3 
	 and l1.vno in ( select vno from account.dbo.ledger l 
	 where l.vdt  like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
	  l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	 and l1.cltcode <> @bankcode
	 and c1.cl_code=c2.cl_code 
	 and c1.family=@statusname
	 and c2.party_code=l1.cltcode
	order by l1.acname 
  end

end



/*the part below is executed if sortbydate=edt */


if @sortbydate ='edt'
begin

 if @statusid = 'broker' 
 begin
	 select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype)
				end),''),
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO  and l1.booktype = l3.booktype  and  l3.naratno=0) 
		               end),''), l1.booktype
	 from account.dbo.ledger l1
	 where l1.vtyp=3
	 and l1.vno in ( select vno from account.dbo.ledger l 
	 where l.edt  like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
	 l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	and l1.cltcode <> @bankcode
	 order by l1.acname 
 end

 if @statusid = 'branch' 
 begin
	  select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype)
				end),''),
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype   and  l3.naratno=0) 
		               end),''), l1.booktype
	  from account.dbo.ledger l1,branches b, client1 c1,client2 c2
	  where l1.vtyp =3
	  and l1.vno in ( select vno from account.dbo.ledger l 
	  where  l.edt like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
	  l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	  and l1.cltcode <> @bankcode
	  and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode
	  and b.branch_cd=@statusname and b.short_name=c1.trader
	  order by l1.acname 
end


 if @statusid = 'trader'
 begin
  	select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype)
				end),''),
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO  and l1.booktype = l3.booktype  and  l3.naratno=0) 
		               end),''), l1.booktype
	from account.dbo.ledger l1 ,client1 c1, client2 c2
	where l1.vtyp=3
	and l1.vno in ( select vno from account.dbo.ledger l 
	where l.edt like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
	l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	and l1.cltcode <> @bankcode
	and c1.trader=@statusname and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode
	order by l1.acname
 end


 if @statusid = 'subbroker'
 begin
  	select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype)
				end),''),
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO  and l1.booktype = l3.booktype  and  l3.naratno=0) 
		               end),''), l1.booktype
	from account.dbo.ledger l1,subbrokers  sb,client1 c1, client2 c2
	where l1.vtyp =3
	and l1.vno in ( select vno from account.dbo.ledger l 
	where l.edt like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
	l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	and l1.cltcode <> @bankcode
	and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode
	and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
	order by l1.acname 
 
 end 


 if @statusid = 'client'
 begin
	  select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype)
				end),''),
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO  and l1.booktype = l3.booktype  and  l3.naratno=0) 
		               end),''), l1.booktype
	  from account.dbo.ledger l1,  client1 c1, client2 c2
	  where l1.vtyp =3
	  and l1.vno in ( select vno from account.dbo.ledger l 
	  where l.edt like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
	  l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	  and l1.cltcode <> @bankcode
	  and c1.cl_code=c2.cl_code and c2.party_code=l1.cltcode
	  and l1.cltcode=@statusname
	  order by l1.acname

 end


  if @statusid = 'family' 
 begin
	  select l1.acname,l1.vamt,l1.refno,l1.cltcode,l1.vtyp, 
	 ddno=isnull((case when (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr) is not null
				then (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype and le1.lno = l1.lno and le1.drcr = l1.drcr)
				else (select ddno from account.dbo.ledger1 le1 where le1.vtyp = l1.vtyp and le1.vno = l1.vno and le1.booktype = l1.booktype)
				end),''),
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype AND l1.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype  AND l1.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L1.VTYP = L3.VTYP AND L1.VNO = L3.VNO and l1.booktype = l3.booktype   and  l3.naratno=0) 
		               end),''), l1.booktype
	 from account.dbo.ledger l1, client1 c1, client2 c2
	 where l1.vtyp=3 
	 and l1.vno in ( select vno from account.dbo.ledger l 
	 where l.edt like ltrim(@tdate)+'%' and l.vtyp in (3,20) and 
	  l.cltcode=@bankcode and l.booktype=l1.booktype and l.vtyp=l1.vtyp and l.vno=l1.vno)
	 and l1.cltcode <> @bankcode
	 and c1.cl_code=c2.cl_code 
	 and c1.family=@statusname
	 and c2.party_code=l1.cltcode
	order by l1.acname 
  end

end

GO
