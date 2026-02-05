-- Object: PROCEDURE citrus_usr.pr_import_useddis
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_import_useddis]   
as  
begin   
 begin tran  
  
 select IDENTITY(numeric,1,1) id , * into #usedstock from ANG_USED_SLIPs  
  
  
 declare @l_maxuses_id numeric  
 select @l_maxuses_id  =ISNULL( max(uses_id) ,0) from  used_slip  
  
 insert into USED_SLIP   
 select @l_maxuses_id + id , 3,BOID,SLIPNO,1,'','U','MIG',GETDATE(),'MIG',GETDATE(),1,CONVERT(varchar(11),EXECDATE,109)   
 from #usedstock    
 where not exists (select 1 from used_slip   
 where USES_DPAM_ACCT_NO = BOID and USES_SLIP_NO = SLIPNO and USES_USED_DESTR ='U')   
  
 select IDENTITY(numeric,1,1) id , * into #loststock from ANG_Lost_slip  
  
  
  
 declare @l_maxlost_id numeric  
 select @l_maxlost_id  =ISNULL( max(uses_id),0) from  used_slip  
  
 insert into USED_SLIP   
 select @l_maxlost_id   + id , 3,BOID,SLIP_NO,1,'','D','MIG',GETDATE(),'MIG',GETDATE(),1,CONVERT(varchar(11),lost_date ,109)   
 from #loststock   
 where not exists (select 1 from used_slip   
 where USES_DPAM_ACCT_NO = CONVERT(VARCHAR,BOID ) and USES_SLIP_NO = SLIP_NO and USES_USED_DESTR ='D')   
  
  
  
 select IDENTITY(numeric,1,1) id , * into #rejectedstock from Rejected_Slip  
  
  
  
 declare @l_maxrejected_id numeric  
 select @l_maxrejected_id  =ISNULL( max(uses_id),0) from  used_slip  
  
 insert into USED_SLIP   
 select @l_maxrejected_id   + id , 3,BOID,SLIP_NO,1,'','U','MIG',GETDATE(),'MIG',GETDATE(),1,CONVERT(varchar(11),REJECTION_DATE,109)   
 from #rejectedstock   
 where not exists (select 1 from used_slip   
 where USES_DPAM_ACCT_NO = BOID and USES_SLIP_NO = SLIP_NO and USES_USED_DESTR ='U')   
  
  
 IF @@ERROR <> 0   
 BEGIN   
  ROLLBACK  
 END   
 ELSE  
 BEGIN    
  COMMIT  
 END   
   
  
  
end

GO
