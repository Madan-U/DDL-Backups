-- Object: PROCEDURE dbo.Angel_chg_slab_new
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure Angel_chg_slab_new (  
@sbcode as varchar(10),@tslab as varchar(10),@dslab as varchar(10),@ex as varchar(10),@segment as varchar(15)  
)    
as  
  
set nocount off    
set transaction isolation level read uncommitted    
if upper(@segment)='CAPITAL'
begin    
	update client_brok_Details set trd_brok=@tslab,del_brok=@dslab,Inst_trd_brok=@tslab,Inst_del_brok=@dslab,imp_status=0   
	where exchange=@ex and segment=@segment and cl_code in (SELECT CL_cODE FROM CLIENT_DETAILS WHERE SUB_bROKER=@SBCODE) 
	and inactive_From >= getdate()  
end
if upper(@segment)='FUTURES'
begin    
	update client_brok_Details set 
	Fut_BRok=@tslab,Fut_Opt_Brok=@tslab,Fut_Opt_Exc=@tslab,Fut_Fut_Fin_Brok=@dslab,imp_status=0   
	where exchange=@ex and segment=@segment and cl_code in (SELECT CL_cODE FROM CLIENT_DETAILS WHERE SUB_bROKER=@SBCODE) 
	and inactive_From >= getdate()  
end

set nocount on

GO
