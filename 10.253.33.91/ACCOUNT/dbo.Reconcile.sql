-- Object: PROCEDURE dbo.Reconcile
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Reconcile    Script Date: 01/04/1980 1:40:38 AM ******/

/****** Object:  Stored Procedure dbo.Reconcile    Script Date: 12/13/2001 1:36:49 PM ******/

/****** Object:  Stored Procedure dbo.Reconcile    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.Reconcile    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.Reconcile    Script Date: 08/24/2001 6:53:38 PM ******/

/****** Object:  Stored Procedure dbo.Reconcile    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.Reconcile    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.Reconcile    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.Reconcile    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.Reconcile    Script Date: 20-Mar-01 11:43:34 PM ******/

/* Last modified by VNS on 27-05-2002 to add ISNULL condition in flag = 1 case */
/* Modified by VNS on 19-07-2001 for adding condition on vdt as ( vdt >= sdtcur ). sdtcur is the start date of current financial year from parameter */

/* Modified by VNS on 09-05-2002 for adding changing condition on vdt as should be greater than 
max(vdt) where vdt <= @gdate. This will calculate balance from latest o/p balance. */

CREATE PROCEDURE  Reconcile  
@code varchar(10)
,@gdate varchar(11)
,@gdrcr  varchar(1)
,@flag varchar(1)
,@tVamt    numeric(17,2)
AS
	if @flag=1 
	begin
		select  isnull(sum(vamt) ,0) ,drcr from ledger
		where cltcode = @code and vdt >= isnull(( select max(vdt) from ledger where vtyp = '18' and vdt <= @gdate  + ' 23:59:59' and cltcode = @code),'')
		and vdt <= @gdate  + ' 23:59:59' 
		group by drcr
		order  by drcr

	end
	
	if @flag=2
	begin
		if @tvamt =  0  
		begin
			select tdate=convert(varchar,l.vdt,103), cltcode = isnull(cltcode ,'') , acname=isnull( acname ,''),
			vno=l.vno, drcr=l.drcr ,lno=l.lno, vtyp=l.vtyp,booktype = l.booktype,chequeno=isnull(ddno,''), amt= l.vamt 
			From ledger l  ,LEDGER1 ll1
			WHERE   l.vtyp in ('2','3','5','16','17','19','20' ) and cltcode <> @code
			and ll1.vno=l.vno and ll1.vtyp=l.vtyp and ll1.lno = l.lno and ll1.drcr=l.drcr and  ll1.booktype = l.booktype 
			and l.vno in  (select vno from ledger l1 where cltcode =@code   and l.vtyp=l1.vtyp)
			and  ( reldt ='1900-01-01 00:00:00.000'   or   reldt > @gdate + ' 23:59:59') and  vdt < =  @gdate + ' 23:59:59'   and   l.drcr like  @gdrcr  
/*			and l.booktype = (select booktype from acmast where cltcode = @code) */
			order by  convert(varchar,l.vdt,101) ,l.vtyp,l.vno,l.drcr
		end

		if  @tvamt <>0
		begin
			select tdate=convert(varchar,l.vdt,103), cltcode = isnull(cltcode ,'') , acname=isnull( acname ,''),
			vno=l.vno, drcr=l.drcr ,lno=l.lno,vtyp=l.vtyp,booktype = l.booktype, chequeno=isnull(ddno,''), amt= l.vamt 
			From ledger l  ,LEDGER1 LL1
			WHERE   l.vtyp in ('2','3','5','16','17','19','20' ) and cltcode <>@code
			and ll1.vno=l.vno and ll1.vtyp=l.vtyp and ll1.lno = l.lno and ll1.drcr=l.drcr and   ll1.booktype = l.booktype
			and l.vno in (select vno from ledger l1 where cltcode =@code   and l.vtyp=l1.vtyp) 
			and ( reldt ='1900-01-01 00:00:00.000'   or   reldt > @gdate + ' 23:59:59') and vdt < =  @gdate + ' 23:59:59'   and   l.drcr like  @gdrcr 
/*			and l.booktype = (select booktype from acmast where cltcode = @code) */ 
			and  vamt = @tVamt  
			order by   convert(varchar,l.vdt,101)  ,l.vtyp,l.vno,l.drcr
		end
	end

GO
