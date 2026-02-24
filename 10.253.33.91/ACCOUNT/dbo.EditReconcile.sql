-- Object: PROCEDURE dbo.EditReconcile
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.EditReconcile    Script Date: 01/04/1980 1:40:37 AM ******/
/****** Object:  Stored Procedure dbo.EditReconcile    Script Date: 12/21/2001 12:40:04 PM ******/

/* Last modified by VNS on 27-05-2002 */
/* to add conditions in case of flag 3 to get unrealised debit and credit as on given date */

/*** Modified by VNS on 28/12/2001 to add book type ***/

/* Created By VNS & Sandeep From Store Procedure Reconcile */


CREATE PROCEDURE EditReconcile  
@code varchar(10),
@frmdate varchar(11),
@gdate varchar(11),
@gdrcr  varchar(1),
@flag varchar(1),
@tVamt numeric(17,2)
AS
	if @flag=1 
	begin
		select  isnull(sum(vamt) ,0) ,drcr from ledger 
		where cltcode =    @code    and   vdt <= @gdate   
		group by drcr
		order  by drcr
	end
	
	if @flag=2
	begin
		if @tvamt =  0  
		begin
			select tdate=convert(varchar,l.vdt,103), cltcode = isnull(cltcode ,'') , acname=isnull( acname ,''),
			vno=l.vno, drcr=l.drcr ,lno=l.lno, vtyp=l.vtyp,chequeno=isnull(ddno,''), /*refno= l.refno ,*/amt= l.vamt,reldt=convert(varchar,ll1.reldt,103),booktype=l.booktype
			From ledger l  ,LEDGER1 ll1 
			WHERE   l.vtyp in ('2','3','5','16','17','19','20' ) and cltcode <>@code
			/*AND SUBSTRING(LL1.REFNO,1,12)=SUBSTRING(L.REFNO,1,12)  and */
			and ll1.vno=l.vno and ll1.vtyp=l.vtyp and ll1.booktype= l.booktype and ll1.lno = l.lno and ll1.drcr=l.drcr and
			l.vno in
				(select vno from ledger l1 where cltcode =@code   and l.vtyp=l1.vtyp and booktype=l1.booktype)
				and ll1.reldt <>'1900-01-01 00:00:00.000' and vdt >= @frmdate and vdt < =  @gdate    and   l.drcr like  @gdrcr
			order by  convert(varchar,l.vdt,101) ,l.vtyp,l.vno,l.drcr
		end

		if  @tvamt <>0
		begin
			select tdate=convert(varchar,l.vdt,103), cltcode = isnull(cltcode ,'') , acname=isnull( acname ,''),
			vno=l.vno, drcr=l.drcr ,lno=l.lno,vtyp=l.vtyp, chequeno=isnull(ddno,''),/* refno= l.refno ,*/amt= l.vamt,reldt=convert(varchar,ll1.reldt,103)
			From ledger l  ,LEDGER1 LL1 
			WHERE   l.vtyp in ('2','3','5','16','17','19','20' ) and cltcode <>@code
			and ll1.vno=l.vno and ll1.vtyp=l.vtyp and ll1.lno = l.lno and ll1.drcr=l.drcr and
			/*AND SUBSTRING(LL1.REFNO,1,12)=SUBSTRING(L.REFNO,1,12)  and */
			l.vno in
				(select vno from ledger l1 where cltcode =@code   and l.vtyp=l1.vtyp)
				and ll1.reldt <>'1900-01-01 00:00:00.000'  and vdt >= @frmdate and vdt < =  @gdate    and   l.drcr like  @gdrcr
				and  vamt = @tVamt
				order by   convert(varchar,l.vdt,101)  ,l.vtyp,l.vno,l.drcr
		end
	end
	if @flag = 3
	begin
		select L.drcr, sum(vamt) from ledger L, ledger1 l1 where l.vtyp = l1.vtyp and l.booktype=l1.booktype and l.vno = l1.vno
		and vdt <= @gdate+' 23:59:59' and  ( l1.reldt = '1900-01-01 00:00:00.000' or l1.reldt > @gdate + ' 23:59:59')
		AND CLTCODE =@CODE
		GROUP BY L.DRCR 
	end

/*SUBSTRING(LL1.REFNO,1, 12)=SUBSTRING(L.REFNO,1, 12) */

GO
