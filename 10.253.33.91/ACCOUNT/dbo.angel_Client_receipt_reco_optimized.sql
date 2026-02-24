-- Object: PROCEDURE dbo.angel_Client_receipt_reco_optimized
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure angel_Client_receipt_reco_optimized  
as  
  
declare @tdate as datetime,@daysbefore as int,@prodate as varchar(11)  
select @tdate = getdate()+1  
--set @prodate = convert(varchar(11),getdate()-1)  
set @prodate = convert(varchar(11),getdate())  
select @daysbefore=datediff(dd,@prodate,getdate())+1  
  
Set Transaction isolation level read uncommitted  
select t.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(L1.ddno,'') ddno, isnull (l.cltcode ,'') cltcode , isnull(l. acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then l.vamt else 0 end ),  
Cramt= (case when upper(l.drcr) = 'C' then l.vamt else 0 end ),  
treldt=isnull(convert(varchar, L1.reldt , 103),''), l1.refno,last_Date=getdate()  
into #recodet  
From ledger l (nolock) left outer join LEDGER1 L1 (nolock)  
on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno,  
(select distinct vtyp, booktype, vno, lno,accno=cltcode from ledger l WITH (nolock) where exists  
(Select accno from angel_bank_accno abc (nolock) where l.cltcode=abc.accno)  
and not (narration like 'BEING AMT RECD TECH PROCESS%' AND narration like 'BEING AMT RECEIVED BY ONLINE TRF%' AND narration like 'BEING AMT RECD ING%')  
) t  
WHERE l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype  
-- and (cltcode <> @code  
and l.cltcode >='A0001' and l.cltcode <='ZZZZZ' and l.drcr='C' and l.vdt <=@tdate-@daysbefore  
/* Commented By Shweta On 05/01/2010 --Start  
and clear_mode not in ( 'R', 'C')  
--END*/  
and l.vtyp not in ( 16, 17)  
and (l1.reldt ='1900-01-01 00:00:00.000' or l1.reldt > @tdate )  
  
--declare @lastdt as datetime  
--select lastdt=max(reldt) from ledger1  
create nonclustered index ix_recodet on #recodet(accno)  
  
update #recodet set last_Date=b.updt from  
(  
SELECT l1.accno,updt=max(l.reldt) FROM ledger1 l inner join   
(select  vtyp, booktype, vno, lno,accno=cltcode from ledger l  (nolock) where exists  
(Select accno from angel_bank_accno abc (nolock)  where l.cltcode =abc.accno)  
group by  vtyp, booktype, vno, lno,cltcode   
) L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno  
group by l1.accno  
) b where #recodet.accno=b.accno  
  
--NEED TO REMOVE AND REPLACE #Angel_client_deposit_recno TO Angel_client_deposit_recno  
/****************************************************************************/  
select top 0 * into #Angel_client_deposit_recno from Angel_client_deposit_recno  
insert into #Angel_client_deposit_recno select * from #recodet (nolock)-- where ddno<>0  
/*===========================================================================*/  
  
/*  
truncate table Angel_client_deposit_recno  
insert into Angel_client_deposit_recno select * from #recodet (nolock)-- where ddno<>0  
*/  
--EXEC ANGEL_KNOCKOFF_CANCEL_RECO

GO
