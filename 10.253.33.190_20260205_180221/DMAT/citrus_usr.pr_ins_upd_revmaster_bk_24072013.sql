-- Object: PROCEDURE citrus_usr.pr_ins_upd_revmaster_bk_24072013
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create proc [citrus_usr].[pr_ins_upd_revmaster_bk_24072013](@pa_id numeric    
,@pa_action varchar(100)    
,@pa_BACode varchar(250)    
,@pa_Tranflag  varchar(100)    
,@pa_AMCFlag   varchar(100)    
,@pa_CDSLFlg   varchar(100)    
,@pa_DematEx  varchar(100)    
,@pa_RematEx  varchar(100)    
,@pa_cr  varchar(100)    
,@pa_dr  varchar(100)    
,@pa_pv  varchar(100)    
,@pa_amt numeric(18,3)    
,@pa_from_dt datetime    
,@pa_to_dt datetime    
,@pa_login_name varchar(100)    
,@pa_rowdelimiter varchar(100)    
,@pa_coldelimiter varchar(100)    
,@PA_ERRMSG varchar(100) out    
)    
as    
begin    
    
if @pa_action ='INS'    
begin     
    --alter table revenue_dtls add RAVD_ENTITY_NAME1 varchar(150)
insert into revenue_dtls    
select 'BA',@pa_BACode,@pa_Tranflag,@pa_AMCFlag,@pa_CDSLFlg    
,@pa_DematEx,@pa_RematEx,@pa_cr,@pa_dr,@pa_pv,@pa_amt    
,@pa_from_dt,@pa_to_dt,@pa_login_name,getdate(),@pa_login_name,getdate(),1,null    
where not exists (select * from revenue_dtls where @pa_BACode = RAVD_ENTITY and RAVD_DELETED_IND = 1 and     
(@pa_from_dt between RAVD_FROM_DT and RAVD_TO_DT or     
@pa_to_dt between RAVD_FROM_DT and RAVD_TO_DT))    
    
end     
if @pa_action ='EDT'    
begin     
    
UPDATE revenue_dtls    
SET RAVD_ENTITY = @pa_BACode    
,RAVD_TRAN=@pa_Tranflag    
,RAVD_AMC=@pa_AMCFlag    
,RAVD_CDSLYN=@pa_CDSLFlg    
,RAVD_DEMATYN=@pa_DematEx    
,RAVD_REMATYN=@pa_RematEx    
,RAVD_CR=@pa_cr    
,RAVD_DR=@pa_dr    
,RAVD_TYPE=@pa_pv    
,RAVD_AMT=@pa_amt    
,RAVD_FROM_DT=@pa_from_dt    
,RAVD_TO_DT=@pa_to_dt    
,RAVD_LST_UPD_BY = @PA_LOGIN_NAME    
,RAVD_LST_UPD_DT = GETDATE()    
WHERE ID = @PA_ID     
    
end     
if @pa_action ='DEL'    
begin     
    
UPDATE revenue_dtls    
SET RAVD_LST_UPD_BY = @PA_LOGIN_NAME    
,RAVD_LST_UPD_DT = GETDATE()    
,RAVD_DELETED_IND = 0     
WHERE ID = @PA_ID     
    
end     
if @pa_action ='SELECT'    
begin     
    
SELECT * FROM revenue_dtls     
WHERE 
-- ( @PA_FROM_DT  BETWEEN  RAVD_FROM_DT AND RAVD_TO_DT    
--OR   @PA_TO_DT    BETWEEN  RAVD_FROM_DT AND RAVD_TO_DT) 

(RAVD_FROM_DT   BETWEEN  @PA_FROM_DT AND @PA_TO_DT 
OR RAVD_TO_DT BETWEEN    @PA_FROM_DT AND @PA_TO_DT )
 and 
RAVD_ENTITY like  @pa_BACode   + '%'  
 

--AND RAVD_TRAN=@pa_Tranflag    
--AND RAVD_AMC=@pa_AMCFlag    
--AND RAVD_CDSLYN=@pa_CDSLFlg    
--AND RAVD_DEMATYN=@pa_DematEx    
--AND RAVD_REMATYN=@pa_RematEx    
--AND RAVD_CR=@pa_cr    
--AND RAVD_DR=@pa_dr    
--AND RAVD_TYPE=@pa_pv    
--AND RAVD_AMT=@pa_amt    
order by id desc     
end     
    
    
end

GO
