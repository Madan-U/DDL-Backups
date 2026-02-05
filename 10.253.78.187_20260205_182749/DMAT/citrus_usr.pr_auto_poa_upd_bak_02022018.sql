-- Object: PROCEDURE citrus_usr.pr_auto_poa_upd_bak_02022018
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create  proc [citrus_usr].[pr_auto_poa_upd_bak_02022018]
as
begin 

declare @l_lst_mig datetime
set @l_lst_mig = ''
select @l_lst_mig=  isnull(dt ,'') from poaupd_log

--select * from dps8_pc5_tp where convert(datetime,TransSystemDate)  >  @l_lst_mig

declare @l_dpm_dpid  varchar(100)
declare @l_excsm_id varchar(100)
,@l_compm_id numeric
,@l_crn_no numeric
  declare @c_client_summary1  cursor  
                 ,@c_ben_acct_no1  varchar(20)
                 ,@l_dppd_details   varchar(8000)
                 
                 --  SELECT distinct  BOID   from dps8_pc5_tp where convert(datetime,TransSystemDate)  >  @l_lst_mig
                 --and boid in (select dpam_sba_no from dp_acct_mstr)

print @l_lst_mig
  
                 set @c_client_summary1  = CURSOR fast_forward FOR                
                 SELECT distinct  BOID   from dps8_pc5_tp where convert(datetime,TransSystemDate)  >  @l_lst_mig
                 and boid in (select dpam_sba_no from dp_acct_mstr)

          
          open @c_client_summary1  
          
          fetch next from @c_client_summary1 into @c_ben_acct_no1   
          
          
          
        WHILE @@fetch_status = 0                                                                                                          
        BEGIN --#cursor  
        --  



			 select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
			 where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid =  left(@c_ben_acct_no1,8) 
			  
			 select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
			  
			 select distinct @l_crn_no = dpam_crn_no from dp_acct_mstr, dps8_pc5_tp
			  WHERE BOID = @c_ben_acct_no1 AND dpam_sba_no  =BOID
			  
			 SET @l_dppd_details = ''  

			SELECT @l_dppd_details = @l_dppd_details  + isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no1,'')+'|*~|'+ISNULL(ltrim(rtrim('FULL')),'')+'|*~|'+ case when HolderNum ='1' then ISNULL(ltrim(rtrim('1ST HOLDER')),'') when HolderNum ='2' then ISNULL(ltrim(rtrim('2ND HOLDER')),'')  else ISNULL(ltrim(rtrim('3rd HOLDER')),'')  end +'|*~|'+ISNULL(ltrim(rtrim(dpam_sba_name)),'') +'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(POARegNum)),'')+'|*~|'+ISNULL(ltrim(rtrim(GPABPAFlg)),'')  
			  
			 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate) ,103),103) ELSE '' END   
			  
			 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103),103) ELSE '' END   
			  
			 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE('01011900'),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE('01011900'),103),103) ELSE '' END   
			  
			 --+'|*~|'+ltrim(rtrim(dpam_sba_no))+'|*~|'+'0'+'|*~|'+'0|*~|'+'A*|~*'  
			 
			+'|*~|'+ltrim(rtrim(dpam_sba_no))+'|*~|'+'0'+'|*~|'+'0|*~|0|*~|0|*~|'+'A*|~*'    

			 FROM dps8_pc5_tp mig, citrus_usr.poam WHERE left(poam_master_id ,2) ='22' 
			 and MasterPOAId = poam_master_id 
			 and  boid = @c_ben_acct_no1 AND POARegNum <>''   
			 and not exists (select 1 from dpb9_pc5  main where main.boid = mig.boid 
			 and main.MasterPOAId = mig.MasterPOAId
			 and main.POARegNum = mig.POARegNum
			 and main.SetupDate= mig.SetupDate
				and main.GPABPAFlg= mig.GPABPAFlg
				and main.EffFormDate= mig.EffFormDate
				and main.EffToDate= mig.EffToDate
				and main.HolderNum  = mig.HolderNum)
				 and not exists (select 1 from dp_poa_dtls  main, dp_Acct_mstr  where dpam_id = dppd_dpam_id 
				 and dpam_sba_no = mig.boid 
			 and main.dppd_master_id = mig.MasterPOAId
			 and main.dppd_poa_id = mig.POARegNum
			 and main.dppd_setup= convert(datetime,left(mig.SetupDate,2)+'/'+substring(mig.SetupDate,3,2) +'/' + right(mig.SetupDate,4),103)
			 and main.dppd_gpabpa_flg= mig.GPABPAFlg
				and main.dppd_eff_fr_dt= convert(datetime,left(mig.EffFormDate,2)+'/'+substring(mig.EffFormDate,3,2) +'/' + right(mig.EffFormDate,4),103) 
				and main.dppd_eff_TO_dt=convert(datetime,left( mig.EffToDate,2)+'/'+substring( mig.EffToDate,3,2) +'/' + right( mig.EffToDate,4),103)
				and case when main.DPPD_HLD ='1st holder' then 1 
				when main.DPPD_HLD ='2nd holder' then 2 
				when main.DPPD_HLD ='3rd holder' then 3 end  = mig.HolderNum)
			  
			  
			  

			  print @l_dppd_details
			  print @l_crn_no
			  EXEC pr_ins_upd_dppd '1',@l_crn_no,'EDT','MIG',@l_dppd_details,0,'*|~*','|*~|',''  
			  
			  
insert into client_list_modified	
select 
@c_ben_acct_no1,'','POA ACTIVATION',getdate(),getdate(),'MIG',getdate(),'MIG',getdate(),1,0


			  
			  fetch next from @c_client_summary1 into @c_ben_acct_no1   
			  
  
  
  
  end 
  
end 

  --EXEC pr_ins_upd_dppd '1',@l_crn_no,'EDT','MIG',@l_dppd_details,0,'*|~*','|*~|',''  


--create table poaupd_log (dt datetime)
insert into poaupd_log 
select max(convert(datetime,TransSystemDate)) from dps8_pc5_tp

GO
