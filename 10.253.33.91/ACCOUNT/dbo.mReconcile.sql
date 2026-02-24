-- Object: PROCEDURE dbo.mReconcile
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.mReconcile    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.mReconcile    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.mReconcile    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.mReconcile    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.mReconcile    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.mReconcile    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.mReconcile    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.mReconcile    Script Date: 20-Mar-01 11:43:34 PM ******/

CREATE PROCEDURE  mReconcile  
@code varchar(10)
, @gmonth varchar(11)
,@gdrcr  varchar(1)
,@flag varchar(1)
,@gyear integer
,@tVamt    numeric(17,2)
AS
if @flag=1 
begin
select  isnull(sum(vamt) ,0) ,drcr from ledger 
where cltcode =    @code    and   datepart(month,vdt)   <= @gmonth   and     datepart(year ,vdt)   <= @gyear
group by drcr
order  by drcr
end
if @flag=2
begin
if @tvamt =  0  
begin
select tdate=convert(varchar,l.vdt,103), cltcode = isnull(cltcode ,'') , acname=isnull( acname ,''),
vno=l.vno, drcr=l.drcr , chequeno=isnull(ddno,''), /*refno= l.refno ,*/ amt= l.vamt 
From ledger l  ,LEDGER1 LL1 
WHERE   l.vtyp in ('2','3','5','16','17','19','20' ) and cltcode <>@code
and ll1.vno=l.vno and ll1.vtyp=l.vtyp and ll1.lno=l.lno and ll1.drcr =l.drcr
/*AND SUBSTRING(LL1.REFNO,1,12)=SUBSTRING(L.REFNO,1,12)*/  and 
l.vno in
(select vno from ledger l1 where cltcode =@code   and l.vtyp=l1.vtyp)
and reldt ='1900-01-01 00:00:00.000'  and datepart(month,vdt) < =  @gmonth    and   l.drcr like  @gdrcr
and     datepart(year ,vdt)   <=@gyear
order by    convert(varchar,l.vdt,101) ,l.vtyp,l.vno,l.drcr
end
if  @tvamt <>0
begin
select tdate=convert(varchar,l.vdt,103), cltcode = isnull(cltcode ,'') , acname=isnull( acname ,''),
vno=l.vno, drcr=l.drcr , chequeno=isnull(ddno,''), /*refno= l.refno ,*/amt= l.vamt 
From ledger l  ,LEDGER1 LL1 
WHERE   l.vtyp in ('2','3','5','16','17','19','20' ) and cltcode <>@code
and ll1.vno=l.vno and ll1.vtyp=l.vtyp and ll1.lno=l.lno and ll1.drcr =l.drcr
/*AND SUBSTRING(LL1.REFNO,1,12)=SUBSTRING(L.REFNO,1,12) */ and 
l.vno in
(select vno from ledger l1 where cltcode =@code   and l.vtyp=l1.vtyp)
and reldt ='1900-01-01 00:00:00.000'  and datepart(month,vdt) < =  @gmonth    and   l.drcr like  @gdrcr
and     datepart(year ,vdt)   <=@gyear  and  vamt = @tVamt
order by   convert(varchar,l.vdt,101)  ,l.vtyp,l.vno,l.drcr
end
end
/*SUBSTRING(LL1.REFNO,1, 12)=SUBSTRING(L.REFNO,1, 12) */

GO
