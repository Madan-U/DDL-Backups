-- Object: PROCEDURE dbo.SP_LEDGER_SB_PRN1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE SP_LEDGER_SB_PRN1(@fdate as varchar(11),@Tdate as varchar(11),@sbcode as varchar(11),@with_opnbal as varchar(1))                   
AS                  
                  
SET NOCOUNT ON                  
                  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                  
                  
/*              
Exec SP_LEDGER_SB_PRN1 'Apr  1 2006','Jan 19 2007','ZC','Y'           
declare @fdate as varchar(11),@Tdate as varchar(11),@sbcode as varchar(11),@with_opnbal as varchar(1)                  
set @fdate='Apr  1 2006'                  
set @tdate='Dec 31 2006'                  
set @sbcode='ZC'                  
set @with_opnbal = 'Y'                  
*/              
/*              
declare @fdate as varchar(11),@Tdate as varchar(11),@fcode as varchar(11),@Tcode as varchar(11),@MVNO AS VARCHAR(15),@with_opnbal as varchar(1)                  
set @fdate='Dec  1 2004'                  
set @tdate='Nov 30 2005'                  
set @fcode='28000001'                  
set @tcode='28999999'                  
set @with_opnbal = 'N'                  
*/              
      
select *,flag=' ' into #ledgera  from ledger_format                   
                  
if @with_opnbal='Y'                   
begin                  
 insert into #ledgera                  
 select coname='ACDLCM',cltcode,acname=space(200),vdt=@fdate,vtyp='18',shortdesc='OPENEN',      
 vno=replace(convert(varchar(10),convert(datetime,@fdate),102),'.','')+'0000',      
 narration='Opening Balance',                  
 Debit=case when       
 sum(case when drcr='D' then vamt else -vamt end) > 0 then sum(case when drcr='D' then vamt else -vamt end) else 0 end,                  
 Credit=case when       
 sum(case when drcr='C' then vamt else -vamt end) > 0 then sum(case when drcr='C' then vamt else -vamt end) else 0 end,Flag='Y'        
 from ledger a (nolock)      
 where vdt >= (select sdtcur from parameter where sdtcur<= @fdate and ldtcur >= @fdate+' 23:59:59')      
 and vdt < @fdate+' 00:00:00'                  
 and cltcode in (select code from Intranet.risk.dbo.ledger010909)--select pcode from Intranet.risk.dbo.pcode_temp --(select pcode from Temp_CLI_BSE)         
 group by cltcode      
  
end      
      
 insert into #ledgera                  
 select coname='ACDLCM',cltcode,substring(acname,1,200),vdt,vtyp,shortdesc,vno,substring(a.narration,1,200),                 
 Debit=(case when drcr='D' then vamt else 0 end),                  
 Credit=(case when drcr='C' then vamt else 0 end),Flag='Y'from ledger a (nolock),                 
 (select vtype,shortdesc from dbo.vmast ) b                   
 where a.vtyp=b.vtype and vdt >=@fdate+' 00:00:00' and vdt < @tdate+' 23:59:59'                  
 and cltcode in (select code from Intranet.risk.dbo.ledger010909)--select pcode from Intranet.risk.dbo.pcode_temp ---(select pcode from Temp_CLI_BSE)         
        
 update #ledgera set flag='N' where vdt < @fdate           
       
 delete from #ledgera where flag='N'        
 update #ledgera set acname = b.acname from acmast b (nolock) where #ledgera.cltcode=b.cltcode      
              
--update #ledgera set acname = b.long_name from client_Details b                   
--where b.party_Code=#ledgera.cltcode               
              
update #ledgera set cltcode=ltrim(rtrim(cltcode))              
update #ledgera set acname=ltrim(rtrim(acname))              
--update #ledgera set acname=substring(acname,1,40)+replicate(char(255),(40-len(Acname)))              
update #ledgera set acname=substring(acname,1,40)+replicate(' ',(40-len(Acname)))              
          
          
              
select *,tdt=convert(varchar(11),vdt,103) from #ledgera where debit+credit <> 0               
order by cltcode,coname,vno                  
                  
SET NOCOUNT OFF

GO
