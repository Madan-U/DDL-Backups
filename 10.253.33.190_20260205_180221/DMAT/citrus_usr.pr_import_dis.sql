-- Object: PROCEDURE citrus_usr.pr_import_dis
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_import_dis]     
as    
begin     
    
 begin tran    
    
    
 select identity(numeric,1,1) id , * into #stock from ANG_SLIP_ISSUE    
    
 declare @l_maxord_id numeric    
 select @l_maxord_id  = isnull(MAX(ors_id),0) from order_slip     
    
 insert into order_slip    
 select @l_maxord_id+id,@l_maxord_id+Id,'B',1,TOSLIPNO-FROMSLIPNO+1,@l_maxord_id+Id,@l_maxord_id+Id    
 ,FROMSLIPNO    
 ,TOSLIPNO    
 ,case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end     
 ,3    
 ,    
 '','',    
 GETDATE(),'TMIG',GETDATE(),'TMIG',1    
 ,ISSUE_DATE from #stock    
 where not exists (select 1 from Order_Slip     
 where ors_from_slip =FROMSLIPNO and TOSLIPNO = ors_to_slip     
 and  ors_tratm_id = case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end     
 )    
    
 declare @l_maxbook_id numeric    
 select @l_maxbook_id  = isnull( MAX(SLIBM_ID),0) from SLIP_BOOK_MSTR      
    
 insert into slip_book_mstr    
 select @l_maxbook_id+id,case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end ,3    
 ,'',FROMSLIPNO,TOSLIPNO,TOSLIPNO-FROMSLIPNO+1,0,'','MIGRATION','TMIG',GETDATE()    
 ,'TMIG',GETDATE(),1,@l_maxbook_id+id,'B',issue_date    
 from #stock    
 where not exists (select 1 from SLIP_BOOK_MSTR     
 where SLIBM_TRATM_ID = case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end    
 and SLIBM_SERIES_TYPE = ''    
 and SLIBM_FROM_NO = FROMSLIPNO    
 and SLIBM_TO_NO = TOSLIPNO)     
    
    
 declare @l_maxissue_id numeric    
 select @l_maxissue_id   =  isnull(MAX(SLIiM_ID),0) from SLIP_ISSUE_MSTR       
    
    
    
 select @l_maxissue_id+id id ,case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end tratmid,'' series ,dpam_id     
 ,dpam_sba_no dpamsba ,FROMSLIPNO,TOSLIPNO,0 fl1 ,'TMIG' fl2 ,GETDATE() fl3 ,'TMIG' fl4 ,GETDATE() fl5 ,1 fl6,3 fl7,0 fl8 ,0 fl9 ,issue_date,    
 null fl10 ,null fl11 ,null fl12 ,null fl13 ,null fl14 ,null fl15 ,null fl16 into #tempdata123    
 from #stock,dp_acct_mstr    
 where case when len(BENEF_ACCNO ) = 7 then '0' + convert(varchar,BENEF_ACCNO )    
 when len(BENEF_ACCNO ) = 6 then '00' + convert(varchar,BENEF_ACCNO )     
 when len(BENEF_ACCNO ) = 5 then '000' + convert(varchar,BENEF_ACCNO )     
 when len(BENEF_ACCNO ) = 4 then '0000' + convert(varchar,BENEF_ACCNO )     
 when len(BENEF_ACCNO ) = 3 then '00000' + convert(varchar,BENEF_ACCNO )     
 when len(BENEF_ACCNO ) = 2 then '000000' + convert(varchar,BENEF_ACCNO )     
 when len(BENEF_ACCNO ) = 1 then '0000000' + convert(varchar,BENEF_ACCNO )  end = right(dpam_sba_no ,8)    
 and left(DPAM_SBA_NO ,2) ='12'
 and not exists (select 1 from slip_issue_mstr     
 where  SLIIM_TRATM_ID = case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end     
 and SLIIM_SERIES_TYPE=''    
 and SLIIM_ENTM_ID=dpam_id    
 and SLIIM_DPAM_ACCT_NO=dpam_sba_no    
 and SLIIM_SLIP_NO_FR=FROMSLIPNO    
 and SLIIM_SLIP_NO_TO =TOSLIPNO)    
    
    
    
    
    
 insert into slip_issue_mstr    
 select * from  #tempdata123  
 
 
 
 declare @l_maxissue_id_poa numeric    
 select @l_maxissue_id_poa   =  isnull(MAX(SLIiM_ID),0) from SLIP_ISSUE_MSTR_poa       
    
    
    
 select @l_maxissue_id_poa+id id ,case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end tratmid,'' series ,dpam_id     
 ,dpam_sba_no dpamsba ,FROMSLIPNO,TOSLIPNO,0 fl1 ,'TMIG' fl2 ,GETDATE() fl3 ,'TMIG' fl4 ,GETDATE() fl5 ,1 fl6,3 fl7,0 fl8 ,0 fl9 ,issue_date,    
 null fl10 ,null fl11 ,null fl12 ,null fl13  into #tempdata123_poa
 from #stock,dp_acct_mstr    
 where case when len(BENEF_ACCNO ) = 7 then '0' + convert(varchar,BENEF_ACCNO )    
 when len(BENEF_ACCNO ) = 6 then '00' + convert(varchar,BENEF_ACCNO )     
 when len(BENEF_ACCNO ) = 5 then '000' + convert(varchar,BENEF_ACCNO )     
 when len(BENEF_ACCNO ) = 4 then '0000' + convert(varchar,BENEF_ACCNO )     
 when len(BENEF_ACCNO ) = 3 then '00000' + convert(varchar,BENEF_ACCNO )     
 when len(BENEF_ACCNO ) = 2 then '000000' + convert(varchar,BENEF_ACCNO )     
 when len(BENEF_ACCNO ) = 1 then '0000000' + convert(varchar,BENEF_ACCNO )  end = right(dpam_sba_no ,8)    
 and left(DPAM_SBA_NO ,2) ='22'
 and not exists (select 1 from SLIP_ISSUE_MSTR_poa     
 where  SLIIM_TRATM_ID = case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end     
 and SLIIM_SERIES_TYPE=''    
 and SLIIM_ENTM_ID=dpam_id    
 and SLIIM_DPAM_ACCT_NO=dpam_sba_no    
 and SLIIM_SLIP_NO_FR=FROMSLIPNO    
 and SLIIM_SLIP_NO_TO =TOSLIPNO)    
    
    
    insert into SLIP_ISSUE_MSTR_poa
    select * from #tempdata123_poa
      
    
 if @@ERROR <> 0     
 begin     
  rollback    
 end     
 else     
 begin     
  commit    
 end     
    
    
    
 --insert into slip_issue_mstr     
 --select @l_maxissue_id+id,case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end ,'',dpam_id    
 --,dpam_sba_no ,FROMSLIPNO,TOSLIPNO,0,'TMIG',GETDATE(),'TMIG',GETDATE(),1,3,0,0,issue_date,    
 --null,null,null,null,null,null,null    
 --from #stock,dp_acct_mstr    
 --where case when len(BENEF_ACCNO ) = 7 then '0' + convert(varchar,BENEF_ACCNO )    
 --when len(BENEF_ACCNO ) = 6 then '00' + convert(varchar,BENEF_ACCNO )     
 --when len(BENEF_ACCNO ) = 5 then '000' + convert(varchar,BENEF_ACCNO )     
 --when len(BENEF_ACCNO ) = 4 then '0000' + convert(varchar,BENEF_ACCNO )     
 --when len(BENEF_ACCNO ) = 3 then '00000' + convert(varchar,BENEF_ACCNO )     
 --when len(BENEF_ACCNO ) = 2 then '000000' + convert(varchar,BENEF_ACCNO )     
 --when len(BENEF_ACCNO ) = 1 then '0000000' + convert(varchar,BENEF_ACCNO )  end = right(dpam_sba_no ,8)    
 --select BENEF_ACCNO into #temp    
 --from #stock,dp_acct_mstr    
 --where  case when len(BENEF_ACCNO ) = 7 then '0' + convert(varchar,BENEF_ACCNO )    
 --when len(BENEF_ACCNO ) = 6 then '00' + convert(varchar,BENEF_ACCNO )     
 --when len(BENEF_ACCNO ) = 5 then '000' + convert(varchar,BENEF_ACCNO )     
 --when len(BENEF_ACCNO ) = 4 then '0000' + convert(varchar,BENEF_ACCNO )     
 --when len(BENEF_ACCNO ) = 3 then '00000' + convert(varchar,BENEF_ACCNO )     
 --when len(BENEF_ACCNO ) = 2 then '000000' + convert(varchar,BENEF_ACCNO )     
 --when len(BENEF_ACCNO ) = 1 then '0000000' + convert(varchar,BENEF_ACCNO )  end = right(dpam_sba_no ,8)     
    
 --select * from ANG_SLIP_ISSUE where BENEF_ACCNO not in (select benef_accno from #temp )    
    
    
    
    
    
    
 --select identity(numeric,1,1) id , * into #stock from stock where BENEF_ACCNO is not null     
    
 --select COUNT(1) from #stock    
 --insert into order_slip    
 --select 1+id,1+Id,'B',1,TOSLIPNO-FROMSLIPNO+1,1+Id,1+Id,FROMSLIPNO,TOSLIPNO    
 --,case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end ,3,    
 --'','',GETDATE(),'TMIG',GETDATE(),'TMIG',1,ISSUE_DATE from #stock    
    
 --select * from slip_book_mstr    
 --insert into slip_book_mstr    
 --select 1+id,case when SERIES in ('PLG1'  ,'PLG2','UNPLDG') then 1625 else 454 end ,3    
 --,'',FROMSLIPNO,TOSLIPNO,TOSLIPNO-FROMSLIPNO+1,0,'','MIGRATION','TMIG',GETDATE()    
 --,'TMIG',GETDATE(),1,1+id,'B',issue_date    
 --from #stock    
    
 --select * from slip_issue_mstr    
    
    
    
    
end

GO
