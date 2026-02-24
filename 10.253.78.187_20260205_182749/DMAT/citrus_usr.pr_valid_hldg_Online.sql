-- Object: PROCEDURE citrus_usr.pr_valid_hldg_Online
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

 
--exec pr_valid_hldg  'CDSL','1234567890123456','C000012087', 1 ,''      
--exec pr_valid_hldg 'CDSL','1234567890123456','INE268A01031','700',''      
--select * from dp_acct_mstr where dpam_id = 61171      
--select * from bitmap_ref_mstr    
--insert into bitmap_ref_mstr     
--select 377, 'HLDG_WARN','HLDG_WARN','0','Y','','HO',getdate(),'HO',getdate(),1      
CREATE proc [citrus_usr].[pr_valid_hldg_Online](@pa_cd varchar(10),@pa_boid varchar(20),@pa_isin varchar(20),@pa_qty numeric(18,3),@pa_out varchar(125) output)      
as      
begin      
      
  declare @l_avail_qty numeric(18,3)      
  declare @l_unapprove_qty  numeric(18,3)      
  declare @l_approve_qty  numeric(18,3)      
  declare @l_hldg_qty  numeric(18,3)      
      
  set @l_avail_qty = 0      
  set @l_unapprove_qty = 0      
  set @l_approve_qty = 0       
  set @l_hldg_qty = 0     
  
delete from tmp_clientwise_holval
Insert into tmp_clientwise_holval  
Exec pr_acct_totalholding @pa_boid,'' 


if not exists(Select valuation from tmp_clientwise_holval where CLIENT_ID=@pa_boid and ISIN=ltrim(rtrim(@pa_isin)) 
and QTY>=@pa_qty)
begin 
set @pa_out='Holding for Entered ISIN does not Exists , Please check!'
return
end 


if exists(
--Select valuation from tmp_clientwise_holval where CLIENT_ID=@pa_boid and ISIN=@pa_isin and valuation>200000
Select valuation from tmp_clientwise_holval
LEFT OUTER JOIN CLOSING_PRICE_MSTR_cDSL with (nolock) ON @pa_isin = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL
 WHERE CLOPM_ISIN_CD = @pa_isin and CLOPM_DT <= convert(varchar(11),getdate(),109) and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)                    
 where CLIENT_ID=@pa_boid and ISIN=@pa_isin 
 --and valuation>200000
 and @pa_qty*CLOPM_CDSL_RT>200000

)
begin 

set @pa_out='Valuation is Higher than 2 Lacs , So it would not allow to punch!'
return
end 
if (@pa_cd='OFFM' Or @pa_cd='CDSL' )
begin

if exists (
SELECT SUM(@PA_QTY*CLOPM_CDSL_RT) FROM CLOSING_LAST_CDSL WHERE CLOPM_ISIN_CD=@PA_ISIN HAVING SUM(@PA_QTY*CLOPM_CDSL_RT)>200000
)
begin 
--print '23'
set @pa_out='Valuation is Higher than 2 Lacs , So it would not allow to punch!'
return
end  
end -- offm
if @pa_cd='ON'
begin
if exists (
Select SUM(@pa_qty*CLOPM_CDSL_RT) from CLOSING_LAST_CDSL where CLOPM_ISIN_CD=@pa_isin having SUM(@pa_qty*CLOPM_CDSL_RT)>500000
)
begin 
print '23'
set @pa_out='Valuation is Higher than 5 Lacs , So it would not allow to punch!'
return
end  
end -- on
  
      
       
end

GO
