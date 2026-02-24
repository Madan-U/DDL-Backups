-- Object: PROCEDURE dbo.usp_pledgedata_process
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

  
CREATE proc [dbo].[usp_pledgedata_process]  
as  
begin  
--create clustered index idx_pc on tbl_pledgedata_holding  (party_code)  
select * into #cdsl  
from   
(  
select distinct cl_code,cltdpid  from ANGELDEMAT.msajag.dbo.CLIENT4  B with (nolock)    
WHERE  Defdp=1 and bankid in ('12033201','12033200','12033202') AND DEPOSITORY = 'CDSL'  
union    
select distinct cl_code,cltdpid   from ANGELDEMAT.bsedb.dbo.CLIENT4  B with (nolock)    
WHERE  Defdp=1 and bankid in ('12033201','12033200','12033202') AND DEPOSITORY = 'CDSL'  
)a

truncate table tbl_pledgedata_holding  
insert into tbl_pledgedata_holding  
select party_code=tradingid,hld_ac_code as BOID,hld_isin_code as isin,Free_Qty=isnull(Free_Qty,0.00),  
pledge_qty=isnull(pledge_qty,0.00),datetimestamp=getdate(),poa_status=CAST('' as varchar(20)),  
email_Add=CAST('' as varchar(100)),FIRST_HOLD_MOBILE=CAST('' as varchar(100))  
from citrus_usr.holding  r (nolock)  inner join #cdsl C on r.tradingid=C.cl_code 
where Free_Qty<>0.00 or pledge_qty<>0.00-- 20034361

  
update tbl_pledgedata_holding set poa_status='Y',FIRST_HOLD_MOBILE=T.FIRST_HOLD_MOBILE,email_Add=T.email_Add    
from TBL_CLIENT_MASTER T with (nolock)  where ISNULL(poa_ver,'')=2   
and status='Active' AND nise_party_code is not null  
and tbl_pledgedata_holding.party_code=T.nise_party_code  
  
update tbl_pledgedata_holding set poa_status='N'  where poa_status is null or poa_status=''  
--select COUNT(1) from tbl_pledgedata_holding--19769075  
  
update tbl_pledgedata_holding set FIRST_HOLD_MOBILE=T.FIRST_HOLD_MOBILE,email_Add=T.email_Add    
from TBL_CLIENT_MASTER T with (nolock)   
where tbl_pledgedata_holding.party_code=T.nise_party_code  
  
exec [CSOKYC-6].general.dbo.Update_pledgedata_182  
  
  
end

GO
