-- Object: PROCEDURE citrus_usr.PR_SELECT_TRXGEN_CDSL_SP_XML_harmonization_Bak_10012025
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------




create   PROCEDURE [citrus_usr].[PR_SELECT_TRXGEN_CDSL_SP_XML_harmonization_Bak_10012025]  
(  
@PA_TRX_TAB VARCHAR(8000),  
@PA_FROM_DT VARCHAR(20),  
@PA_TO_DT VARCHAR(20),  
@PA_BATCH_NO VARCHAR(10),  
@PA_BATCH_TYPE VARCHAR(2),  
@PA_EXCSM_ID INT,  
@PA_LOGINNAME VARCHAR(20),  
@PA_POOL_ACCTNO VARCHAR(16),
@PA_BROKER_YN CHAR(1), 
@ROWDELIMITER VARCHAR(20),  
@COLDELIMITER VARCHAR(20),  
@PA_OUTPUT VARCHAR(20) OUTPUT  
)  
AS  
BEGIN 
if exists (select 1 from sys.tables where name = 'PENINGEXPORT')
begin 
drop table PENINGEXPORT
end 
if exists (select 1 from sys.tables where name = 'tmp')
begin 
drop table tmp
end 

SELECT * INTO PENINGEXPORT FROM DP_TRX_DTLS_CDSL WHERE DPTDC_BATCH_NO IS NULL AND DPTDC_DELETED_IND = 1 

create table #tempdata(cd varchar(100),details varchar(8000),qty numeric(19,3),TRXEFLG varchar(5) ,
dptdc_slip_no varchar(16) , dptdc_created_by varchar(20) , dptdc_lst_upd_by varchar(20),verifier varchar(20),
dptdc_id numeric(19,0),request_dt varchar(14),usn numeric(18,0) )

--changes for NewDemat changes Feb 14 2020
create table #Demattempdatarange (id numeric identity(1,1), rngs varchar(8000),folio varchar(100),certfrom varchar(100),certto varchar(100),DNfrm varchar(100),DNto varchar(100),drfno varchar(100))
--changes for NewDemat changes Feb 14 2020

	DECLARE @@L_TRX_CD VARCHAR(5)  
  ,@L_QTY varchar(100)  
  ,@L_TOTQTY VARCHAR(100)   
  ,@L_SQL VARCHAR(8000)  
  ,@l_TRX_TAB varchar(8000)  
  ,@remainingstring varchar(8000)  
  ,@foundat int  
  ,@delimeter  varchar(50)  
  ,@currstring  varchar(500)  
        ,@delimeterlength int  
        ,@l_dpm_id int    ,@L_DPM_DPID varchar(8)
        ,@L_TOT_REC int  
        ,@L_TRANS_TYPE VARCHAR(8000)   
       SET @delimeter        = '%'+ @ROWDELIMITER + '%'  
      SET @delimeterlength = LEN(@ROWDELIMITER)  
      SET @remainingstring = @PA_TRX_TAB    
   SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND =1    
    SELECT @L_DPM_DPID = DPM_DPID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND =1    
  SET @L_TOT_REC = 0
  WHILE @remainingstring <> ''  
  BEGIN  
  --  
    SET @foundat = 0  
    SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)  
    --  
    IF @foundat > 0  
    BEGIN  
    --  
      SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)  
      SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)  
    --  
    END  
    ELSE  
    BEGIN  
    --  
      SET @currstring      = @remainingstring  
      SET @remainingstring = ''  
    --  
    END  
    --  
    IF @currstring <> ''  
    BEGIN  
    --  
      SET @l_TRX_TAB = citrus_usr.fn_splitval(@currstring,1) + '*|~*'  
    
		
print @l_TRX_TAB

--select @l_TRX_TAB  ,  
--@PA_FROM_DT ,  
--@PA_TO_DT ,  
--@PA_BATCH_NO ,  
--@PA_BATCH_TYPE ,  
--@PA_EXCSM_ID ,  
--@PA_LOGINNAME ,  
--@PA_POOL_ACCTNO ,
--@PA_BROKER_YN , 
--@ROWDELIMITER ,  
--@COLDELIMITER ,
--@PA_OUTPUT   
insert into #tempdata (details,qty,TRXEFLG ,dptdc_slip_no , dptdc_created_by , dptdc_lst_upd_by,verifier,dptdc_id,request_dt )
exec PR_SELECT_TRXGEN_CDSL_SP --_MOSL 
@l_TRX_TAB  ,  
@PA_FROM_DT ,  
@PA_TO_DT ,  
@PA_BATCH_NO ,  
@PA_BATCH_TYPE ,  
@PA_EXCSM_ID ,  
@PA_LOGINNAME ,  
@PA_POOL_ACCTNO ,
@PA_BROKER_YN , 
@ROWDELIMITER ,  
@COLDELIMITER ,
@PA_OUTPUT   


update #tempdata set cd =  citrus_usr.fn_splitval(@currstring,1) where cd is null  

--changes for NewDemat changes Feb 14 2020



update #tempdata set TRXEFLG=t.cnt from
(
Select ltrim(rtrim(substring(details , 45 , 16))) drf , count(1) OVER (PARTITION BY ltrim(rtrim(substring(details , 45 , 16))) 
) cnt
from #tempdata
where cd='DMAT'
) t
where cd='DMAT' and t.drf=ltrim(rtrim(substring(details , 45 , 16)))
--changes for NewDemat changes Feb 14 2020


  END  
  --  
  END  
    

--changes for NewDemat changes Feb 14 2020
--update #tempdata set TRXEFLG=LTRIM(rtrim(TRXEFLG))

select distinct '<Tp>'  + '1' + '</Tp>'
+'<Bnfcry>' + ltrim(rtrim(substring(details , 1 , 16))) + '</Bnfcry>'
+'<ISIN>' + ltrim(rtrim(substring(details , 17 , 12)))  + '</ISIN>'
+'<Qty>'+ case when ltrim(rtrim(substring(details , 17 , 3))) not in  ('INC','INF') then ltrim(rtrim(convert(varchar,convert(numeric,qty)))) else ltrim(rtrim(convert(varchar,qty))) end +'</Qty>'
+'<Drf>' +  ltrim(rtrim(substring(details , 45 , 16))) + '</Drf>'
+'<Pg>' + convert(varchar,convert(numeric,ltrim(rtrim(substring(details , 119 , 5))))) + '</Pg>' -- total cert
+'<Dspchid>' + ltrim(rtrim(substring(details , 61 , 20))) + '</Dspchid>'
+'<Dspchnm>' + case when ltrim(rtrim(substring(details , 61 , 20)))='' then '' else ltrim(rtrim(substring(details , 81 , 30))) end + '</Dspchnm>'
--+'<Dspchdt>' +  case when ltrim(rtrim(substring(details , 61 , 20)))='' then '' else ltrim(rtrim(substring(details , 111 , 8))) end + '</Dspchdt>'
+'<Dspchdt>' +   ltrim(rtrim(substring(details , 111 , 8)))  + '</Dspchdt>'
+'<Lcksts>' + ltrim(rtrim(substring(details , 124 , 1))) + '</Lcksts>'
+'<Lckcd>' + case when ltrim(rtrim(substring(details , 125 , 2)))='00' then '' else ltrim(rtrim(substring(details , 125 , 2))) end  + '</Lckcd>'
+'<Lckrem>' + ltrim(rtrim(substring(details , 127 , 50))) + '</Lckrem>'
+'<Lckexpdt>' + case when ltrim(rtrim(substring(details , 177 , 8)))='00000000' then '' else ltrim(rtrim(substring(details , 177 , 8))) end  + '</Lckexpdt>' 
+'<Rcvdt>' + request_dt + '</Rcvdt>'
+'<Ranges>' + case when (isin_cfi_cd='0' and ISIN_SECURITY_TYPE_DESCRIPTION not in ('Debentures') ) then  isnull(TRXEFLG,'')  else  '' end + '</Ranges>'
+'<DocTyp>' + isnull(dptdc_slip_no,'') + '</DocTyp>' as details ,  ltrim(rtrim(substring(details , 45 , 16))) drfnomain 
into #tempdataMainINCR from #tempdata 
left outer join isin_mstr on isin_cd=ltrim(rtrim(substring(details , 17 , 12)))
where cd  in ('DMAT') 

Select identity(int,1,1) id, '<Rngs>' + CONVERT(VARCHAR(1000),TRXEFLG ) + '</Rngs>' as rngs,'<Folio>' + dptdc_created_by + '</Folio>' as folio,'<CertFrm>' + dptdc_lst_upd_by  + '</CertFrm>' 
as dptdc_lst_upd_by,'<CertTo>' + dptdc_lst_upd_by + '</CertTo>'  as certto
,'<DNFrm>' +  verifier + '</DNFrm>' as DNfrm , '<DNTo>' +  convert(varchar,dptdc_id)  + '</DNTo>' as DNto,ltrim(rtrim(substring(details , 45 , 16))) drfno
into #tempdataINCR  
from #tempdata where cd  in ('DMAT') 
and ltrim(rtrim(substring(details , 17 , 12)))  in (select isin_cd from isin_mstr where isin_cfi_cd='0' and ISIN_SECURITY_TYPE_DESCRIPTION not in ('Debentures') )

 

select hl.id,	hl.rngs,	hl.folio	,hl.dptdc_lst_upd_by,	hl.certto	,hl.DNfrm,	hl.DNto,hl.drfno ,count(1) OVER (PARTITION BY hl.drfno ) AS cnt,
ROW_NUMBER() OVER (PARTITION BY hl.drfno ORDER BY hl.drfno) AS RowFilter into ##tempdataGrpINCR
from #tempdataINCR hl


--select * from ##tempdataGrpINCR

update ##tempdataGrpINCR set rngs=replace(rngs,rngs  , '<Rngs>' + convert(varchar,rowfilter) + '</Rngs>' )
 

insert into #Demattempdatarange
Select rngs,folio,dptdc_lst_upd_by,certto,DNfrm, dnfrmto,drfnomain  from (
select details as rngs,'' folio,'' dptdc_lst_upd_by,'' certto,'' DNfrm,'' dnfrmto,drfnomain ,'1' ord from #tempdataMainINCR
--where drfnomain='1441112' 
union all
select rngs,folio,dptdc_lst_upd_by,certto,DNfrm ,DNto as dnfrmto,drfno ,'2' ord  from ##tempdataGrpINCR
--where drfno='1441112'
) t
order by t.drfnomain,ord

--select  convert(varchar(8000),rngs)+convert(varchar,folio)+convert(varchar,certfrom)+convert(varchar,certto)+convert(varchar,DNfrm)+convert(varchar,dnto) ,'0' from #Demattempdatarange
--order by drfnomain
--select * from #Demattempdatarange order by drfno, case when  certfrom <> '' then  '2' else '1' end 
--changes for NewDemat changes Feb 14 2020

DELETE from #tempdata  where  dptdc_id IN  (SELECT  M.dptdc_id   FROM dp_trx_dtls_cdsl M where  M.DPTDC_SLIP_NO  like 'E%')

DECLARE @L_CNT NUMERIC,@l_lid numeric
select @l_lid = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd='USN_NO' and bitrm_deleted_ind=1
--
select identity(int,1,1) id, * into #tempdata_Usn from #tempdata where cd not in ('DMAT','DESTAT')

update #tempdata set Usn=@l_lid+id from #tempdata_Usn t ,#tempdata d where t.dptdc_id=d.dptdc_id and d.cd not in ('DMAT','DESTAT')


SELECT @L_CNT = COUNT(1) FROM #TEMPDATA

INSERT INTO DPTDC_USN
(
 USN_DPTDC_ID
,USN_BATCH_NO
,USN_NO
,USN_CREATED_BY
,USN_CREATED_DT
,USN_LST_UPD_BY
,USN_LST_UPD_DT
,USN_DELETED_IND
)
SELECT 
DPTDC_ID
,@PA_BATCH_NO
,Usn
,@PA_LOGINNAME
,GETDATE()
,@PA_LOGINNAME
,GETDATE()
,1
FROM #TEMPDATA where cd not in ('DMAT','DESTAT')

update bitmap_ref_mstr set bitrm_bit_location=bitrm_bit_location+@l_cnt+1 where bitrm_parent_cd='USN_NO' and bitrm_deleted_ind=1

drop table #tempdata_Usn

--select distinct case when cd = 'Dmat' then '<Tp>'  + '1' + '</Tp>'
--+'<Bnfcry>' + ltrim(rtrim(substring(details , 1 , 16))) + '</Bnfcry>'
--+'<ISIN>' + ltrim(rtrim(substring(details , 17 , 12)))  + '</ISIN>'
--+'<Qty>'+ case when ltrim(rtrim(substring(details , 17 , 3))) not in  ('INC','INF') then ltrim(rtrim(convert(varchar,convert(numeric,qty)))) else ltrim(rtrim(convert(varchar,qty))) end +'</Qty>'
--+'<Drf>' +  ltrim(rtrim(substring(details , 45 , 16))) + '</Drf>'
--+'<Pg>' + convert(varchar,convert(numeric,ltrim(rtrim(substring(details , 119 , 5))))) + '</Pg>' -- total cert
--+'<Dspchid>' + ltrim(rtrim(substring(details , 61 , 20))) + '</Dspchid>'
--+'<Dspchnm>' + case when ltrim(rtrim(substring(details , 61 , 20)))='' then '' else ltrim(rtrim(substring(details , 81 , 30))) end + '</Dspchnm>'
--+'<Dspchdt>' +  case when ltrim(rtrim(substring(details , 61 , 20)))='' then '' else ltrim(rtrim(substring(details , 111 , 8))) end + '</Dspchdt>'
--+'<Lcksts>' + ltrim(rtrim(substring(details , 124 , 1))) + '</Lcksts>'
--+'<Lckcd>' + case when ltrim(rtrim(substring(details , 125 , 2)))='00' then '' else ltrim(rtrim(substring(details , 125 , 2))) end  + '</Lckcd>'
--+'<Lckrem>' + ltrim(rtrim(substring(details , 127 , 50))) + '</Lckrem>'
--+'<Lckexpdt>' + case when ltrim(rtrim(substring(details , 177 , 8)))='00000000' then '' else ltrim(rtrim(substring(details , 177 , 8))) end  + '</Lckexpdt>' 
--+'<Rcvdt>' + request_dt + '</Rcvdt>'
----ok
select T.* into #HarmoTemp  from (
 Select distinct case WHEN cd = 'NP' THEN  '<Tp>'+ '3' +'</Tp>'
--+'<Dpstry>'+ ltrim(rtrim(substring(details , 1 , 2))) +'</Dpstry>'
+'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Dpstry>'+ '01' +'</Dpstry>'
+'<Clr>'+ ltrim(rtrim(substring(details , 4 , 2))) +'</Clr>'
+'<Xchg>'+ ltrim(rtrim(substring(details , 6 , 2))) +'</Xchg>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 8 , 13))) +'</Sttlm>'
+'<Ptcpt>'+ ltrim(rtrim(substring(details , 21 , 6))) +'</Ptcpt>'
+'<Mmb>'+ ltrim(rtrim(substring(details , 27 , 8))) +'</Mmb>'
--+'<Bnfcry>'+ ltrim(rtrim(substring(details , 34	 , 16))) +'</Bnfcry>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 35	 , 16))) +'</Bnfcry>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 51 , 12))) +'</ISIN>'
--+'<Qty>'+ ltrim(rtrim(convert(varchar,qty))) +'</Qty>'
--+'<Qty>'+ case when ltrim(rtrim(substring(details , 51 , 3)))='INF' then ltrim(rtrim(convert(varchar,qty))) else ltrim(rtrim(convert(varchar,convert(numeric,qty)))) end +'</Qty>'
+'<Qty>'+ case when ltrim(rtrim(substring(details , 51 , 3))) not in  ('INC','INF') then REPLACE(ltrim(rtrim(convert(varchar,convert(numeric,qty)))),'.000','') else REPLACE(ltrim(rtrim(convert(varchar,qty))),'.000','') end +'</Qty>'
+'<Flg>'+'S' +'</Flg>'
+'<Ref>'+ ltrim(rtrim(substring(details , 90 , 16))) +'</Ref>'

+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 35 , 16))),ltrim(rtrim(substring(details , 90 , 16)))) -- added for UCC on Sep 10 2022
--+'<Arf>'+ '' +'</Arf>'
--120420121201090001809694INE002A01018000000000020000SX10000039IN301862             6904769/1275   
--ok              
 WHEN cd = 'ID' THEN  +'<Tp>'+ '4' +'</Tp>'
 +'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Dt>' + ltrim(rtrim(substring(details , 1 , 8))) +'</Dt>'
+'<Bnfcry>' + ltrim(rtrim(substring(details , 9 , 16))) +'</Bnfcry>'
+'<ISIN>' +  ltrim(rtrim(substring(details , 25 , 12))) +'</ISIN>'
+'<Qty>'+ case when ltrim(rtrim(substring(details , 25 , 3))) not in  ('INC','INF') then ltrim(rtrim(convert(varchar,convert(numeric,qty)))) else ltrim(rtrim(convert(varchar,qty))) end +'</Qty>'
+'<Flg>'+ ltrim(rtrim(substring(details , 52 , 1))) +'</Flg>'
+'<Trf>'+ ltrim(rtrim(substring(details , 53 , 1))) +'</Trf>'
+'<Clnt>'+ ltrim(rtrim(substring(details , 54 , 8))) +'</Clnt>'
+'<Brkr>'+ ltrim(rtrim(substring(details , 62 , 8))) +'</Brkr>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 70 , 13))) +'</Sttlm>'

+'<Ref>'+ ltrim(rtrim(substring(details , 83 , 16))) +'</Ref>'
+'<CntrSttlm>'+ ltrim(rtrim(substring(details , 99 , 13))) +'</CntrSttlm>'
+
case when len(replace(details ,' ','|')) ='528' then '<Rsn>'+ ltrim(rtrim(substring(details , 112 , 1))) +'</Rsn>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  

+'<Dis>'+ isnull(dptdc_slip_no,'') +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
+'<Conamt>'+ case when ltrim(rtrim(substring(details , 112, 1)))='2' then isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83 , 16))),2,'/')),'')  else '' end +'</Conamt>'

+'<Remk>'+ case when ltrim(rtrim(substring(details , 112, 1)))='6' then isnull(citrus_usr.FN_CONSIDERATIONAMT('RMKS',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83 , 16))),2,'/')),'') else '' end  +'</Remk>'

+ case when ltrim(rtrim(substring(details , 112 , 1)))='2' and isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83, 16))),2,'/')),'')<>'' then 
+'<Paymod>' + ltrim(rtrim(substring(details , 113 , 1))) + '</Paymod>'
+'<Bnkno>' + ltrim(rtrim(substring(details , 114 , 35))) + '</Bnkno>'
+'<Bnkname>' + ltrim(rtrim(substring(details , 149 , 100))) + '</Bnkname>'
+'<Brnchname>' + ltrim(rtrim(substring(details , 249 , 100))) + '</Brnchname>'
+'<Xfername>' + ltrim(rtrim(substring(details , 349 , 150))) + '</Xfername>'
+'<Xferdt>' + ltrim(rtrim(substring(details , 499 , 8))) + '</Xferdt>'
+'<Chqrefno>' + ltrim(rtrim(substring(details , 507 , 22))) + '</Chqrefno>' 
--+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 9 , 16))),ltrim(rtrim(substring(details , 83 , 16)))) -- added for UCC on Sep 10 2022

else 
+'<Paymod>' + '' + '</Paymod>'
+'<Bnkno>' + '' + '</Bnkno>'
+'<Bnkname>' + '' + '</Bnkname>'
+'<Brnchname>' + '' + '</Brnchname>'
+'<Xfername>' + '' + '</Xfername>'
+'<Xferdt>' + '' + '</Xferdt>'
+'<Chqrefno>' + '' + '</Chqrefno>' 
+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 9 , 16))),replace(ltrim(rtrim(substring(details , 83 , 16))),'/','')) -- added for UCC on Sep 10 2022
 end

 when len(replace(details ,' ','|')) ='529' then '<Rsn>'+ ltrim(rtrim(substring(details , 112 , 2))) +'</Rsn>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  

+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
+'<Conamt>'+ case when ltrim(rtrim(substring(details , 112, 2)))='2' then isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83 , 16))),2,'/')),'')  else '' end +'</Conamt>'

+'<Remk>'+ case when ltrim(rtrim(substring(details , 112, 2)))='6' then isnull(citrus_usr.FN_CONSIDERATIONAMT('RMKS',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83 , 16))),2,'/')),'') else '' end  +'</Remk>' 

+ case when ltrim(rtrim(substring(details , 112 , 1)))='2' and isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83, 16))),2,'/')),'')<>'' then 
+'<Paymod>' + ltrim(rtrim(substring(details , 113 , 1))) + '</Paymod>'
+'<Bnkno>' + ltrim(rtrim(substring(details , 114 , 35))) + '</Bnkno>'
+'<Bnkname>' + ltrim(rtrim(substring(details , 149 , 100))) + '</Bnkname>'
+'<Brnchname>' + ltrim(rtrim(substring(details , 249 , 100))) + '</Brnchname>'
+'<Xfername>' + ltrim(rtrim(substring(details , 349 , 150))) + '</Xfername>'
+'<Xferdt>' + ltrim(rtrim(substring(details , 499 , 8))) + '</Xferdt>'
+'<Chqrefno>' + ltrim(rtrim(substring(details , 507 , 22))) + '</Chqrefno>' 

+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 9 , 16))),ltrim(rtrim(substring(details , 83 , 16)))) -- added for UCC on Sep 10 2022
else 

+'<Paymod>' + '' + '</Paymod>'
+'<Bnkno>' + '' + '</Bnkno>'
+'<Bnkname>' + '' + '</Bnkname>'
+'<Brnchname>' + '' + '</Brnchname>'
+'<Xfername>' + '' + '</Xfername>'
+'<Xferdt>' + '' + '</Xferdt>'
+'<Chqrefno>' + '' + '</Chqrefno>' 
--+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 9 , 16))),ltrim(rtrim(substring(details , 83 , 16)))) -- added for UCC on Sep 10 2022
+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 9 , 16))),replace(ltrim(rtrim(substring(details , 83 , 16))),'/',''))
 end
 when len(replace(details ,' ','|')) ='530' then '<Rsn>'+ ltrim(rtrim(substring(details , 112 , 2))) +'</Rsn>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  

+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
+'<Conamt>'+ case when ltrim(rtrim(substring(details , 112, 2)))='2' then isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83 , 16))),2,'/')),'')  else '' end +'</Conamt>'
+'<Remk>'+ case 
when ltrim(rtrim(substring(details , 112 , 3)))='311' then '1'
when ltrim(rtrim(substring(details , 112 , 3)))='312' then '2'
when ltrim(rtrim(substring(details , 112 , 3)))='313' then '3'
when ltrim(rtrim(substring(details , 112 , 3)))='314' then '4'
when ltrim(rtrim(substring(details , 112 , 3)))='315' then '5'
when ltrim(rtrim(substring(details , 112 , 3)))='316' then '6'
when ltrim(rtrim(substring(details , 112 , 3)))='317' then '7'
when ltrim(rtrim(substring(details , 112 , 3)))='318' then '8'
when ltrim(rtrim(substring(details , 112 , 3)))='319' then '9'
when ltrim(rtrim(substring(details , 112 , 4)))='3110' then '10'
when ltrim(rtrim(substring(details , 112, 2)))='6' then isnull(citrus_usr.FN_CONSIDERATIONAMT('RMKS',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83 , 16))),2,'/')),'') else '' end  +'</Remk>' 

+ case when ltrim(rtrim(substring(details , 112 , 1)))='2' and isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83, 16))),2,'/')),'')<>'' then 
+'<Paymod>' + ltrim(rtrim(substring(details , 113 , 1))) + '</Paymod>'
+'<Bnkno>' + ltrim(rtrim(substring(details , 114 , 35))) + '</Bnkno>'
+'<Bnkname>' + ltrim(rtrim(substring(details , 149 , 100))) + '</Bnkname>'
+'<Brnchname>' + ltrim(rtrim(substring(details , 249 , 100))) + '</Brnchname>'
+'<Xfername>' + ltrim(rtrim(substring(details , 349 , 150))) + '</Xfername>'
+'<Xferdt>' + ltrim(rtrim(substring(details , 499 , 8))) + '</Xferdt>'
+'<Chqrefno>' + ltrim(rtrim(substring(details , 507 , 22))) + '</Chqrefno>' 

+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 9 , 16))),ltrim(rtrim(substring(details , 83 , 16)))) -- added for UCC on Sep 10 2022
else 

+'<Paymod>' + '' + '</Paymod>'
+'<Bnkno>' + '' + '</Bnkno>'
+'<Bnkname>' + '' + '</Bnkname>'
+'<Brnchname>' + '' + '</Brnchname>'
+'<Xfername>' + '' + '</Xfername>'
+'<Xferdt>' + '' + '</Xferdt>'
+'<Chqrefno>' + '' + '</Chqrefno>' 
--+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 9 , 16))),ltrim(rtrim(substring(details , 83 , 16)))) -- added for UCC on Sep 10 2022

 end
 when len(replace(details ,' ','|')) ='531' then '<Rsn>'+ ltrim(rtrim(substring(details , 112 , 2))) +'</Rsn>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  

+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
+'<Conamt>'+ case when ltrim(rtrim(substring(details , 112, 2)))='2' then isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83 , 16))),2,'/')),'')  else '' end +'</Conamt>'
+'<Remk>'+ case 

when ltrim(rtrim(substring(details , 112 , 3)))='312' then '2'
when ltrim(rtrim(substring(details , 112 , 3)))='313' then '3'
when ltrim(rtrim(substring(details , 112 , 3)))='314' then '4'
when ltrim(rtrim(substring(details , 112 , 3)))='315' then '5'
when ltrim(rtrim(substring(details , 112 , 3)))='316' then '6'
when ltrim(rtrim(substring(details , 112 , 3)))='317' then '7'
when ltrim(rtrim(substring(details , 112 , 3)))='318' then '8'
when ltrim(rtrim(substring(details , 112 , 3)))='319' then '9'
when ltrim(rtrim(substring(details , 112 , 4)))='3110' then '10'

when ltrim(rtrim(substring(details , 112, 2)))='6' then isnull(citrus_usr.FN_CONSIDERATIONAMT('RMKS',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83 , 16))),2,'/')),'') else '' end  +'</Remk>' 

+ case when ltrim(rtrim(substring(details , 112 , 1)))='2' and isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 83, 16))),2,'/')),'')<>'' then 
+'<Paymod>' + ltrim(rtrim(substring(details , 113 , 1))) + '</Paymod>'
+'<Bnkno>' + ltrim(rtrim(substring(details , 114 , 35))) + '</Bnkno>'
+'<Bnkname>' + ltrim(rtrim(substring(details , 149 , 100))) + '</Bnkname>'
+'<Brnchname>' + ltrim(rtrim(substring(details , 249 , 100))) + '</Brnchname>'
+'<Xfername>' + ltrim(rtrim(substring(details , 349 , 150))) + '</Xfername>'
+'<Xferdt>' + ltrim(rtrim(substring(details , 499 , 8))) + '</Xferdt>'
+'<Chqrefno>' + ltrim(rtrim(substring(details , 507 , 22))) + '</Chqrefno>' 
+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 9 , 16))),ltrim(rtrim(substring(details , 83 , 16)))) -- added for UCC on Sep 10 2022
else 

+'<Paymod>' + '' + '</Paymod>'
+'<Bnkno>' + '' + '</Bnkno>'
+'<Bnkname>' + '' + '</Bnkname>'
+'<Brnchname>' + '' + '</Brnchname>'
+'<Xfername>' + '' + '</Xfername>'
+'<Xferdt>' + '' + '</Xferdt>'
+'<Chqrefno>' + '' + '</Chqrefno>' 
--+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 9 , 16))),ltrim(rtrim(substring(details , 83 , 16)))) -- added for UCC on Sep 10 2022
 end
end 
--+'<Arf>'+''+'</Arf>'
--
-- WHEN cd = 'OFFM' THEN  +'<Tp>'+ '5' +'</Tp>'
--+'<Dt>'+ substring(details , 1 , 8)+'</Dt>'
--+'<Bnfcry>'+ substring(details , 9 , 16)+'</Bnfcry>'
--+'<CtrPty>' +substring(details , 26 , 16)+  +'</CtrPty>'
--+'<ISIN>'+substring(details , 43 , 12) +'</ISIN>'
--+'<Qty>'+ substring(details , 53 , 15) +'</Qty>'
--+'<Flg>'+ substring(details , 72 , 1)+'</Flg>'
--+'<Trf>'+ substring(details , 74 , 1)+'</Trf>'
--+'<Rsn>'+ substring(details , 76 , 10)+'</Rsn>'
--+'<Ref>'+substring(details , 87 , 16) +'</Ref>'
--+'<Sttlm>'+ substring(details , 104 , 13)+'</Sttlm>'
--+'<CntrSttlm>'+ substring(details , 118 , 13)+'</CntrSttlm>'
--+'<Arf>'+ ''+'</Arf>'
--ok
WHEN cd = 'OFFM' THEN  +'<Tp>'+ '5' +'</Tp>'   
+'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Dt>'+ ltrim(rtrim(substring(details , 1 , 8))) +'</Dt>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 9 , 16))) +'</Bnfcry>'
+'<CtrPty>' + ltrim(rtrim(substring(details , 25 , 16)))  +'</CtrPty>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 41 , 12))) +'</ISIN>'
+'<Qty>'+ case when ltrim(rtrim(substring(details , 41 , 3))) not in  ('INC','INF') then ltrim(rtrim(convert(varchar,convert(numeric,qty)))) else ltrim(rtrim(convert(varchar,qty))) end +'</Qty>'
+'<Flg>'+ ltrim(rtrim(substring(details , 68 , 1))) +'</Flg>'
+'<Trf>'+ ltrim(rtrim(substring(details , 69 , 1))) +'</Trf>'

+case when len(replace(details ,' ','|')) ='528' then '<Rsn>'+ ltrim(rtrim(substring(details , 70 , 1))) +'</Rsn>'
+'<Ref>'+ ltrim(rtrim(substring(details , 71 , 16))) +'</Ref>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 87 , 13))) +'</Sttlm>'
+'<CntrSttlm>'+ ltrim(rtrim(substring(details , 100 , 13))) +'</CntrSttlm>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  
--+'<Poa>'+ TRXEFLG +'</Poa>'
+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
--+'<Conamt>'+ case when ltrim(rtrim(substring(details , 70 , 1)))='2' then isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 71, 16))),2,'/')),'')  else '' end +'</Conamt>'
+'<Conamt>'+  isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 71, 16))),2,'/')),'')   +'</Conamt>'
+'<Remk>'+ case when ltrim(rtrim(substring(details , 70 , 1)))='6' then isnull(citrus_usr.FN_CONSIDERATIONAMT('RMKS',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 71 , 16))),2,'/')),'') else '' end  +'</Remk>'
+ case when ltrim(rtrim(substring(details , 70 , 1)))='2' and isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 71, 16))),2,'/')),'')<>'' then 
+'<Paymod>' + isnull(ltrim(rtrim(substring(details , 113 , 1))),'') + '</Paymod>'
+'<Bnkno>' + isnull(ltrim(rtrim(substring(details , 114 , 35))),'') + '</Bnkno>'
+'<Bnkname>' + isnull(ltrim(rtrim(substring(details , 149 , 100))),'') + '</Bnkname>'
+'<Brnchname>' + isnull(ltrim(rtrim(substring(details , 249 , 100))),'') + '</Brnchname>'
+'<Xfername>' + isnull(ltrim(rtrim(substring(details , 349 , 150))),'') + '</Xfername>'
+'<Xferdt>' + isnull(ltrim(rtrim(substring(details , 499 , 8))),'') + '</Xferdt>'
+'<Chqrefno>' + isnull(ltrim(rtrim(substring(details , 507 , 22))),'') + '</Chqrefno>' 
else 

+'<Paymod>' + '' + '</Paymod>'
+'<Bnkno>' + '' + '</Bnkno>'
+'<Bnkname>' + '' + '</Bnkname>'
+'<Brnchname>' + '' + '</Brnchname>'
+'<Xfername>' + '' + '</Xfername>'
+'<Xferdt>' + '' + '</Xferdt>'
+'<Chqrefno>' + '' + '</Chqrefno>'
  end
when len(replace(details ,' ','|')) ='529' then  '<Rsn>'+ ltrim(rtrim(substring(details , 70 , 2))) +'</Rsn>'
+'<Ref>'+ ltrim(rtrim(substring(details , 72 , 16))) +'</Ref>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 88 , 13))) +'</Sttlm>'
+'<CntrSttlm>'+ ltrim(rtrim(substring(details , 101 , 13))) +'</CntrSttlm>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  
--+'<Poa>'+ TRXEFLG +'</Poa>'
+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
--+'<Conamt>'+ case when ltrim(rtrim(substring(details , 70 , 2)))='2' then isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 72, 16))),2,'/')),'')  else '' end +'</Conamt>'
+'<Conamt>'+  isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 72, 16))),2,'/')),'')   +'</Conamt>'
+'<Remk>'+ case when ltrim(rtrim(substring(details , 70 , 2)))='6' then isnull(citrus_usr.FN_CONSIDERATIONAMT('RMKS',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 72 , 16))),2,'/')),'') else '' end  +'</Remk>'

+ case when ltrim(rtrim(substring(details , 70 , 1)))='2' and isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 71, 16))),2,'/')),'')<>'' then 
+'<Paymod>' + ltrim(rtrim(substring(details , 113 , 1))) + '</Paymod>'
+'<Bnkno>' + ltrim(rtrim(substring(details , 114 , 35))) + '</Bnkno>'
+'<Bnkname>' + ltrim(rtrim(substring(details , 149 , 100))) + '</Bnkname>'
+'<Brnchname>' + ltrim(rtrim(substring(details , 249 , 100))) + '</Brnchname>'
+'<Xfername>' + ltrim(rtrim(substring(details , 349 , 150))) + '</Xfername>'
+'<Xferdt>' + ltrim(rtrim(substring(details , 499 , 8))) + '</Xferdt>'
+'<Chqrefno>' + ltrim(rtrim(substring(details , 507 , 22))) + '</Chqrefno>' 
else 
''
+'<Paymod>' + '' + '</Paymod>'
+'<Bnkno>' + '' + '</Bnkno>'
+'<Bnkname>' + '' + '</Bnkname>'
+'<Brnchname>' + '' + '</Brnchname>'
+'<Xfername>' + '' + '</Xfername>'
+'<Xferdt>' + '' + '</Xferdt>'
+'<Chqrefno>' + '' + '</Chqrefno>'

end
 when len(replace(details ,' ','|')) ='530' then '<Rsn>'+ ltrim(rtrim(substring(details , 70 , 2))) +'</Rsn>'
+'<Ref>'+ ltrim(rtrim(substring(details , 73 , 16))) +'</Ref>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 89 , 13))) +'</Sttlm>'
+'<CntrSttlm>'+ ltrim(rtrim(substring(details , 102 , 13))) +'</CntrSttlm>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  
--+'<Poa>'+ TRXEFLG +'</Poa>'
+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
--+'<Conamt>'+ case when ltrim(rtrim(substring(details , 70 , 2)))='2' then isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 73, 16))),2,'/')),'')  else '' end +'</Conamt>'
+'<Conamt>'+  isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 73, 16))),2,'/')),'')   +'</Conamt>'
+'<Remk>'+ case 
when ltrim(rtrim(substring(details , 70 , 3)))='311' then '1' 
when ltrim(rtrim(substring(details , 70 , 3)))='312' then '2'
when ltrim(rtrim(substring(details , 70 , 3)))='313' then '3'
when ltrim(rtrim(substring(details , 70 , 3)))='314' then '4'
when ltrim(rtrim(substring(details , 70 , 3)))='315' then '5'
when ltrim(rtrim(substring(details , 70 , 3)))='316' then '6'
when ltrim(rtrim(substring(details , 70 , 3)))='317' then '7'
when ltrim(rtrim(substring(details , 70 , 3)))='318' then '8'
when ltrim(rtrim(substring(details , 70 , 3)))='319' then '9'
when ltrim(rtrim(substring(details , 70 , 4)))='3110' then '10' 
when ltrim(rtrim(substring(details , 70 , 2)))='6' then isnull(citrus_usr.FN_CONSIDERATIONAMT('RMKS',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 73 , 16))),2,'/')),'') else '' end  +'</Remk>'

+ case when ltrim(rtrim(substring(details , 70 , 1)))='2' and isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 73, 16))),2,'/')),'')<>'' then 
+'<Paymod>' + isnull(ltrim(rtrim(substring(details , 113 , 1))),'') + '</Paymod>'
+'<Bnkno>' + isnull(ltrim(rtrim(substring(details , 114 , 35))),'') + '</Bnkno>'
+'<Bnkname>' + isnull(ltrim(rtrim(substring(details , 149 , 100))),'') + '</Bnkname>'
+'<Brnchname>' + isnull(ltrim(rtrim(substring(details , 249 , 100))),'') + '</Brnchname>'
+'<Xfername>' + isnull(ltrim(rtrim(substring(details , 349 , 150))),'') + '</Xfername>'
+'<Xferdt>' + isnull(ltrim(rtrim(substring(details , 499 , 8))),'') + '</Xferdt>'
+'<Chqrefno>' + isnull(ltrim(rtrim(substring(details , 507 , 22))),'') + '</Chqrefno>' 
else 
''
+'<Paymod>' + '' + '</Paymod>'
+'<Bnkno>' + '' + '</Bnkno>'
+'<Bnkname>' + '' + '</Bnkname>'
+'<Brnchname>' + '' + '</Brnchname>'
+'<Xfername>' + '' + '</Xfername>'
+'<Xferdt>' + '' + '</Xferdt>'
+'<Chqrefno>' + '' + '</Chqrefno>'

end
 when len(replace(details ,' ','|')) ='531' then '<Rsn>'+ ltrim(rtrim(substring(details , 70 , 2))) +'</Rsn>'
+'<Ref>'+ ltrim(rtrim(substring(details , 74 , 16))) +'</Ref>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 90 , 13))) +'</Sttlm>'
+'<CntrSttlm>'+ ltrim(rtrim(substring(details , 102 , 13))) +'</CntrSttlm>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  
--+'<Poa>'+ TRXEFLG +'</Poa>'
+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
--+'<Conamt>'+ case when ltrim(rtrim(substring(details , 70 , 2)))='2' then isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 74, 16))),2,'/')),'')  else '' end +'</Conamt>'
+'<Conamt>'+  isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 74, 16))),2,'/')),'')   +'</Conamt>'
+'<Remk>'+ case 
when ltrim(rtrim(substring(details , 70 , 3)))='312' then '2'
when ltrim(rtrim(substring(details , 70 , 3)))='313' then '3'
when ltrim(rtrim(substring(details , 70 , 3)))='314' then '4'
when ltrim(rtrim(substring(details , 70 , 3)))='315' then '5'
when ltrim(rtrim(substring(details , 70 , 3)))='316' then '6'
when ltrim(rtrim(substring(details , 70 , 3)))='317' then '7'
when ltrim(rtrim(substring(details , 70 , 3)))='318' then '8'
when ltrim(rtrim(substring(details , 70 , 3)))='319' then '9'
when ltrim(rtrim(substring(details , 70 , 4)))='3110' then '10' 

when ltrim(rtrim(substring(details , 70 , 2)))='6' then isnull(citrus_usr.FN_CONSIDERATIONAMT('RMKS',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 74 , 16))),2,'/')),'') else '' end  +'</Remk>'

+ case when ltrim(rtrim(substring(details , 70 , 1)))='2' and isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 74, 16))),2,'/')),'')<>'' then 
+'<Paymod>' + ltrim(rtrim(substring(details , 113 , 1))) + '</Paymod>'
+'<Bnkno>' + ltrim(rtrim(substring(details , 114 , 35))) + '</Bnkno>'
+'<Bnkname>' + ltrim(rtrim(substring(details , 149 , 100))) + '</Bnkname>'
+'<Brnchname>' + ltrim(rtrim(substring(details , 249 , 100))) + '</Brnchname>'
+'<Xfername>' + ltrim(rtrim(substring(details , 349 , 150))) + '</Xfername>'
+'<Xferdt>' + ltrim(rtrim(substring(details , 499 , 8))) + '</Xferdt>'
+'<Chqrefno>' + ltrim(rtrim(substring(details , 507 , 22))) + '</Chqrefno>' 
else 
''
+'<Paymod>' + '' + '</Paymod>'
+'<Bnkno>' + '' + '</Bnkno>'
+'<Bnkname>' + '' + '</Bnkname>'
+'<Brnchname>' + '' + '</Brnchname>'
+'<Xfername>' + '' + '</Xfername>'
+'<Xferdt>' + '' + '</Xferdt>'
+'<Chqrefno>' + '' + '</Chqrefno>'

end
else
'<Rsn>'+ ltrim(rtrim(substring(details , 70 , 1))) +'</Rsn>'
+'<Ref>'+ ltrim(rtrim(substring(details , 71 , 16))) +'</Ref>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 87 , 13))) +'</Sttlm>'
+'<CntrSttlm>'+ ltrim(rtrim(substring(details , 100 , 13))) +'</CntrSttlm>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  
--+'<Poa>'+ TRXEFLG +'</Poa>'
+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
--+'<Conamt>'+ case when ltrim(rtrim(substring(details , 70 , 1)))='2' then isnull(citrus_usr.FN_CONSIDERATIONAMT('CAMT',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 71, 16))),2,'/')),'')  else '' end +'</Conamt>'
+'<Conamt>'+  '' +'</Conamt>'
+'<Remk>'+ case when ltrim(rtrim(substring(details , 70 , 1)))='6' then isnull(citrus_usr.FN_CONSIDERATIONAMT('RMKS',citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(substring(details , 71 , 16))),2,'/')),'') else '' end  +'</Remk>'

+'<Paymod>' + '' + '</Paymod>'
+'<Bnkno>' + '' + '</Bnkno>'
+'<Bnkname>' + '' + '</Bnkname>'
+'<Brnchname>' + '' + '</Brnchname>'
+'<Xfername>' + '' + '</Xfername>'
+'<Xferdt>' + '' + '</Xferdt>'
+'<Chqrefno>' + '' + '</Chqrefno>'


end
+ isnull(citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 9 , 16))),convert(varchar,dptdc_id)) ,'')
--+'<Arf>'+ '' +'</Arf>'
--ok
 WHEN cd = 'EP' THEN  '<Tp>'+ '10' +'</Tp>'
 +'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Xchg>'+ ltrim(rtrim(substring(details , 1 , 2))) +'</Xchg>'
+'<Clr>'+ ltrim(rtrim(substring(details , 3 , 2))) +'</Clr>'
+'<Mmb>'+ ltrim(rtrim(substring(details , 5 , 8))) +'</Mmb>'
+'<Sttlm>' + ltrim(rtrim(substring(details , 13 , 13)))  + '</Sttlm>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 26	 , 16))) +'</Bnfcry>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 42 , 12))) +'</ISIN>'
--+'<Qty>'+ ltrim(rtrim(convert(varchar,qty))) +'</Qty>'
--+'<Qty>'+ ltrim(rtrim(convert(varchar,convert(numeric,qty))))+'</Qty>'
+'<Qty>'+ case when ltrim(rtrim(substring(details , 42 , 3))) not in  ('INC','INF') then REPLACE(ltrim(rtrim(convert(varchar,convert(numeric,qty)))),'.000','') else REPLACE(ltrim(rtrim(convert(varchar,qty))),'.000','') end +'</Qty>'
+'<Flg>'+ ltrim(rtrim(substring(details , 69 , 1))) +'</Flg>'
+'<CtrPty>' + ltrim(rtrim(substring(details , 70 , 16))) + '</CtrPty>'
+'<Ref>'+ ltrim(rtrim(substring(details , 86 , 16))) + '</Ref>'
+'<Dt>' + ltrim(rtrim(substring(details , 102 , 8)))  + '</Dt>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
+ citrus_usr.FN_UCCMAP_DETAILS_UCCDIS(ltrim(rtrim(substring(details , 26 , 16))),ltrim(rtrim(substring(details , 86 , 16)))) -- added for UCC on Sep 10 2022
--+'<Arf>'+ '' +'</Arf>'
-- WHEN cd = 'PLEDGE' THEN  '<Tp>'+ '7' +'</Tp>'
--+'<Usn>'+ convert(varchar,usn) +'</Usn>'
--+'<Pldgtp>'+ ltrim(rtrim(substring(details , 1 , 1))) +'</Pldgtp>'
--+'<Subtp>'+ ltrim(rtrim(substring(details , 2 , 1))) +'</Subtp>'
--+'<Lcksts>'+ ltrim(rtrim(substring(details , 3 , 1))) +'</Lcksts>'
--+'<Lckid>'+ ltrim(rtrim(substring(details , 4 , 16))) +'</Lckid>'
--+'<Prf>'+ ltrim(rtrim(substring(details , 20 , 8))) +'</Prf>'
--+'<Bnfcry>'+ ltrim(rtrim(substring(details , 28 , 16))) +'</Bnfcry>'
--+'<CtrPty>'+ ltrim(rtrim(substring(details , 44 , 16))) +'</CtrPty>'
--+'<ISIN>'+ ltrim(rtrim(substring(details , 60 , 12))) +'</ISIN>'
--+'<Qty>'+ ltrim(rtrim(convert(varchar,convert(numeric(18,3), qty)))) +'</Qty>'
--+'<Val>'+ convert(varchar,convert(numeric(15,2),left(ltrim(rtrim(substring(details , 88 , 15))),13)+ '.' + right(ltrim(rtrim(substring(details , 88 , 15))),2))) +'</Val>'
--+'<Xpry>'+ ltrim(rtrim(substring(details , 103 , 8))) +'</Xpry>'
--+'<Ref>'+ ltrim(rtrim(substring(details , 127 , 16))) +'</Ref>'
--+'<Agrmt>'+ ltrim(rtrim(substring(details , 143 , 20))) +'</Agrmt>'
--+'<Remk>'+ ltrim(rtrim(substring(details , 163 , 100))) +'</Remk>'
--+'<Psn></Psn>'
--+'<Rcvdt>' + request_dt + '</Rcvdt>'
--WHEN cd = 'DESTAT' THEN  


 WHEN (cd = 'PLEDGE' AND verifier='CRTE') THEN  '<Tp>'+ '7' +'</Tp>'
+'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Pldgtp>'+ ltrim(rtrim(substring(details , 1 , 1))) +'</Pldgtp>'
+'<Subtp>'+ ltrim(rtrim(substring(details , 2 , 1))) +'</Subtp>'
+'<Lcksts>'+ ltrim(rtrim(substring(details , 3 , 1))) +'</Lcksts>'
+'<Lckid>'+ ltrim(rtrim(substring(details , 4 , 16))) +'</Lckid>'
+'<Prf>'+ ltrim(rtrim(substring(details , 20 , 8))) +'</Prf>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 28 , 16))) +'</Bnfcry>'
+'<CtrPty>'+ ltrim(rtrim(substring(details , 44 , 16))) +'</CtrPty>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 60 , 12))) +'</ISIN>'
--+'<Qty>'+ ltrim(rtrim(convert(varchar,convert(numeric, qty)))) +'</Qty>'
 +'<Qty>'+ REPLACE(ltrim(rtrim(convert(varchar,qty))),'.000','')  +'</Qty>'
 +'<Val>'+ convert(varchar,convert(numeric(15,2),left(ltrim(rtrim(substring(details , 88 , 15))),13)))+'</Val>'
 ---'.' + right(ltrim(rtrim(substring(details , 88 , 15))),2))) +'</Val>'
+'<Xpry>'+ ltrim(rtrim(substring(details , 103 , 8))) +'</Xpry>'
+'<Ref>'+ ltrim(rtrim(substring(details , 127 , 16))) +'</Ref>'
+'<Agrmt>'+ ltrim(rtrim(substring(details , 143 , 20))) +'</Agrmt>'
+'<Remk>'+ ltrim(rtrim(substring(details , 163 , 100))) +'</Remk>'
+'<Psn></Psn>'
+'<Rcvdt>' + request_dt + '</Rcvdt>'

+'<PldgIdntfr></PldgIdntfr>'
+ citrus_usr.FN_UCCMAP_DETAILS('N' + ltrim(rtrim(substring(details , 28 , 16))),ltrim(rtrim(substring(details , 127 , 16))))


when (cd = 'PLEDGE' AND verifier='CLOS') THEN  '<Tp>'+ '7' +'</Tp>'
+'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Pldgtp>'+ ltrim(rtrim(substring(details , 1 , 1))) +'</Pldgtp>'
+'<Subtp>'+ ltrim(rtrim(substring(details , 2 , 1))) +'</Subtp>'
+'<Psn>'+ dptdc_lst_upd_by +'</Psn>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 28 , 16))) +'</Bnfcry>'
+'<CtrPty>'+ ltrim(rtrim(substring(details , 44 , 16))) +'</CtrPty>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 60 , 12))) +'</ISIN>'
+ case when dptdc_slip_no='PLEDGOR' then '' else  '<Ctrptyref>' + convert(varchar,dptdc_id) +'</Ctrptyref>' end
+ case when dptdc_slip_no='PLEDGOR' then '' else '<Cntr>' + 
--case when 
--exists(select top 1 pldtc_id from cdsl_pledge_dtls where PLDTC_TRANS_NO=dptdc_lst_upd_by and PLDTC_QTY<>ltrim(rtrim(convert(varchar,convert(numeric, qty))))) 
--then '1' else '2' end  
(
    select convert(varchar,count(1)+1) from 
	(
	SELECT DISTINCT CDSHM_TRAS_DT,CDSHM_INT_REF_NO FROM CDSL_HOLDING_DTLS WHERE CDSHM_TRANS_NO=dptdc_lst_upd_by AND CDSHM_BEN_ACCT_NO=ltrim(rtrim(substring(details , 28 , 16))) 
	and CDSHM_ISIN=ltrim(rtrim(substring(details , 60 , 12)))
	AND CDSHM_INTERNAL_TRASTM<>'PLEDGE' 
	) t 
)
+ '</Cntr>' end

--+'<PrtQty>'+ ltrim(rtrim(convert(varchar,convert(numeric, qty)))) +'</PrtQty>'
+'<PrtQty>'+ REPLACE(ltrim(rtrim(convert(varchar,qty))),'.000','') +'</PrtQty>'
+ case when dptdc_slip_no='PLEDGOR' then '<Ref>'+ convert(varchar,dptdc_id) +'</Ref>' else ''  end
+'<Remk>'+ ltrim(rtrim(substring(details , 163 , 100))) +'</Remk>'
+'<Rcvdt>' + request_dt + '</Rcvdt>'
when (cd = 'PLEDGE' AND verifier='UCLOS') THEN  '<Tp>'+ '7' +'</Tp>'
+'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Pldgtp>'+ ltrim(rtrim(substring(details , 1 , 1))) +'</Pldgtp>'
+'<Subtp>'+ ltrim(rtrim(substring(details , 2 , 1))) +'</Subtp>'
+'<Psn>'+ dptdc_lst_upd_by +'</Psn>'
+'<Bnfcry>'+  ltrim(rtrim(substring(details , 44 , 16)))+'</Bnfcry>'
+'<CtrPty>'+ ltrim(rtrim(substring(details , 28 , 16))) +'</CtrPty>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 60 , 12))) +'</ISIN>'
+'<Ctrptyref>' + convert(varchar,dptdc_id) +'</Ctrptyref>'
--+'<Cntr>' + case when exists(select top 1 pldtc_id from cdsl_pledge_dtls where PLDTC_TRANS_NO=dptdc_lst_upd_by and PLDTC_QTY<>ltrim(rtrim(convert(varchar,convert(numeric, qty))))) then '1' else '2' end  + '</Cntr>'

--+'<PrtQty>'+ ltrim(rtrim(convert(varchar,convert(numeric, qty)))) +'</PrtQty>'
+'<PrtQty>'+ REPLACE(ltrim(rtrim(convert(varchar,qty))),'.000','') +'</PrtQty>'
+ case when ltrim(rtrim(substring(details , 2 , 1)))='S' then '' else '<Ref>'+ convert(varchar,dptdc_id) +'</Ref>' end--case when ltrim(rtrim(substring(details , 2 , 1)))='A' then '' else end
+'<Remk>'+ ltrim(rtrim(substring(details , 163 , 100))) +'</Remk>'
+'<Rcvdt>' + request_dt + '</Rcvdt>'
when (cd = 'PLEDGE' AND verifier='INVK') THEN  '<Tp>'+ '7' +'</Tp>'
+'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Pldgtp>'+ ltrim(rtrim(substring(details , 1 , 1))) +'</Pldgtp>'
+'<Subtp>'+ ltrim(rtrim(substring(details , 2 , 1))) +'</Subtp>'
+'<Psn>'+ dptdc_lst_upd_by +'</Psn>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 28 , 16))) +'</Bnfcry>'
+'<CtrPty>'+ ltrim(rtrim(substring(details , 44 , 16))) +'</CtrPty>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 60 , 12))) +'</ISIN>'
+'<Ctrptyref>' + convert(varchar,dptdc_id) +'</Ctrptyref>'
--+'<Cntr>' + case when exists(select top 1 pldtc_id from cdsl_pledge_dtls where PLDTC_TRANS_NO=dptdc_lst_upd_by and PLDTC_QTY<>ltrim(rtrim(convert(varchar,convert(numeric, qty))))) then '1' else '2' end  + '</Cntr>'

--+'<PrtQty>'+ ltrim(rtrim(convert(varchar,convert(numeric, qty)))) +'</PrtQty>'
+'<PrtQty>'+ REPLACE(ltrim(rtrim(convert(varchar,qty))),'.000','') +'</PrtQty>'
+ case when ltrim(rtrim(substring(details , 2 , 1)))='S' then '' else '<Ref>'+ dptdc_created_by +'</Ref>' end--case when ltrim(rtrim(substring(details , 2 , 1)))='A' then '' else end
+'<Remk>'+ ltrim(rtrim(substring(details , 163 , 100))) +'</Remk>'
+'<Rcvdt>' + request_dt + '</Rcvdt>'
+'<Invamt>' + ltrim(rtrim(replace(substring(details , 88 , 16),' ',''))) + '</Invamt>'
+ citrus_usr.FN_CUSPA_UCCMAP_DETAILS(ltrim(rtrim(substring(details , 28 , 16))),convert(varchar,dptdc_id)) 
else details end as details , qty ,dptdc_slip_no  slip_no, dptdc_id Intdptdc_id  --, len(replace(details ,' ','|')) v
from #tempdata --where dptdc_created_by not in (select dpam_sba_no from DP_ACCT_MSTR where DPAM_DELETED_IND=1)
where cd not in ('DMAT')
--changes for NewDemat changes Feb 14 2020
union all
select  convert(varchar(8000),rngs)+convert(varchar(1000),folio)+convert(varchar(1000),certfrom)+convert(varchar(1000),certto)+convert(varchar(1000),DNfrm)+convert(varchar(1000),dnto) ,'0',isnull(drfno,0) , 0 Intdptdc_id  from #Demattempdatarange
)
T
--changes for NewDemat changes Feb 14 2020

--select * from #HarmoTemp
select cast(details as xml) xmlField,IDENTITY(int,1,1) ID,qty,slip_no,Intdptdc_id into tmp from (
Select * from #HarmoTemp ) tb 



	If (@PA_TRX_TAB='DMAT*|~*' or @PA_TRX_TAB='DESTAT*|~*')
begin

select distinct
case when  (isnull(substring(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) ,4,5),'')<>'') then
'' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + '0' + ',' + ',' + case when @PA_TRX_TAB='DESTAT*|~*' then 'DES' else 'DMT'	end  + ' ,' + convert(varchar,ID) + ',' + isnull(convert(varchar,ltrim(rtrim(xmlField.value('(Ref)[1]', 'nvarchar(max)')))),'') + ',' + '033200'  + ',' + convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)'))  + ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)'))  + ',' + convert(varchar,xmlField.value('(Qty)[1]', 'nvarchar(max)')) + ' ,S,' + case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then ''  else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then isnull(left(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8),'') else  isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') end end + ',' + case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then '' else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then  right(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) else isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') end end+ ',' + isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') + ','+','+',' + left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6) + ',' + right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7) + ',' + left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6) + ',' + right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7) + ',' + isnull(convert(varchar,xmlField.value('(Dt)[1]', 'nvarchar(max)')),'') + ',' +  + ',,,' + case when 'DISFLAGIND'='Y' then '' else '' end + ',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Dis)[1]', 'nvarchar(max)')))),'') + ',' + case when (SELECT top 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')))='4' then '' else isnull(convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')),'') end + ','+','+','+','+','+','+','+','+',' + '' + ',' + '' + ',' + '' + ','+ CONVERT(VARCHAR(23),convert(datetime,SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 1, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 5, 4),105),126) + ','+ ',' + +','+ +','+ +','+ +','+ +','+','+','+',' + case when (isnull(convert(varchar,xmlField.value('(Qty)[1]', 'nvarchar(max)')),'')='0' and @PA_TRX_TAB='DESTAT*|~*' ) then 'ALL' else '' end  + ','+  isnull(convert(varchar,xmlField.value('(Drf)[1]', 'nvarchar(max)')),'') +','+','+','+','+','+','+ +','+','+','+','+','+','+','+','+','+','+','+','+''+','+' ,'+','+','+   + ','+ case when @PA_TRX_TAB='DESTAT*|~*' then (Select top 1 convert(varchar,count(1)) from demat_request_dtls where demrd_deleted_ind=1 and demrd_demrm_id=demrm_id) else case when isnull(citrus_usr.FN_ACTINACTISIN(DEMRM_ISIN),'')='Y' then isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Ranges)[1]', 'nvarchar(max)')))),'') else CONVERT(VARCHAR,ISNULL(DEMRM_TOTAL_CERTIFICATES,'0')) end end +','+ isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Ranges)[1]', 'nvarchar(max)')))),'') + ','+','+ +','+ case when @PA_TRX_TAB='DESTAT*|~*' then (Select top 1 convert(varchar(100),DEMRD_FOLIO_NO) from demat_request_dtls where demrd_deleted_ind=1 and demrd_demrm_id=demrm_id) else '' end + ','+ case when isnull(citrus_usr.FN_DRF_DTLSCHK(DEMRM_id),'')='Y' then '' else '0' end +','+case when isnull(citrus_usr.FN_DRF_DTLSCHK(DEMRM_id),'')='Y' then '' else '0' end +','+','+  + ','+ case when @PA_TRX_TAB='DESTAT*|~*' then '' else  SUBSTRING(isnull(convert(varchar,xmlField.value('(Dspchdt)[1]', 'nvarchar(max)')),''), 5, 4) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Dspchdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Dspchdt)[1]', 'nvarchar(max)')),''), 1, 2) end + ','+',' +','+  ','+case when  @PA_TRX_TAB='DESTAT*|~*' then '' else 'AC' end +','+ +','+ ','+','+',' + ',' + ','+convert(varchar(100),demrm_id)+','+ ','+ ','+'FRE' +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','++','+','+ ',' +'' + ','+','+','+','++','+','+','+','+','+ ','+','+','+','+','+','+','+','+','+','+','+',' 
 when  (isnull(substring(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) ,4,5),'')='') then
'' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + '0' + ',' + ',' + 'DMT'	  + ' ,' + convert(varchar,ID) + ',' + isnull(convert(varchar,ltrim(rtrim(xmlField.value('(Ref)[1]', 'nvarchar(max)')))),'') + ',' + '033200'  + ',' + ''  + ',' + '' + ',' + '' + ' ,,' + '' + ',' + '' + ',' + '' + ','+','+',' +  + ',' + '' + ',' + '' + ',' + '' + ',' + '' + ',' +  + ',,,' + '' + ',' + '' + ',' + '' + ','+','+','+','+','+','+','+','+',' + '' + ',' + '' + ',' + '' + ','+ '' + ','+ ',' + +','+ +','+ +','+ +','+ +','+','+','+',' + ','+  '' +','+','+','+','+','+','+ +','+','+','+','+','+','+','+','+','+','+','+','+''+','+' ,'+','+','+  + ','+ ''  +','+ '' + ',DN'+',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Rngs)[1]', 'nvarchar(max)')))),'') +',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Folio)[1]', 'nvarchar(max)')))),'') +',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(CertFrm)[1]', 'nvarchar(max)')))),'') +',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(CertTo)[1]', 'nvarchar(max)')))),'') +',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(DNFrm)[1]', 'nvarchar(max)')))),'') +','+ isnull(ltrim(rtrim(convert(varchar,xmlField.value('(DNTo)[1]', 'nvarchar(max)')))),'')  + ','+ '' + ','+',' +','+  ','+ '' +','+ +','+ ','+','+',' + ',' + ','+','+ ','+ ','+'' +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','++','+','+ ',' +'' + ','+','+','+','++','+','+','+','+','+ ','+','+','+','+','+','+','+','+','+','+','+',' 
else '' end
as Detailshar 
,slip_no,ID
Into #TmpDmat
FROM tmp 
,demrm_mak where 
DEMRM_SLIP_SERIAL_NO=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
and DEMRM_DELETED_IND=1 
order by slip_no
end

--select convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),* from tmp
--print '12'
--select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end 
--+ ',' + @PA_LOGINNAME + ',' + substring(DPM_DPID,3,5) + ',' 
--+ ',' + isnull((SELECT Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='Transaction Type upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)'))),'')	  
--+ ' ,' + isnull(convert(varchar,ID),'') 
--+ ',' + isnull(convert(varchar,ltrim(rtrim(xmlField.value('(Ref)[1]', 'nvarchar(max)')))),'') 
--+ ',' + isnull(substring(DPM_DPID,3,5),'') 
--+ ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) 
--+ ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)')),'') 
--+ ',' + isnull(convert(varchar,QTY),'') + ' ,S,' 
--+ isnull(case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then ''  else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then left(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) else  convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')) end end ,'')
--+ ',' + isnull(case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then '' else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then  right(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) else convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')) end end,'')
--+ ',' + isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') + ','+','
--+',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') 
--+ ',' + isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') 
--+ ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') 
--+ ',' + isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') 
--+ ',' + isnull(convert(varchar,xmlField.value('(Dt)[1]', 'nvarchar(max)')),'') 
--+ ',' + case when convert(varchar(3),convert(varchar,DPTDC_REASON_CD))='1' then 'GFT' else convert(varchar(3),convert(varchar,DPTDC_REASON_CD))	 end  
--+ ',,,' + case when 'DISFLAGIND'='Y' then 'PHY' else 'DISFLAGIND' end 
--+ ',' + ltrim(rtrim(convert(varchar,xmlField.value('(Dis)[1]', 'nvarchar(max)')))) 
--+ ',' + case when (SELECT Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')))='4' then '' else convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')) end 
--+ ','+','+','+','+','+','+','+','+',' + DPTDC_CREATED_BY + ',' + DPTDC_LST_UPD_BY + ',' + ISNULL(DPTDC_MID_CHK,'') + ','+','
--+ ',' +case when isnull(DPTDC_PAYMODE,'')='01' then 'CHQ' when isnull(DPTDC_PAYMODE,'')='02' then 'ELP' else 'CAP' end 
--+','+isnull(DPTDC_CHQ_REFNO,'')+','+isnull(convert(varchar,DPTDC_DOI),'')+','+isnull(DPTDC_BANKACNO,'')
--+','+isnull(DPTDC_BANKACNAME,'')+','+','+','+','+','+','+','+','+','+','+','+isnull(convert(varchar,DPTDC_LINE_NO),'0')
--+','+','+','+','+','+','+','+','+','+','+','+','+'BO'+','+' ,'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','
--+convert(varchar,ID)+','+','+','+',' + ',' + ','+ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)'))))
--+','+isnull(DPTDC_TRANSFEREENAME,'')+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','
--+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','
--+'HP'+','+','+ ',' +'' + ','+','+','+','+'DP'+','+','+','+','
--+','+convert(varchar,isnull(xmlField.value('(Clnt)[1]', 'nvarchar(max)'),''))+','+','+','+','+','+','+','+','
--as Detailshar

--FROM tmp,DP_ACCT_MSTR
--left outer join DP_POA_DTLS on DPPD_DPAM_ID=dpam_id and DPPD_DELETED_IND=1 and getdate() between dppd_eff_fr_dt and isnull(dppd_eff_TO_dt,'2099-12-31 00:00:00.000')
--,DP_MSTR,DPTDC_MAK where DPAM_DELETED_IND=1 
--and DPAM_SBA_NO=convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) AND DPAM_DPM_ID=DPM_ID AND default_dp=dpm_excsm_id
--and DPTDC_slip_no=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
--and DPTDC_DELETED_IND=1

--print '13'
--return


If (@PA_TRX_TAB='DMAT*|~*' or @PA_TRX_TAB='DESTAT*|~*')
begin
Select distinct
'BtchId,SndrId,BrnchId,CntrlSctiesDpstryPtcptRole,TxnTyp,LineNb,SeqNm,SrcCntrlSctiesDpstryPtcpt,SrcClntIdOrBnfclOwnrId,ISIN,Qty,BuySellInd,OthrDpstryPtcpt,CntrBnfclOwnrId,CntrCMBPId,Xchg,ClrMmbId,MktTpAndId,SctiesSttlmTxId,OthrMktTpAndId,OthrSctiesSttlmTxId,ExecDt,TrdRsnCd,PlgRsnCd,FrzRsnCd,DISTpInd,DISSrlNb,MstrPwrOfAttnyId,CustdlTxnFlg,UnqClntId,UnqClrMmbId,BrkrId,CtdnPtcptId,Sgmt,ClrSysId,UnqEXId,MkrOprId,ChckrOprtrId,VrfrOprtId,ReqRcvdDtFrBO,Rmks,MdOfPmt,PmtTxRefNb,PmtDt,Acct,BkNm,Brnch,EPAcct,AgrmtId,AllUnitsOrAmtInd,DRFNb,AuthntcnRefNb,EarlyPayInFlg,BlkInd,ClsrDt,PldgTp,Cnsdrtn,DrctPyotFlg,CuspaTxnFlg,CuspaNSDLClntId,CuspaNSDLDPId,DmsIndFlg,DrctPayInFlg,DISIssncDt,DISAlphaPart,DISBookltNb,DISBookltTp,DISCxlFlg,DISIssdToClntOrPwrOfAttnyHldr,DISSrlNbFr,DISSrlNbTo,ISTxTp,DISTxTp,NbOfSOA,NbOfRgs,RcrdTp,RcrdNb,FolioNb,CertNbFr,CertNbTo,DNRFr,DNRTo,DsptchDt,DsptchDocId,DsptchNm,DocRcvdDt,DocTp,NbOfInstrs,NbOfDISLeavs,OrgnlOrdrRefNb ,LckInRsnCd,LckInAddtlInf,LckInXpryDt,IntlRefNb ,TrfeeNm,PldgSubTp,FreeOrLckInFlg,LckInId ,PldgReqFormNb,Val,PldgrIntlRef,PldgeeIntlRef,PldgIdr,MrgnPldgSeqNb,PartCntr,OthrDpstryFlg,FrzTp,FrzLvl,FrzInittdBy,FrzSubOptn,FrznFor,FrzActvtnTp,FrzActvtnDt,FrzXpryDt,FrzRsnDesc,FrzQtyTp,FrzInstrId,RmtFlg,RRFNb,MtlFndTp,MtlFndAmt,MtlFndInd,TxId,TtlNbOfTrfeeBnfclOwnrs,MltplQty,IsseFlg,FlgOfLooseSlip,AcctClsrFlg,ChanlInd,IrrvsblRsnCd1,IrrvsblRsnCd2,IrrvsblRsnCd3,IrrvsblRsnCd4,OthrDpstryClntCdOfFrstNmnee,OthrDpstryClntCdOfScndNmnee,OthrDpstryClntCdOfThrdNmnee,OthrDpstryFlgOfFrstNmnee,OthrDpstryFlgOfScndNmnee,OtherDpstryFlgOfThrdNmnee,OthrClntIdOfFrstNmnee,OthrClntIdOfScndNmnee,OthrClntIdOfThrdNmnee,OthrDpstryPtcptIdOfFrstNmnee,OthrDpstryPtcptIdOfScndNmnee,OthrDpstryPtcptIdOfThrdNmnee,PctgShrOfFrstNmnee,PctgShrOfScndNmnee,PctgShrOfThrdNmnee,Prty,RjctnRsnCd1,RjctnRsnCd2,RjctnRsnCd3,RjctnRsnCd4,SndrRefNb1,SndrRefNb2,StmpDtyInd,StsChngRsn,PANAndHldgPttrnMtcgh,WthtCnsdrtnFlg,TrnsmssnRsn,OthrDpstryClntCd,OthrDpstryId,TxUnqId,BuyPrTrd,MstSrcCntrlSctiesDpstryPtcpt,Rsn,CrtDnm,ConfAmt,DISISDTxTp,Rsvd1,Rsvd2,Rsvd3,Rsvd4'
as Detailshar,0 id
union all
Select Detailshar,convert(numeric,id)  from #TmpDmat
 order by 2
end
else
begin



SELECT T.* FROM 
(
--Select distinct
--'BtchId,SndrId,BrnchId,CntrlSctiesDpstryPtcptRole,TxnTyp,LineNb,SeqNm,SrcCntrlSctiesDpstryPtcpt,SrcClntIdOrBnfclOwnrId,ISIN,Qty,BuySellInd,OthrDpstryPtcpt,CntrBnfclOwnrId,CntrCMBPId,Xchg,ClrMmbId,MktTpAndId,SctiesSttlmTxId,OthrMktTpAndId,OthrSctiesSttlmTxId,ExecDt,TrdRsnCd,PlgRsnCd,FrzRsnCd,DISTpInd,DISSrlNb,MstrPwrOfAttnyId,CustdlTxnFlg,UnqClntId,UnqClrMmbId,BrkrId,CtdnPtcptId,Sgmt,ClrSysId,UnqEXId,MkrOprId,ChckrOprtrId,VrfrOprtId,ReqRcvdDtFrBO,Rmks,MdOfPmt,PmtTxRefNb,PmtDt,Acct,BkNm,Brnch,EPAcct,AgrmtId,AllUnitsOrAmtInd,DRFNb,AuthntcnRefNb,EarlyPayInFlg,BlkInd,ClsrDt,PldgTp,Cnsdrtn,DrctPyotFlg,CuspaTxnFlg,CuspaNSDLClntId,CuspaNSDLDPId,DmsIndFlg,DrctPayInFlg,DISIssncDt,DISAlphaPart,DISBookltNb,DISBookltTp,DISCxlFlg,DISIssdToClntOrPwrOfAttnyHldr,DISSrlNbFr,DISSrlNbTo,ISTxTp,DISTxTp,NbOfSOA,NbOfRgs,RcrdTp,RcrdNb,FolioNb,CertNbFr,CertNbTo,DNRFr,DNRTo,DsptchDt,DsptchDocId,DsptchNm,DocRcvdDt,DocTp,NbOfInstrs,NbOfDISLeavs,OrgnlOrdrRefNb ,LckInRsnCd,LckInAddtlInf,LckInXpryDt,IntlRefNb ,TrfeeNm,PldgSubTp,FreeOrLckInFlg,LckInId ,PldgReqFormNb,Val,PldgrIntlRef,PldgeeIntlRef,PldgIdr,MrgnPldgSeqNb,PartCntr,OthrDpstryFlg,FrzTp,FrzLvl,FrzInittdBy,FrzSubOptn,FrznFor,FrzActvtnTp,FrzActvtnDt,FrzXpryDt,FrzRsnDesc,FrzQtyTp,FrzInstrId,RmtFlg,RRFNb,MtlFndTp,MtlFndAmt,MtlFndInd,TxId,TtlNbOfTrfeeBnfclOwnrs,MltplQty,IsseFlg,FlgOfLooseSlip,AcctClsrFlg,ChanlInd,IrrvsblRsnCd1,IrrvsblRsnCd2,IrrvsblRsnCd3,IrrvsblRsnCd4,OthrDpstryClntCdOfFrstNmnee,OthrDpstryClntCdOfScndNmnee,OthrDpstryClntCdOfThrdNmnee,OthrDpstryFlgOfFrstNmnee,OthrDpstryFlgOfScndNmnee,OtherDpstryFlgOfThrdNmnee,OthrClntIdOfFrstNmnee,OthrClntIdOfScndNmnee,OthrClntIdOfThrdNmnee,OthrDpstryPtcptIdOfFrstNmnee,OthrDpstryPtcptIdOfScndNmnee,OthrDpstryPtcptIdOfThrdNmnee,PctgShrOfFrstNmnee,PctgShrOfScndNmnee,PctgShrOfThrdNmnee,Prty,RjctnRsnCd1,RjctnRsnCd2,RjctnRsnCd3,RjctnRsnCd4,SndrRefNb1,SndrRefNb2,StmpDtyInd,StsChngRsn,PANAndHldgPttrnMtcgh,WthtCnsdrtnFlg,TrnsmssnRsn,OthrDpstryClntCd,OthrDpstryId,TxUnqId,BuyPrTrd,MstSrcCntrlSctiesDpstryPtcpt,Rsn,CrtDnm,ConfAmt,DISISDTxTp,Rsvd1,Rsvd2,Rsvd3,Rsvd4'
--as Detailshar , 0 ID
--union all
--select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + substring(DPM_DPID,3,5) + ',' + ',' + isnull((SELECT ltrim(rtrim(Standard_Value)) FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='Transaction Type Upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)'))),'')	  + ',' + isnull(convert(varchar,ID),'') + ',' + ltrim(rtrim(xmlField.value('(Usn)[1]', 'nvarchar(max)'))) + ',' + isnull(right(DPM_DPID,6),'') + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) + ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)')),'') + ',' + isnull(convert(varchar,QTY),'') + ' ,S,' + isnull(case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then ''  else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then left(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) else  convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')) end end ,'')+ ',' + isnull(case when isnull(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),'')='' then '' else case when len(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')))=16 then  right(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),16) else convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')) end end,'')+ ',' + isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') + ','+','+',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),5,4) + '-' +  substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),3,2)+ '-' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),1,2) + ',' + ISNULL((SELECT TOP 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%Trade Reason Code%' and CDSL_Old_Value=ISNULL(convert(varchar,left(DPTDC_REASON_CD,2)),'0')),'') + ',,,' + case when convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))='N' then 'PHY' else 'ESP' end + ',' + ltrim(rtrim(convert(varchar,xmlField.value('(Dis)[1]', 'nvarchar(max)')))) + ',' + case when (SELECT Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')))='4' then '' else convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')) end + ','+','+','+','+','+','+','+','+',' + DPTDC_CREATED_BY + ',' + DPTDC_LST_UPD_BY + ',' + ISNULL(DPTDC_MID_CHK,'') + ','+','+ ',' +case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then 'CHQ' when isnull(DPTDC_PAYMODE,'')='CASH PAYMENT' then 'CAP'  when isnull(DPTDC_PAYMODE,'')='ELECTRONIC PAYMENT' then 'ELP' else '' end+','+isnull(DPTDC_CHQ_REFNO,'')+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end+','+isnull(DPTDC_BANKACNO,'')+','+isnull(DPTDC_BANKACNAME,'')+','+ case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then ISNULL(DPTDC_BANKBRNAME,'') else  '' end  +','+','+','+','+','+','+','+','+','+','+case when DPTDC_LINE_NO='' then '0' else convert(varchar,isnull(DPTDC_LINE_NO,'0')) end+','+','+','+','+','+','+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end +','+','+','+','+','+'BO'+','+' ,'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+convert(varchar,ID)+','+','+','+',' + ',' + ','+ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)'))))+','+isnull(DPTDC_TRANSFEREENAME,'')+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+'HP'+','+','+ ',' +'' + ','+','+','+','+'DP'+','+','+','+','+','+convert(varchar,isnull(xmlField.value('(Clnt)[1]', 'nvarchar(max)'),''))+','+','+','+','+','+ ISNULL((SELECT TOP 1 REPLACE(Standard_Value,'31','') FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%REASON/ pURPOSE%' and left(DPTDC_REASON_CD,2)='31' and CDSL_Old_Value=ISNULL(replace(convert(varchar,DPTDC_REASON_CD),'31',''),'0')),'') +','+','+','+','+','+','+','
--as Detailshar ,ID

--FROM tmp,DP_ACCT_MSTR
--left outer join DP_POA_DTLS on DPPD_DPAM_ID=dpam_id and DPPD_DELETED_IND=1 and getdate() between dppd_eff_fr_dt and isnull(dppd_eff_TO_dt,'2099-12-31 00:00:00.000')
--,DP_MSTR,DPTDC_MAK where DPAM_DELETED_IND=1 
--and DPAM_SBA_NO=convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) 
--AND DPAM_DPM_ID=DPM_ID AND default_dp=dpm_excsm_id
----and DPTDC_slip_no=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
--and Intdptdc_id=dptdc_id
--and DPTDC_DELETED_IND=1
--AND DPTDC_INTERNAL_TRASTM IN ('BOBO')
--UNION ALL -- IDD
--select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + substring(DPM_DPID,3,5) + ',' + ',' + isnull((SELECT ltrim(rtrim(Standard_Value)) FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='Transaction Type Upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)'))),'')	  + ',' + isnull(convert(varchar,ID),'') + ',' + ltrim(rtrim(xmlField.value('(Usn)[1]', 'nvarchar(max)'))) + ',' + isnull(right(DPM_DPID,6),'') + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) + ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)')),'') + ',' + isnull(convert(varchar,QTY),'') + ' ,S,' + isnull(case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then ''  else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then left(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) else  convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')) end end ,'')+ ',' + isnull(case when isnull(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),'')='' then '' else case when len(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')))=16 then  right(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),16) else convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')) end end,'')+ ',' + isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') + ','+','+',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'')+isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') +isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),5,4) + '-' +  substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),3,2)+ '-' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),1,2) + ',' + ISNULL((SELECT TOP 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%Trade Reason Code%' and CDSL_Old_Value=ISNULL(convert(varchar,left(DPTDC_REASON_CD,2)),'0')),'') + ',,,' + case when convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))='N' then 'PHY' else 'ESP' end + ',' + ltrim(rtrim(convert(varchar,xmlField.value('(Dis)[1]', 'nvarchar(max)')))) + ',' + case when (SELECT Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')))='4' then '' else convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')) end + ','+','+','+','+','+','+','+','+',' + DPTDC_CREATED_BY + ',' + DPTDC_LST_UPD_BY + ',' + ISNULL(DPTDC_MID_CHK,'') + ','+','+ ',' +case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then 'CHQ' when isnull(DPTDC_PAYMODE,'')='CASH PAYMENT' then 'CAP'  when isnull(DPTDC_PAYMODE,'')='ELECTRONIC PAYMENT' then 'ELP' else '' end+','+isnull(DPTDC_CHQ_REFNO,'')+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end+','+isnull(DPTDC_BANKACNO,'')+','+isnull(DPTDC_BANKACNAME,'')+','+ case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then ISNULL(DPTDC_BANKBRNAME,'') else  '' end  +','+','+','+','+','+','+','+','+','+','+case when DPTDC_LINE_NO='' then '0' else convert(varchar,isnull(DPTDC_LINE_NO,'0')) end+','+','+','+','+','+','+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end +','+','+','+','+','+'BO'+','+' ,'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+convert(varchar,ID)+','+','+','+',' + ',' + ','+ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)'))))+','+isnull(DPTDC_TRANSFEREENAME,'')+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+'HP'+','+','+ ',' +'' + ','+','+','+','+'DP'+','+','+','+','+','+convert(varchar,isnull(xmlField.value('(Clnt)[1]', 'nvarchar(max)'),''))+','+','+','+','+','+ ISNULL((SELECT TOP 1 REPLACE(Standard_Value,'31','') FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%REASON/ pURPOSE%' and left(DPTDC_REASON_CD,2)='31' and CDSL_Old_Value=ISNULL(replace(convert(varchar,DPTDC_REASON_CD),'31',''),'0')),'') +','+','+','+','+','+','+','
--as Detailshar ,ID

--FROM tmp,DP_ACCT_MSTR
--left outer join DP_POA_DTLS on DPPD_DPAM_ID=dpam_id and DPPD_DELETED_IND=1 and getdate() between dppd_eff_fr_dt and isnull(dppd_eff_TO_dt,'2099-12-31 00:00:00.000')
--,DP_MSTR,DPTDC_MAK where DPAM_DELETED_IND=1 
--and DPAM_SBA_NO=convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) 
--AND DPAM_DPM_ID=DPM_ID AND default_dp=dpm_excsm_id
----and DPTDC_slip_no=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
--and Intdptdc_id=dptdc_id
--and DPTDC_DELETED_IND=1
--AND DPTDC_INTERNAL_TRASTM IN ('ID')
Select distinct
	'BtchId,SndrId,BrnchId,CntrlSctiesDpstryPtcptRole,TxnTyp,LineNb,SeqNm,SrcCntrlSctiesDpstryPtcpt,SrcClntIdOrBnfclOwnrId,ISIN,Qty,BuySellInd,OthrDpstryPtcpt,CntrBnfclOwnrId,CntrCMBPId,Xchg,ClrMmbId,MktTpAndId,SctiesSttlmTxId,OthrMktTpAndId,OthrSctiesSttlmTxId,ExecDt,TrdRsnCd,PlgRsnCd,FrzRsnCd,DISTpInd,DISSrlNb,MstrPwrOfAttnyId,CustdlTxnFlg,UnqClntId,UnqClrMmbId,BrkrId,CtdnPtcptId,Sgmt,ClrSysId,UnqEXId,MkrOprId,ChckrOprtrId,VrfrOprtId,ReqRcvdDtFrBO,Rmks,MdOfPmt,PmtTxRefNb,PmtDt,Acct,BkNm,Brnch,EPAcct,AgrmtId,AllUnitsOrAmtInd,DRFNb,AuthntcnRefNb,EarlyPayInFlg,BlkInd,ClsrDt,PldgTp,Cnsdrtn,DrctPyotFlg,CuspaTxnFlg,CuspaNSDLClntId,CuspaNSDLDPId,DmsIndFlg,DrctPayInFlg,DISIssncDt,DISAlphaPart,DISBookltNb,DISBookltTp,DISCxlFlg,DISIssdToClntOrPwrOfAttnyHldr,DISSrlNbFr,DISSrlNbTo,ISTxTp,DISTxTp,NbOfSOA,NbOfRgs,RcrdTp,RcrdNb,FolioNb,CertNbFr,CertNbTo,DNRFr,DNRTo,DsptchDt,DsptchDocId,DsptchNm,DocRcvdDt,DocTp,NbOfInstrs,NbOfDISLeavs,OrgnlOrdrRefNb ,LckInRsnCd,LckInAddtlInf,LckInXpryDt,IntlRefNb ,TrfeeNm,PldgSubTp,FreeOrLckInFlg,LckInId ,PldgReqFormNb,Val,PldgrIntlRef,PldgeeIntlRef,PldgIdr,MrgnPldgSeqNb,PartCntr,OthrDpstryFlg,FrzTp,FrzLvl,FrzInittdBy,FrzSubOptn,FrznFor,FrzActvtnTp,FrzActvtnDt,FrzXpryDt,FrzRsnDesc,FrzQtyTp,FrzInstrId,RmtFlg,RRFNb,MtlFndTp,MtlFndAmt,MtlFndInd,TxId,TtlNbOfTrfeeBnfclOwnrs,MltplQty,IsseFlg,FlgOfLooseSlip,AcctClsrFlg,ChanlInd,IrrvsblRsnCd1,IrrvsblRsnCd2,IrrvsblRsnCd3,IrrvsblRsnCd4,OthrDpstryClntCdOfFrstNmnee,OthrDpstryClntCdOfScndNmnee,OthrDpstryClntCdOfThrdNmnee,OthrDpstryFlgOfFrstNmnee,OthrDpstryFlgOfScndNmnee,OtherDpstryFlgOfThrdNmnee,OthrClntIdOfFrstNmnee,OthrClntIdOfScndNmnee,OthrClntIdOfThrdNmnee,OthrDpstryPtcptIdOfFrstNmnee,OthrDpstryPtcptIdOfScndNmnee,OthrDpstryPtcptIdOfThrdNmnee,PctgShrOfFrstNmnee,PctgShrOfScndNmnee,PctgShrOfThrdNmnee,Prty,RjctnRsnCd1,RjctnRsnCd2,RjctnRsnCd3,RjctnRsnCd4,SndrRefNb1,SndrRefNb2,StmpDtyInd,StsChngRsn,PANAndHldgPttrnMtcgh,WthtCnsdrtnFlg,TrnsmssnRsn,OthrDpstryClntCd,OthrDpstryId,TxUnqId,BuyPrTrd,MstSrcCntrlSctiesDpstryPtcpt,Rsn,CrtDnm,ConfAmt,DISISDTxTp,Rsvd1,Rsvd2,Rsvd3,Rsvd4'
	as Detailshar , 0 ID
	union all
	select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + substring(DPM_DPID,3,5) + ',' + ',' + isnull((SELECT top 1 ltrim(rtrim(Standard_Value)) FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='Transaction Type Upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=isnull(convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')),'')),'')	  + ',' + isnull(convert(varchar,ID),'') + ',' + ltrim(rtrim(xmlField.value('(Usn)[1]', 'nvarchar(max)'))) + ',' + '033200' + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) + ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)')),'') + ',' + isnull(convert(varchar,QTY),'') + ' ,S,' + isnull(case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then ''  else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then left(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) else  isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') end end ,'')+ ',' + isnull(case when isnull(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),'')='' then '' else case when len(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')))=16 then  right(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),16) else convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')) end end,'')+ ',' + isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') + ','+','+',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),5,4) + '-' +  substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),3,2)+ '-' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),1,2) + ',' + ISNULL((SELECT TOP 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%Trade Reason Code%' and CDSL_Old_Value=ISNULL(convert(varchar,left(DPTDC_REASON_CD,2)),'0')),'') + ',,,' + case when ((DPTDC_CREATED_BY=dpam_sba_no) and convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))='E') then 'OFM' when (DPTDC_CREATED_BY=dpam_sba_no and  convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))<>'E') then 'OFM' else case when convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))='N' then 'PHY' else 'ESP' end end+ ',' + case when DPTDC_CREATED_BY=dpam_sba_no then isnull(dptdc_slip_no,'') else isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Dis)[1]', 'nvarchar(max)')))),'') end + ',' + case when isnull((SELECT  top 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)'))),'')='4' then '' else isnull(convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')),'') end + ','+','+','+','+','+','+','+','+',' + case when DPTDC_CREATED_BY=dpam_sba_no then 'OFM' else DPTDC_CREATED_BY end + ',' + DPTDC_LST_UPD_BY + ',' + ISNULL(DPTDC_MID_CHK,'') + ','+','+ ',' +case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then 'CHQ' when isnull(DPTDC_PAYMODE,'')='CASH PAYMENT' then 'CAP'  when isnull(DPTDC_PAYMODE,'')='ELECTRONIC PAYMENT' then 'ELP' else '' end+','+isnull(DPTDC_CHQ_REFNO,'')+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end+','+isnull(DPTDC_BANKACNO,'')+','+isnull(DPTDC_BANKACNAME,'')+','+ case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then ISNULL(DPTDC_BANKBRNAME,'') else  '' end  +','+','+','+','+','+','+','+','+','+','+case when DPTDC_LINE_NO='' then '0' else convert(varchar,isnull(DPTDC_LINE_NO,'0')) end+','+','+','+','+','+','+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end +','+','+','+','+','+'BO'+','+' ,'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+convert(varchar,ID)+','+','+','+',' + ',' + ','+isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),'')+','+isnull(DPTDC_TRANSFEREENAME,'')+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+'HP'+','+','+ ',' +'' + ','+','+','+','+'DP'+','+','+','+','+','+convert(varchar,isnull(xmlField.value('(Clnt)[1]', 'nvarchar(max)'),''))+','+','+','+','+','+ ISNULL((SELECT TOP 1 REPLACE(Standard_Value,'31','') FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%REASON/ pURPOSE%' and left(DPTDC_REASON_CD,2)='31' and CDSL_Old_Value=ISNULL(replace(convert(varchar,DPTDC_REASON_CD),'31',''),'0')),'') +','+','+','+','+','+','+','
	as Detailshar ,ID

	FROM tmp,DP_ACCT_MSTR
	left outer join DP_POA_DTLS on DPPD_DPAM_ID=dpam_id and DPPD_DELETED_IND=1 and getdate() between dppd_eff_fr_dt and isnull(dppd_eff_TO_dt,'2099-12-31 00:00:00.000')
	,DP_MSTR,DPTDC_MAK where DPAM_DELETED_IND=1 
	and DPAM_SBA_NO=convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) 
	AND DPAM_DPM_ID=DPM_ID AND default_dp=dpm_excsm_id
	--and DPTDC_slip_no=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
	and Intdptdc_id=dptdc_id
	and DPTDC_DELETED_IND=1
	AND DPTDC_INTERNAL_TRASTM IN ('BOBO')
	UNION ALL -- IDD
	select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + substring(DPM_DPID,3,5) + ',' + ',' + isnull((SELECT  top 1 ltrim(rtrim(Standard_Value)) FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='Transaction Type Upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)'))),'')	  + ',' + isnull(convert(varchar,ID),'') + ',' + ltrim(rtrim(xmlField.value('(Usn)[1]', 'nvarchar(max)'))) + ',' + '033200' + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) + ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)')),'') + ',' + isnull(convert(varchar,QTY),'') + ' ,S,' + isnull(dptdc_counter_dp_id,'') + ',' + isnull(dptdc_counter_demat_acct_no,'')  + ',' + isnull(dptdc_counter_dp_id,'') + ',' + + ','+',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'')+isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') +isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),5,4) + '-' +  substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),3,2)+ '-' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),1,2) + ',' + ISNULL((SELECT TOP 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%Trade Reason Code%' and CDSL_Old_Value=ISNULL(convert(varchar,left(DPTDC_REASON_CD,2)),'0')),'') + ',,,' + case when ((DPTDC_CREATED_BY=dpam_sba_no) and convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))='E') then 'OFM' when (DPTDC_CREATED_BY=dpam_sba_no and  convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))<>'E') then 'OFM' else case when convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))='N' then 'PHY' else 'ESP' end end + ',' + case when DPTDC_CREATED_BY=dpam_sba_no then isnull(dptdc_slip_no,'') else isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Dis)[1]', 'nvarchar(max)')))),'') end  + ',' + case when (SELECT  top 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')))='4' then '' else convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')) end + ','+','+ isnull(dptdc_ucc,'') + ','+  + ','+  +','+  isnull(dptdc_tmcmid,'')+','+  +','+  + ','+ '' +',' + case when DPTDC_CREATED_BY=dpam_sba_no then 'OFM' else DPTDC_CREATED_BY end + ',' + DPTDC_LST_UPD_BY + ',' + ISNULL(DPTDC_MID_CHK,'') + ','+','+ ',' +case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then 'CHQ' when isnull(DPTDC_PAYMODE,'')='CASH PAYMENT' then 'CAP'  when isnull(DPTDC_PAYMODE,'')='ELECTRONIC PAYMENT' then 'ELP' else '' end+','+isnull(DPTDC_CHQ_REFNO,'')+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end+','+isnull(DPTDC_BANKACNO,'')+','+isnull(DPTDC_BANKACNAME,'')+','+ case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then ISNULL(DPTDC_BANKBRNAME,'') else  '' end  +','+','+','+','+','+','+','+','+','+','+case when DPTDC_LINE_NO='' then '0' else convert(varchar,isnull(DPTDC_LINE_NO,'0')) end+','+','+','+','+','+','+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end +','+','+','+','+','+'BO'+','+' ,'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+convert(varchar,ID)+','+','+','+',' + ',' + ','+ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)'))))+','+isnull(DPTDC_TRANSFEREENAME,'')+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+'HP'+','+','+ ',' +'' + ','+','+','+','+'DP'+','+','+','+','+','+convert(varchar,isnull(xmlField.value('(Clnt)[1]', 'nvarchar(max)'),''))+','+','+','+','+','+ ISNULL((SELECT TOP 1 REPLACE(Standard_Value,'31','') FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%REASON/ pURPOSE%' and left(DPTDC_REASON_CD,2)='31' and CDSL_Old_Value=ISNULL(replace(convert(varchar,DPTDC_REASON_CD),'31',''),'0')),'') +','+','+','+','+','+','+','
	as Detailshar ,ID

	FROM tmp,DP_ACCT_MSTR
	left outer join DP_POA_DTLS on DPPD_DPAM_ID=dpam_id and DPPD_DELETED_IND=1 and getdate() between dppd_eff_fr_dt and isnull(dppd_eff_TO_dt,'2099-12-31 00:00:00.000')
	,DP_MSTR,DPTDC_MAK where DPAM_DELETED_IND=1 
	and DPAM_SBA_NO=convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) 
	AND DPAM_DPM_ID=DPM_ID AND default_dp=dpm_excsm_id
	--and DPTDC_slip_no=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
	and Intdptdc_id=dptdc_id
	and DPTDC_DELETED_IND=1
	AND DPTDC_INTERNAL_TRASTM IN ('ID') and isnull(DPTDC_COUNTER_CMBP_ID,'')='' and  isnull(DPTDC_COUNTER_DP_ID,'')<>'' and isnull(dptdc_counter_demat_acct_no,'')<>'' 
	union all
	select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  
	when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME 	+ ',' + substring(DPM_DPID,3,5) + ',' + ',' + isnull((SELECT top 1 ltrim(rtrim(Standard_Value)) FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='Transaction Type Upload' 	AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)'))),'')	  	+ ',' + isnull(convert(varchar,ID),'') + ',' + ltrim(rtrim(xmlField.value('(Usn)[1]', 'nvarchar(max)'))) + ',' + '033200' + ',' 	+ isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) + ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)')),'') + ',' 	+ isnull(convert(varchar,QTY),'') + ' ,S,' + isnull(case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then ''  else 	case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then left(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) 	else  convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')) end end ,'')+ ',' 	+ isnull(case when isnull(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),'')='' then '' else 	case when len(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')))=16 then  right(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),16) 	else convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')) end end,'')+ ',' + isnull(convert(varchar,xmlField.value('(Brkr)[1]', 'nvarchar(max)')),'') 	+ ',' +  + ','+',' +  + ',' + isnull(convert(varchar,xmlField.value('(Sttlm)[1]', 'nvarchar(max)')),'')  + ',' + 	  + ',' + 	  	+ ',' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),5,4) + '-' +  substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),3,2)+ '-' 	+ substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),1,2) + ',' 	+ ISNULL((SELECT TOP 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%Trade Reason Code%' 	and CDSL_Old_Value=ISNULL(convert(varchar,left(DPTDC_REASON_CD,2)),'0')),'') + ',,,' 	+ case when convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))='N' then 'PHY' else 'POT' end + ',' + ltrim(rtrim(convert(varchar,xmlField.value('(Dis)[1]', 'nvarchar(max)')))) + ',' + case when (SELECT top 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')))='4' then '' else convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')) end + ','+ case when isnull(dptdc_EID,'')='CP' then 'CTR' else 'NCT' end   + ','+ case when isnull(dptdc_EID,'')='CP' then '' else  isnull(dptdc_ucc,'') end + ','+ case when isnull(dptdc_EID,'')='CP' then '' else  isnull(dptdc_tmcmid,'') end + ','+  case when isnull(dptdc_EID,'')='CP' then '' else  isnull(dptdc_tmcmid,'') end  + ','+','+ case when isnull(dptdc_EID,'')='CP' then '' else  'CM' end+ ','+case when isnull(dptdc_EID,'')='CP' then '' else   'ICCL' end+ ','+case when isnull(dptdc_EID,'')='CP' then '' else   'BSE' end + ',' + case when DPTDC_CREATED_BY=dpam_sba_no then 'POT' else DPTDC_CREATED_BY end + ',' + DPTDC_LST_UPD_BY + ',' + ISNULL(DPTDC_MID_CHK,'') + ','+','+ ',' +case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then 'CHQ' when isnull(DPTDC_PAYMODE,'')='CASH PAYMENT' then 'CAP'  when isnull(DPTDC_PAYMODE,'')='ELECTRONIC PAYMENT' then 'ELP' else '' end+','+isnull(DPTDC_CHQ_REFNO,'')+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end+','+isnull(DPTDC_BANKACNO,'')+','+isnull(DPTDC_BANKACNAME,'')+','+ case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then ISNULL(DPTDC_BANKBRNAME,'') else  '' end  +','+','+','+','+','+','+ 'YES' + ','+','+','+','+case when DPTDC_LINE_NO='' then '0' else convert(varchar,isnull(DPTDC_LINE_NO,'0')) end+','+','+','+','+','+','+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end +','+','+','+','+','+'BO'+','+' ,'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+convert(varchar,ID)+','+','+','+',' + ',' + ','+ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)'))))+','+isnull(DPTDC_TRANSFEREENAME,'')+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+'HP'+','+','+ ',' +'' + ','+','+','+','+'DP'+','+','+','+','+','+convert(varchar,isnull(xmlField.value('(Clnt)[1]', 'nvarchar(max)'),''))+','+','+','+','+','+ ISNULL((SELECT TOP 1 REPLACE(Standard_Value,'31','') FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%REASON/ pURPOSE%' and left(DPTDC_REASON_CD,2)='31' and CDSL_Old_Value=ISNULL(replace(convert(varchar,DPTDC_REASON_CD),'31',''),'0')),'') +','+','+','+','+','+','+','
	as Detailshar ,ID

	FROM tmp,DP_ACCT_MSTR
	left outer join DP_POA_DTLS on DPPD_DPAM_ID=dpam_id and DPPD_DELETED_IND=1 and getdate() between dppd_eff_fr_dt and isnull(dppd_eff_TO_dt,'2099-12-31 00:00:00.000')
	,DP_MSTR,DPTDC_MAK where DPAM_DELETED_IND=1 
	and DPAM_SBA_NO=convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) 
	AND DPAM_DPM_ID=DPM_ID AND default_dp=dpm_excsm_id
	--and DPTDC_slip_no=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
	and Intdptdc_id=dptdc_id
	and DPTDC_DELETED_IND=1
	AND DPTDC_INTERNAL_TRASTM IN ('ID') and isnull(DPTDC_COUNTER_CMBP_ID,'')<>'' and  isnull(DPTDC_COUNTER_DP_ID,'')='' and isnull(dptdc_counter_demat_acct_no,'')='' and isnull(DPTDC_OTHER_SETTLEMENT_TYPE,'')<>''
	--UNION ALL -- CMBO
	--select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + substring(DPM_DPID,3,5) + ',' + ',' + isnull((SELECT ltrim(rtrim(Standard_Value)) FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='Transaction Type Upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)'))),'')	  + ',' + isnull(convert(varchar,ID),'') + ',' + ltrim(rtrim(xmlField.value('(Usn)[1]', 'nvarchar(max)'))) + ',' + '033200' + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) + ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)')),'') + ',' + isnull(convert(varchar,QTY),'') + ' ,S,' + isnull(case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then ''  else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then left(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) else  convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')) end end ,'')+ ',' + isnull(case when isnull(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),'')='' then '' else case when len(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')))=16 then  right(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),16) else convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')) end end,'')+ ',' + isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') + ','+','+',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'')+isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + '' + ',' + '' + ',' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),5,4) + '-' +  substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),3,2)+ '-' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),1,2) + ',' + ISNULL((SELECT TOP 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%Trade Reason Code%' and CDSL_Old_Value=ISNULL(convert(varchar,left(DPTDC_REASON_CD,2)),'0')),'') + ',,,' + case when convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))='N' then 'PHY' else 'ESP' end + ',' + ltrim(rtrim(convert(varchar,xmlField.value('(Dis)[1]', 'nvarchar(max)')))) + ',' + case when (SELECT Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')))='4' then '' else convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')) end + ','+','+','+','+','+','+','+','+',' + DPTDC_CREATED_BY + ',' + DPTDC_LST_UPD_BY + ',' + ISNULL(DPTDC_MID_CHK,'') + ','+','+ ',' +case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then 'CHQ' when isnull(DPTDC_PAYMODE,'')='CASH PAYMENT' then 'CAP'  when isnull(DPTDC_PAYMODE,'')='ELECTRONIC PAYMENT' then 'ELP' else '' end+','+isnull(DPTDC_CHQ_REFNO,'')+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end+','+isnull(DPTDC_BANKACNO,'')+','+isnull(DPTDC_BANKACNAME,'')+','+','+','+','+','+','+','+','+','+','+','+case when DPTDC_LINE_NO='' then '0' else convert(varchar,isnull(DPTDC_LINE_NO,'0')) end+','+','+','+','+','+','+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end +','+','+','+','+','+'BO'+','+' ,'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+convert(varchar,ID)+','+','+','+',' + ',' + ','+ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)'))))+','+isnull(DPTDC_TRANSFEREENAME,'')+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+'HP'+','+','+ ',' +'' + ','+','+','+','+'DP'+','+','+','+','+','+convert(varchar,isnull(xmlField.value('(Clnt)[1]', 'nvarchar(max)'),''))+','+','+','+','+','+ ISNULL((SELECT TOP 1 REPLACE(Standard_Value,'31','') FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%REASON/ pURPOSE%' and left(DPTDC_REASON_CD,2)='31' and CDSL_Old_Value=ISNULL(replace(convert(varchar,DPTDC_REASON_CD),'31',''),'0')),'') +','+','+','+','+','+','+','
	--as Detailshar ,ID

	--FROM tmp,DP_ACCT_MSTR
	--left outer join DP_POA_DTLS on DPPD_DPAM_ID=dpam_id and DPPD_DELETED_IND=1 and getdate() between dppd_eff_fr_dt and isnull(dppd_eff_TO_dt,'2099-12-31 00:00:00.000')
	--,DP_MSTR,DPTDC_MAK where DPAM_DELETED_IND=1 
	--and DPAM_SBA_NO=convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) AND DPAM_DPM_ID=DPM_ID AND default_dp=dpm_excsm_id
	--and DPTDC_slip_no=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
	--and DPTDC_DELETED_IND=1
	--AND DPTDC_INTERNAL_TRASTM IN ('CMBO')
	UNION ALL -- EP
	select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + substring(DPM_DPID,3,5) + ',' + ',' + isnull((SELECT top 1 ltrim(rtrim(Standard_Value)) FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='Transaction Type Upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)'))),'')	  + ',' + isnull(convert(varchar,ID),'') + ',' + ltrim(rtrim(xmlField.value('(Usn)[1]', 'nvarchar(max)'))) + ',' + '033200' + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) + ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)')),'') + ',' + isnull(convert(varchar,QTY),'') + ' ,S,' + isnull(case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then ''  else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then left(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) else  convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')) end end ,'')+ ',' + isnull(case when isnull(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),'')='' then '' else case when len(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')))=16 then  right(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),16) else convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')) end end,'')+ ',' + isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') + ',' + 'NSE' +',' + isnull(Dptdc_tmcmid,'') +',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'')+isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),5,4) + '-' +  substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),3,2)+ '-' + substring(xmlField.value('(Dt)[1]', 'nvarchar(max)'),1,2) + ',' + ISNULL((SELECT TOP 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%Trade Reason Code%' and CDSL_Old_Value=ISNULL(convert(varchar,left(DPTDC_REASON_CD,2)),'0')),'') + ',,,' + case when convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))='N' then 'PHY' else 'ESP' end + ',' + ltrim(rtrim(convert(varchar,xmlField.value('(Dis)[1]', 'nvarchar(max)')))) + ',' + case when (SELECT top 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')))='4' then '' else convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')) end + ',' + 'NCT' + ','+isnull(dptdc_ucc,'') + ',' + isnull(dptdc_cmid,'') +',' + isnull(dptdc_tmcmid,'')+','+','+ 'CM' + ',' + 'NCL' + ',' + 'NSE'+',' + DPTDC_CREATED_BY + ',' + DPTDC_LST_UPD_BY + ',' + ISNULL(DPTDC_MID_CHK,'') + ','+','+ ',' +case when isnull(DPTDC_PAYMODE,'')='CHEQUE PAYMENT' then 'CHQ' when isnull(DPTDC_PAYMODE,'')='CASH PAYMENT' then 'CAP'  when isnull(DPTDC_PAYMODE,'')='ELECTRONIC PAYMENT' then 'ELP' else '' end+','+isnull(DPTDC_CHQ_REFNO,'')+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end+','+isnull(DPTDC_BANKACNO,'')+','+isnull(DPTDC_BANKACNAME,'')+','+','+ 'YES' +','+','+','+','+','+','+','+','+','+case when DPTDC_LINE_NO='' then '0' else convert(varchar,isnull(DPTDC_LINE_NO,'0')) end+','+','+','+','+','+','+','+ case when CONVERT(VARCHAR(10),DPTDC_DOI,120)='1900-01-01' then '' else isnull(CONVERT(VARCHAR(10),DPTDC_DOI,120),'') end +','+','+','+','+','+'BO'+','+' ,'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+convert(varchar,ID)+','+','+','+',' + ',' + ','+ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)'))))+','+isnull(DPTDC_TRANSFEREENAME,'')+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+'HP'+','+','+ ',' +'' + ','+','+','+','+'DP'+','+','+','+','+','+convert(varchar,isnull(xmlField.value('(Clnt)[1]', 'nvarchar(max)'),''))+','+','+','+','+','+ ISNULL((SELECT TOP 1 REPLACE(Standard_Value,'31','') FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%REASON/ pURPOSE%' and left(DPTDC_REASON_CD,2)='31' and CDSL_Old_Value=ISNULL(replace(convert(varchar,DPTDC_REASON_CD),'31',''),'0')),'') +','+','+','+','+','+','+','
	as Detailshar ,ID

	FROM tmp,DP_ACCT_MSTR
	left outer join DP_POA_DTLS on DPPD_DPAM_ID=dpam_id and DPPD_DELETED_IND=1 and getdate() between dppd_eff_fr_dt and isnull(dppd_eff_TO_dt,'2099-12-31 00:00:00.000')
	,DP_MSTR,DPTDC_MAK where DPAM_DELETED_IND=1 
	and DPAM_SBA_NO=convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) AND DPAM_DPM_ID=DPM_ID AND default_dp=dpm_excsm_id
	--and DPTDC_slip_no=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
	and Intdptdc_id=dptdc_id
	and DPTDC_DELETED_IND=1
	AND DPTDC_INTERNAL_TRASTM IN ('EP')
	union all
	select distinct '' 
	+ Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + substring(DPM_DPID,3,5) + ',' + ',' + isnull((SELECT TOP 1 ltrim(rtrim(Standard_Value)) FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='Transaction Type Upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)'))),'')	  + ',' + isnull(convert(varchar,ID),'') + ',' + ltrim(rtrim(xmlField.value('(Usn)[1]', 'nvarchar(max)'))) + ',' + '033200' + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) + ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)')),'') + ',' + isnull(convert(varchar,QTY),'') + ' ,S,' + isnull(case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then ''  else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then left(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) else  convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')) end end ,'')+ ',' + isnull(case when isnull(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),'')='' then '' else case when len(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')))=16 then  right(convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')),16) else convert(varchar,xmlField.value('(CtrPty)[1]', 'nvarchar(max)')) end end,'')+ ',' + isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') + ','+','+',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + isnull(left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6),'') + ',' + isnull(right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7),'') + ',' + substring(xmlField.value('(Rcvdt)[1]', 'nvarchar(max)'),5,4) + '-' +  substring(xmlField.value('(Rcvdt)[1]', 'nvarchar(max)'),3,2)+ '-' + substring(xmlField.value('(Rcvdt)[1]', 'nvarchar(max)'),1,2) + ',' + '' +  + ','+ ISNULL((SELECT TOP 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION like '%pLEDGE Reason Code%' and meaning=ISNULL(convert(varchar(1000),PLDTC_REASON_CODE),'0')),'') + ',,' + case when convert(varchar,xmlField.value('(Txnelflg)[1]', 'nvarchar(max)'))='N' then 'PHY' else 'ESP' end + ',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Prf)[1]', 'nvarchar(max)')))),'')  + ',' + case when (SELECT TOP 1 Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')))='4' then '' else convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')) end + ','+','+','+','+','+','+','+','+',' + PLDTC_CREATED_BY  + ',' + PLDTC_UPDATED_BY + ',' + '' + ','+ CONVERT(VARCHAR(23),convert(datetime,substring(xmlField.value('(Rcvdt)[1]', 'nvarchar(max)'),1,2) + '-' +  substring(xmlField.value('(Rcvdt)[1]', 'nvarchar(max)'),3,2)+ '-' + substring(xmlField.value('(Rcvdt)[1]', 'nvarchar(max)'),5,4),105),126) + ','+ ',' + +','+ +','+ +','+''+','+ +','+   +','+','+ isnull(PLDTC_AGREEMENT_NO,'') + ','+','+','+','+  + ','+','+ isnull(convert(varchar(10),pldtc_expiry_dt,120),'') + ','+','+ +','+','+','+','+','+','+','+ '' +','+','+','+','+','+'BO'+','+' ,'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+convert(varchar,ID)+','+','+','+',' + ',' + ','+ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)'))))+','+ +','+ 'STP' +','+ 'FRE' +','+ '' +','+ isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Prf)[1]', 'nvarchar(max)')))),'') +  ',' + convert(varchar,isnull(convert(numeric(18,2),QTY*CLOPM_CDSL_RT),'0')) +','+ ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))) + ','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+'HP'+','+','+ ',' +'' + ','+','+','+','+'DP'+','+','+','+','+','+convert(varchar,isnull(xmlField.value('(Clnt)[1]', 'nvarchar(max)'),''))+','+','+','+','+','+ '' +','+','+','+','+','+','+','
	as Detailshar ,ID

	FROM tmp,DP_ACCT_MSTR
	--left outer join DP_POA_DTLS on DPPD_DPAM_ID=dpam_id and DPPD_DELETED_IND=1 and getdate() between dppd_eff_fr_dt and isnull(dppd_eff_TO_dt,'2099-12-31 00:00:00.000')
	,DP_MSTR,cdsl_pledge_dtls 
			 LEFT OUTER JOIN ISIN_MSTR with (nolock) ON PLDTC_ISIN = ISIN_CD              
			 LEFT OUTER JOIN CLOSING_PRICE_MSTR_cDSL with (nolock) ON PLDTC_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = PLDTC_ISIN and CLOPM_DT <= PLDTC_EXEC_DT and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)                      

	where DPAM_DELETED_IND=1 
	and DPAM_SBA_NO=convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) 
	AND DPAM_DPM_ID=DPM_ID AND default_dp=dpm_excsm_id
	--and PLDTC_SLIP_NO=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
	and Intdptdc_id=pldtc_id
	and pldtc_DELETED_IND=1
	AND pldtc_trastm_cd IN ('CRTE')
	)
	T
	order by T.ID

	end
	drop table tmp
	--union all -- demrm main

	--select distinct
	--'' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + '0' + ',' + ',' + 'DMT'	  + ' ,' + convert(varchar,ID) + ',' + isnull(convert(varchar,ltrim(rtrim(xmlField.value('(Ref)[1]', 'nvarchar(max)')))),'') + ',' + isnull(substring(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')) ,4,5),'') + ',' + convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)'))  + ',' + convert(varchar,xmlField.value('(ISIN)[1]', 'nvarchar(max)'))  + ',' + convert(varchar,xmlField.value('(Qty)[1]', 'nvarchar(max)')) + ' ,S,' + case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then ''  else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then isnull(left(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8),'') else  isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') end end + ',' + case when isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'')='' then '' else case when len(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')))=16 then  right(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),8) else isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') end end+ ',' + isnull(convert(varchar,xmlField.value('(Clnt)[1]', 'nvarchar(max)')),'') + ','+','+',' + left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6) + ',' + right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7) + ',' + left(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),6) + ',' + right(convert(varchar,isnull(xmlField.value('(Sttlm)[1]', 'nvarchar(max)'),'')),7) + ',' + isnull(convert(varchar,xmlField.value('(Dt)[1]', 'nvarchar(max)')),'') + ',' +  + ',,,' + case when 'DISFLAGIND'='Y' then '' else '' end + ',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Dis)[1]', 'nvarchar(max)')))),'') + ',' + case when (SELECT Standard_Value FROM HARM_SOURCE_CDSL WHERE FIELD_DESCRIPTION='TRANSACTION TYPE upload' AND ISNULL(CDSL_OLD_VALUE,'')<>'' and CDSL_OLD_VALUE=convert(varchar,xmlField.value('(Tp)[1]', 'nvarchar(max)')))='4' then '' else isnull(convert(varchar,isnull(xmlField.value('(Poa)[1]', 'nvarchar(max)'),'')),'') end + ','+','+','+','+','+','+','+','+',' + '' + ',' + '' + ',' + '' + ','+ CONVERT(VARCHAR(23),convert(datetime,SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 1, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 5, 4),105),126) + ','+ ',' + +','+ +','+ +','+ +','+ +','+','+','+',' + ','+  isnull(convert(varchar,xmlField.value('(Drf)[1]', 'nvarchar(max)')),'') +','+','+','+','+','+','+ +','+','+','+','+','+','+','+','+','+','+','+','+''+','+' ,'+','+','+  + ','+ isnull(convert(varchar,ID),'')  +','+ isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Ranges)[1]', 'nvarchar(max)')))),'') + ','+','+','+','+','+','+','+  + ','+ SUBSTRING(isnull(convert(varchar,xmlField.value('(Dspchdt)[1]', 'nvarchar(max)')),''), 5, 4) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Dspchdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Dspchdt)[1]', 'nvarchar(max)')),''), 1, 2) + ','+',' +','+  ','+ 'AC' +','+ +','+ ','+','+',' + ',' + ','+','+ ','+ ','+'FRE' +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','++','+','+ ',' +'' + ','+','+','+','++','+','+','+','+','+ ','+','+','+','+','+','+','+','+','+','+','+','
	--as Detailshar
	--FROM tmp 
	--,demrm_mak where 
	--DEMRM_SLIP_SERIAL_NO=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
	--and DEMRM_DELETED_IND=1 and LEN(xmlField)>170 --and ID=1
	--union all -- demrm ranges
	--select distinct
	--'' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + '0' + ',' + ',' + 'DMT'	  + ' ,' + convert(varchar,ID) + ',' + isnull(convert(varchar,ltrim(rtrim(xmlField.value('(Ref)[1]', 'nvarchar(max)')))),'') + ',' + substring(@L_DPM_DPID,4,5) + ',' + ''  + ',' + '' + ',' + '' + ' ,,' + '' + ',' + '' + ',' + '' + ','+','+',' +  + ',' + '' + ',' + '' + ',' + '' + ',' + '' + ',' +  + ',,,' + '' + ',' + '' + ',' + '' + ','+','+','+','+','+','+','+','+',' + '' + ',' + '' + ',' + '' + ','+ '' + ','+ ',' + +','+ +','+ +','+ +','+ +','+','+','+',' + ','+  '' +','+','+','+','+','+','+ +','+','+','+','+','+','+','+','+','+','+','+','+''+','+' ,'+','+','+  + ','+ ''  +','+ '' + ',DN'+',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Rngs)[1]', 'nvarchar(max)')))),'') +',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(Folio)[1]', 'nvarchar(max)')))),'') +',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(CertFrm)[1]', 'nvarchar(max)')))),'') +',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(CertTo)[1]', 'nvarchar(max)')))),'') +',' + isnull(ltrim(rtrim(convert(varchar,xmlField.value('(DNFrm)[1]', 'nvarchar(max)')))),'') +','+ isnull(ltrim(rtrim(convert(varchar,xmlField.value('(DNTo)[1]', 'nvarchar(max)')))),'')  + ','+ '' + ','+',' +','+  ','+ '' +','+ +','+ ','+','+',' + ',' + ','+','+ ','+ ','+'' +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','++','+','+ ',' +'' + ','+','+','+','++','+','+','+','+','+ ','+','+','+','+','+','+','+','+','+','+','+','
	--as Detailshar
	--FROM tmp
	--,demrm_mak where 
	--DEMRM_SLIP_SERIAL_NO=convert(varchar,slip_no)--citrus_usr.FN_SPLITVAL_BY(ltrim(rtrim(convert(varchar,xmlField.value('(Ref)[1]', 'nvarchar(max)')))),2,'/')
	--and DEMRM_DELETED_IND=1 and LEN(xmlField)<=169--and ID<>1




if isnull(@PA_BATCH_NO,'') = '' 
begin
	select @PA_BATCH_NO = max(CONVERT(BIGINT,BITRM_VALUES)) from BITMAP_REF_MSTR 
	WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + 'ALL' + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID 
    AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
end

UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + 'ALL' + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID 
AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  


--UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + 'ALL' + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  

/* insert into batch table*/  

--select  @L_TOT_REC = count(*) from #tempdata ---where dptdc_created_by not in (select dpam_sba_no from DP_ACCT_MSTR where DPAM_DELETED_IND=1)

DECLARE @L_COUNT_DMAT NUMERIC
SET @L_COUNT_DMAT = 0 
SELECT @L_COUNT_DMAT  = COUNT(1) FROM #tempdataMainINCR

select  @L_TOT_REC = count(*) from #tempdata WHERE cd not in ('DMAT') ---where dptdc_created_by not in (select dpam_sba_no from DP_ACCT_MSTR where DPAM_DELETED_IND=1)
SELECT @L_TOT_REC = @L_TOT_REC + ISNULL(@L_COUNT_DMAT,'0')

if count(@L_TOT_REC)>0
begin  -- cnt

--	if exists (select cd from #tempdata where cd='DMAT')
--	begin
--
--
--	end
--
--	if exists (select cd from #tempdata where cd='DESTAT')
--	begin
--
--	end
--
--	if exists (select cd from #tempdata where cd='PLEDGE')
--	begin
--
--	end
--
--	if exists (select cd from #tempdata where cd in  ('OFFM','ID','NP','EP',))
--	begin
--
--        UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
--		WHERE  dptdc_dpam_id = dpam_id   
--		AND    dpam_dpm_id   = @l_dpm_id    
--		AND    isnull(dptdc_status,'P')='P'  
--		AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
--		AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
--		AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
--		AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
--
--	end


	IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE='ALL')  
	BEGIN  
	INSERT INTO BATCHNO_CDSL_MSTR                                       
	(    
	BATCHC_DPM_ID,  
	BATCHC_NO,  
	BATCHC_RECORDS ,  
	BATCHC_TRANS_TYPE,
	BATCHC_FILEGEN_DT,
	BATCHC_TYPE,  
	BATCHC_STATUS,  
	BATCHC_CREATED_BY,  
	BATCHC_CREATED_DT ,  
	BATCHC_LST_UPD_BY,
    BATCHC_LST_UPD_DT,
	BATCHC_DELETED_IND  
	)  
	VALUES  
	(  
	@L_DPM_ID,  
	@PA_BATCH_NO,  
	@L_TOT_REC,  
	'ALL',
	getdate(),--CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
	'T',  
	'P',  
	@PA_LOGINNAME,  
	GETDATE(), 
	@PA_LOGINNAME,  
	GETDATE(),	 
	1  
	)      
																															    
	END   
--

END -- cnt
drop table ##tempdataGrpINCR
DROP TABLE PENINGEXPORT
--  
END

GO
