-- Object: PROCEDURE dbo.insrt_bseexdetsettsummary
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure [dbo].[insrt_bseexdetsettsummary](@date_from as datetime,@date_to as datetime,@settfrom as int,@settto as int,@scripcd as int) as
/*insert into bseexdetsummary */
select  coname='ABL_CM',cbv.scrip_cd,cbv.series,cbv.sett_no,cbv.sett_type,cli_name=cbv.party_name,  
       Sebi_regn='NULL',cli_code=cbv.party_code,bankid,c4.cltdpid,uclcode='NULL',uclname='NULL',ucldp='NULL',uclclid='NULL',ucladd='NULL',
       address=replace(c1.l_address1 +','+c1.l_address2 + ','+c1.l_city +','+c1.l_state +',' +c1.l_nation+','+c1.l_zip+ ',Tel:'+c1.res_phone1+' '+c1.res_phone2+' '+off_phone1+' '+off_phone2,',,',','),
       Commence_date=x.commdate,intro_name='N.A.',relacli='NULL',relaintr='N.A.',co_dpid='NULL',co_clid='NULL',
       bought_qty=cbv.pqty,sold_qty=cbv.sqty, Net_qty=cbv.pqty-cbv.sqty, update_date=getdate(),sett_from='NULL',sett_to='NULL',sauda_date 
      ,net,cumnet='NULL',deliverable_qty='NULL',actual_qty_delivered=net,
       closeout_qty='0',cum_pur_nodelperoid='0',cum_sales_nodelperiod='0',net_cum_pursale_cf_ND='0'
       ,purchase_amt,sale_amt,purchase_rate,sal_rate,scrip_name,qnet=(cbv.pqty)-(cbv.sqty)  
from 
(
select  scrip_cd,series,sett_no,sauda_date,sett_type,party_name,party_code,pqty=sum(pqtytrd+pqtydel),sqty=sum(sqtytrd+sqtydel)
,purchase_amt=sum(pamtdel+pamttrd),sale_amt=sum(samtdel+samttrd),purchase_rate=sum(pamttrd+pamtdel)/(sum(pqtytrd+pqtydel)+1),sal_rate=sum(samttrd+samtdel)/(sum(sqtytrd+sqtydel)+1),net=(sum(pamtdel+pamttrd)-sum(samtdel+samttrd)),scrip_name
 from AngelBSECM.bsedb_ab.dbo.cmbillvalan  
/*where scrip_cd=@scrip_cd  and  sauda_date>=@date_from and sauda_date<@date_to and sett_no>=@settfrom2004033 and sett_no<@settto2004254*/
where scrip_cd=504375  and  sauda_date>='may 14 2004 00:00:000' and sauda_date<'mar 29 2005 00:00:000' and sett_no>=2004033 and sett_no<2005001


group by scrip_cd,series,sett_no,sett_type,party_name,party_code,sauda_date,scrip_name
) cbv, AngelBSECM.bsedb_ab.dbo.client4 c4, AngelBSECM.bsedb_ab.dbo.client1 c1, (select  party_code,commdate=min(sauda_date) from AngelBSECM.bsedb_ab.dbo.cmbillvalan group by party_code) x
where cbv.party_Code=x.party_Code and c4.defdp=1 and cbv.party_code=c4.party_code and c4.cl_code=c1.cl_code  
 order by cbv.sett_no

GO
