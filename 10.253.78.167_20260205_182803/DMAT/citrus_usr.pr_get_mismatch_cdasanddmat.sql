-- Object: PROCEDURE citrus_usr.pr_get_mismatch_cdasanddmat
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create proc [citrus_usr].[pr_get_mismatch_cdasanddmat](@pa_criteria varchar(500))
as
begin 

if @pa_criteria = 'STATUS'
BEGIN 

select boid , case when BOAcctStatus = '1' then 'ACTIVE'
when BOAcctStatus = '2' then '02'
when BOAcctStatus = '3' then '03'
when BOAcctStatus = '4' then '04'
when BOAcctStatus = '6' then '06'
end cdasstatus    ,  dpam_stam_cd dmatststua
from dps8_pc1 with(nolock), dp_acct_mstr  with(nolock)
where boid = dpam_sba_no and case when len(dpam_stam_cd)=1 then '0'+dpam_stam_cd else dpam_stam_cd end <> case when BOAcctStatus = '1' then 'ACTIVE'
when BOAcctStatus = '2' then '02'
when BOAcctStatus = '3' then '05'
when BOAcctStatus = '4' then '04'
when BOAcctStatus = '6' then '06'
end

END 
if @pa_criteria = 'CATEGORY'
BEGIN 

--category -- 5
select boid
 , CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END 
 cdascategory    ,  dpam_clicm_cd dmatcategory
from dps8_pc1 with(nolock), dp_acct_mstr  with(nolock)
where boid = dpam_sba_no and case when dpam_clicm_cd ='30_CDSL' then '30' end <>  CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END
--30 to 30_cdsl

END 

if @pa_criteria = 'SUBCATEGORY'
BEGIN 
--SUBCATEGORY -- 2887
select boid
 , CASE WHEN LEN(ProdCode)=1 THEN '0'+ CONVERT(VARCHAR(10),ProdCode)  
ELSE CONVERT(VARCHAR(10),ProdCode)   
END + CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) 
ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END  
+ CASE WHEN LEN(BOSUBSTATUS)=1 THEN '0'+CONVERT(VARCHAR(10),BOSUBSTATUS)    
ELSE CONVERT(VARCHAR(10),BOSUBSTATUS) END cdassubcategory
,  dpam_subcm_cd dmatsubcategory
from dps8_pc1 with(nolock), dp_acct_mstr  with(nolock)
where boid = dpam_sba_no and dpam_subcm_cd <>  CASE WHEN LEN(ProdCode)=1 THEN '0'+ CONVERT(VARCHAR(10),ProdCode)  
ELSE CONVERT(VARCHAR(10),ProdCode)   
END + CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) 
ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END  
+ CASE WHEN LEN(BOSUBSTATUS)=1 THEN '0'+CONVERT(VARCHAR(10),BOSUBSTATUS)    
ELSE CONVERT(VARCHAR(10),BOSUBSTATUS) END
--first check all sub ctgry available in our system
END 

if @pa_criteria = 'CLIENTTYPE'
BEGIN 
--type -- all match 
select boid
 , CASE WHEN LEN(BOCATEGORY)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCATEGORY)+'_CDSL'  ELSE CONVERT(VARCHAR(10),BOCATEGORY)+'_CDSL'   END 
 cdastype
,  dpam_enttm_cd dmattype
from dps8_pc1 with(nolock), dp_acct_mstr  with(nolock)
where boid = dpam_sba_no and 
dpam_enttm_cd <> 
CASE WHEN LEN(BOCATEGORY)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCATEGORY)+'_CDSL'  ELSE CONVERT(VARCHAR(10),BOCATEGORY)+'_CDSL'   END 

END 

if @pa_criteria = 'DOB'
BEGIN 

select boid
 , DATEOFBIRTH  cdasdob 
,  replace(convert(varchar(11),CLIM_DOB ,103),'/','') dmattype
from dps8_pc1 with(nolock), dp_acct_mstr  with(nolock)
, client_mstr  with(nolock)
where boid = dpam_sba_no and clim_crn_no = dpam_crn_no and 
replace(convert(varchar(11),CLIM_DOB ,103),'/','') <> DATEOFBIRTH
and DATEOFBIRTH <> ''
and right(DATEOFBIRTH,4) >= 1900
and dpam_crn_no not in (select dpam_crn_no from dp_acct_mstr group by dpam_crn_no having count(1)>1)
--most of  cdas dob comeing wrong 

END 

if @pa_criteria = 'PAN'
BEGIN 

select boid
 , PANGIR  cdaspan
,   entp_value dmatpan
from dps8_pc1 with(nolock), dp_acct_mstr  with(nolock)
, entity_properties  with(nolock)
where boid = dpam_sba_no and entp_ent_id  = dpam_crn_no and entp_value <> PANGIR
and entp_entpm_cd ='pan_gir_no'

END 

if @pa_criteria = 'ACTIVATIONDT'
BEGIN 

select boid
 , AcctCreatDt  cdasactdt
,   replace(accp_value,'/','')  dmatactdt
from dps8_pc1 with(nolock), dp_acct_mstr  with(nolock)
, account_properties  with(nolock)
where boid = dpam_sba_no and accp_clisba_id  = dpam_id and replace(accp_value,'/','') <> AcctCreatDt
and accp_accpm_prop_cd  ='bill_start_dt'

END

if @pa_criteria = 'CLOSDT'
BEGIN 

select boid
, ClosDt  cdasclosdt
, CASE WHEN CASE WHEN CITRUS_USR.UFN_COUNTSTRING(accp_value,'/') > 1 
THEN REPLACE(ACCP_VALUE,'/','')
ELSE REPLACE(CONVERT(VARCHAR(11),convert(datetime,accp_value),103) ,'/','') END = '01011900' THEN '' ELSE  CASE WHEN CITRUS_USR.UFN_COUNTSTRING(accp_value,'/') > 1 
THEN REPLACE(ACCP_VALUE,'/','')
ELSE REPLACE(CONVERT(VARCHAR(11),convert(datetime,accp_value),103) ,'/','') END END 
 dmatclosdt
from dps8_pc1 with(nolock), dp_acct_mstr  with(nolock)
, account_properties  with(nolock)
where boid = dpam_sba_no and accp_clisba_id  = dpam_id 
and (CASE WHEN CASE WHEN CITRUS_USR.UFN_COUNTSTRING(accp_value,'/') > 1 
THEN REPLACE(ACCP_VALUE,'/','')
ELSE REPLACE(CONVERT(VARCHAR(11),convert(datetime,accp_value),103) ,'/','') END = '01011900' THEN '' ELSE  CASE WHEN CITRUS_USR.UFN_COUNTSTRING(accp_value,'/') > 1 
THEN REPLACE(ACCP_VALUE,'/','')
ELSE REPLACE(CONVERT(VARCHAR(11),convert(datetime,accp_value),103) ,'/','') END
END <> ClosDt)
and accp_accpm_prop_cd  ='acc_close_dt'  
and boacctstatus = '3'

END 




--most of  cdas dob comeing wrong 



if @pa_criteria = 'NAME'
BEGIN 

select  boid,CLIM_NAME1 , CLIM_NAME2, CLIM_NAME3, Name
,MiddleName
,SearchName 
from dps8_pc1 , dp_acct_mstr 
,client_mstr
where dpam_crn_no = clim_crn_no 
and boid = dpam_sba_no
and (CLIM_NAME1 <> Name OR CLIM_NAME2 <> MIDDLENAME OR CLIM_NAME3 <> SEARCHNAME)
AND (REPLACE(NAME  + MIDDLENAME  + SEARCHNAME,' ','') <> REPLACE(CLIM_NAME1 + CLIM_NAME2 + CLIM_NAME3 ,' ' ,''))
and dpam_crn_no  not in (select dpam_crn_no from dp_acct_mstr group by dpam_crn_no having count(1)>1)

select   dpam_sba_name , ltrim(rtrim(Name)) + ' ' + ltrim(rtrim(MiddleName)) + ' ' + ltrim(rtrim(SearchName)) 
from  dp_acct_mstr a
,dps8_pc1 where dpam_sba_no = boid 
and ltrim(rtrim(replace(dpam_sba_name,' ',''))) <> ltrim(rtrim(replace(ltrim(rtrim(Name)) + ' ' + ltrim(rtrim(MiddleName)) + ' ' + ltrim(rtrim(SearchName)) ,' ','')))



--and boid ='1201090002948563'

END 


if @pa_criteria = 'FTHNAME'
BEGIN 

select  boid
,FthName,DPHD_FH_FTHNAME
from dps8_pc1 , dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO
and ( replace(DPHD_FH_FTHNAME ,' ','')<> replace(FthName,' ','')
)

END 

if @pa_criteria = 'SHNAME'
BEGIN 

select  boid, replace(Name + MiddleName + SearchName,' ','') CDAS , replace(DPHD_SH_FNAME + DPHD_SH_MNAME +  DPHD_SH_LNAME ,' ','') DMAT
--,FthName,DPHD_SH_FTHNAME
--,DateofBirth,DPHD_SH_DOB
--,PANGIR,DPHD_SH_PAN_NO
from dps8_pc2 , dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO
and ( replace(DPHD_SH_FNAME + DPHD_SH_MNAME +  DPHD_SH_LNAME ,' ','')<> replace(Name + MiddleName + SearchName,' ','')
--or DPHD_SH_FTHNAME <> FthName
--or DPHD_SH_DOB<> DateofBirth
--or DPHD_SH_PAN_NO<> PANGIR
)
END 

if @pa_criteria = 'SHFTHNAME'
BEGIN 

select  boid
,FthName CDAS ,DPHD_SH_FTHNAME DMAT
from dps8_pc2 , dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO
and ( DPHD_SH_FTHNAME <> FthName
)

END 

if @pa_criteria = 'SHDOB'
BEGIN 

select  boid
,DateofBirth,DPHD_SH_DOB
--,PANGIR,DPHD_SH_PAN_NO
from dps8_pc2 , dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO
and ( 
 DPHD_SH_DOB<> DateofBirth
)

END 

if @pa_criteria = 'SHPAN'
BEGIN 

select  boid ,PANGIR,DPHD_SH_PAN_NO
from dps8_pc2 , dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO
and ( DPHD_SH_PAN_NO<> PANGIR)

END 

if @pa_criteria = 'THNAME'
BEGIN
select  boid, replace(Name + MiddleName + SearchName,' ',''), replace(DPHD_tH_FNAME + DPHD_tH_MNAME +  DPHD_tH_LNAME ,' ','')
--,FthName,DPHD_SH_FTHNAME
--,DateofBirth,DPHD_SH_DOB
--,PANGIR,DPHD_SH_PAN_NO
from dps8_pc3 , dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO
and ( replace(DPHD_tH_FNAME + DPHD_tH_MNAME +  DPHD_tH_LNAME ,' ','')<> replace(Name + MiddleName + SearchName,' ','')
--or DPHD_SH_FTHNAME <> FthName
--or DPHD_SH_DOB<> DateofBirth
--or DPHD_SH_PAN_NO<> PANGIR
)
END 

if @pa_criteria = 'THFTHNAME'
BEGIN

select  boid
,FthName,DPHD_tH_FTHNAME
from dps8_pc3 , dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO
and ( DPHD_tH_FTHNAME <> FthName
)
END 

if @pa_criteria = 'THDOB'
BEGIN

select  boid
,DateofBirth,DPHD_tH_DOB
--,PANGIR,DPHD_SH_PAN_NO
from dps8_pc3 , dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO
and ( 
 DPHD_tH_DOB<> DateofBirth
)

END 

if @pa_criteria = 'THPAN'
BEGIN

select  boid ,PANGIR,DPHD_tH_PAN_NO
from dps8_pc3 , dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO
and ( DPHD_tH_PAN_NO<> PANGIR
)
END 

if @pa_criteria = 'NOMNAME'
BEGIN
--select * from dps8_pc6 where boid = '1201090000000251'
select  boid, replace(Name + MiddleName + SearchName,' ','') CDAS , replace(DPHD_nom_FNAME + DPHD_nom_MNAME +  DPHD_nom_LNAME ,' ','') DMAT
--,FthName,DPHD_SH_FTHNAME
--,DateofBirth,DPHD_SH_DOB
--,PANGIR,DPHD_SH_PAN_NO
from (select max(convert(datetime,left(DateOfSetup,2)+'/'+substring(DateOfSetup,3,2)+'/'+ right(DateOfSetup,4),103)) sdt,boid inboid from  dps8_pc6 group by boid) a
, dps8_pc6 
, dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO and boid = inboid and sdt = convert(datetime,left(DateOfSetup,2)+'/'+substring(DateOfSetup,3,2)+'/'+ right(DateOfSetup,4),103)
and ( replace(DPHD_nom_FNAME + DPHD_nom_MNAME +  DPHD_nom_LNAME ,' ','')<> replace(Name + MiddleName + SearchName,' ','')
--or DPHD_SH_FTHNAME <> FthName
--or DPHD_SH_DOB<> DateofBirth
--or DPHD_SH_PAN_NO<> PANGIR
)

END 

if @pa_criteria = 'NOMFTHNAME'
BEGIN


select  boid
,FthName,DPHD_nom_FTHNAME
from (select max(convert(datetime,left(DateOfSetup,2)+'/'+substring(DateOfSetup,3,2)+'/'+ right(DateOfSetup,4),103)) sdt,boid inboid from  dps8_pc6 group by boid) a
, dps8_pc6 
, dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO and boid = inboid and sdt = convert(datetime,left(DateOfSetup,2)+'/'+substring(DateOfSetup,3,2)+'/'+ right(DateOfSetup,4),103)
and ( DPHD_nom_FTHNAME <> FthName)

END 

if @pa_criteria = 'NOMDOB'
BEGIN

select  boid
,DateofBirth,DPHD_nom_DOB
,replace(convert(varchar(11),DPHD_nom_DOB,103),'/','')
from (select max(convert(datetime,left(DateOfSetup,2)+'/'+substring(DateOfSetup,3,2)+'/'+ right(DateOfSetup,4),103)) sdt,boid inboid from  dps8_pc6 group by boid) a
, dps8_pc6 
, dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO and boid = inboid and sdt = convert(datetime,left(DateOfSetup,2)+'/'+substring(DateOfSetup,3,2)+'/'+ right(DateOfSetup,4),103)
and (  case when replace(convert(varchar(11),DPHD_nom_DOB,103),'/','')='01011900' then '' else replace(convert(varchar(11),DPHD_nom_DOB,103),'\','') end  <> DateofBirth)

END 

if @pa_criteria = 'NOMPAN'
BEGIN

select  boid ,PANGIR,DPHD_nom_PAN_NO
from (select max(convert(datetime,left(DateOfSetup,2)+'/'+substring(DateOfSetup,3,2)+'/'+ right(DateOfSetup,4),103)) sdt,boid inboid from  dps8_pc6 group by boid) a
, dps8_pc6 
, dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO and boid = inboid and sdt = convert(datetime,left(DateOfSetup,2)+'/'+substring(DateOfSetup,3,2)+'/'+ right(DateOfSetup,4),103)
and ( DPHD_nom_PAN_NO<> PANGIR)

END 

if @pa_criteria = 'GAUNAME'
BEGIN

select  boid, replace(Name + MiddleName + SearchName,' ',''), replace(DPHD_gau_FNAME + DPHD_gau_MNAME +  DPHD_gau_LNAME ,' ','')
--,FthName,DPHD_SH_FTHNAME
--,DateofBirth,DPHD_SH_DOB
--,PANGIR,DPHD_SH_PAN_NO
from (select max(DateOfSetup) sdt,boid inboid from  dps8_pc7 group by boid) a
, dps8_pc7 
, dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO and boid = inboid and sdt = DateOfSetup
and ( replace(DPHD_gau_FNAME + DPHD_gau_MNAME +  DPHD_gau_LNAME ,' ','')<> replace(Name + MiddleName + SearchName,' ',''))
--or DPHD_SH_FTHNAME <> FthName
--or DPHD_SH_DOB<> DateofBirth
--or DPHD_SH_PAN_NO<> PANGIR

END 

if @pa_criteria = 'GAUFTHNAME'
BEGIN

select  boid
,FthName,DPHD_gau_FTHNAME
from (select max(DateOfSetup) sdt,boid inboid from  dps8_pc7 group by boid) a
, dps8_pc7 
, dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO and boid = inboid and sdt = DateOfSetup
and ( DPHD_gau_FTHNAME <> FthName)

END 

if @pa_criteria = 'GAUDOB'
BEGIN


select  boid
,DateofBirth,DPHD_gau_DOB
--,PANGIR,DPHD_SH_PAN_NO
from (select max(DateOfSetup) sdt,boid inboid from  dps8_pc7 group by boid) a
, dps8_pc7 
, dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO and boid = inboid and sdt = DateOfSetup
and (  DPHD_gau_DOB<> DateofBirth)

END 
if @pa_criteria = 'GAUPAN'
BEGIN

select  boid ,PANGIR,DPHD_gau_PAN_NO
from (select max(DateOfSetup) sdt,boid inboid from  dps8_pc7 group by boid) a
, dps8_pc7 
, dp_holder_dtls 
where  boid = DPHD_DPAM_SBA_NO and boid = inboid and sdt = DateOfSetup
and ( DPHD_gau_PAN_NO<> PANGIR)

END 
if @pa_criteria = 'CORADR1'
BEGIN


select dpam_crn_no,dpam_sba_no , adr_1, adr_2, adr_3 , adr_city, adr_state, adr_country, adr_zip
into #tempcoradr1 from dp_acct_mstr 
,addresses
,entity_adr_conc 
where dpam_crn_no = entac_ent_id 
and entac_adr_conc_id = adr_id 
and entac_concm_cd = 'cor_adr1'

select  boid,Addr1 , ADR_1
,Addr2 , ADR_2
,Addr3 , ADR_3
,City , ADR_CITY
,State, ADR_STATE
,Country, ADR_COUNTRY
,PinCode, ADR_ZIP
from dps8_pc1 left outer join #tempcoradr1
on  boid = dpam_sba_no 
where (ltrim(rtrim(Addr1))<> ltrim(rtrim(isnull(ADR_1,'')))
or ltrim(rtrim(Addr2))<> ltrim(rtrim(isnull(ADR_2,'')))
or ltrim(rtrim(Addr3))<> ltrim(rtrim(isnull(ADR_3,'')))
or ltrim(rtrim(City))<> ltrim(rtrim(isnull(ADR_CITY,'')))
or ltrim(rtrim(State))<> ltrim(rtrim(isnull(ADR_STATe,'')))
or ltrim(rtrim(Country))<> ltrim(rtrim(isnull(ADR_COUNTRY,'')))
or ltrim(rtrim(PinCode))<> ltrim(rtrim(isnull(ADR_ZIP,'')))
)
and boid like '12010%'
and dpam_crn_no not in (select dpam_crn_no from dp_acct_mstr group by dpam_crn_no having count(1)>1)

--select * from dps8_pc1 where boid ='1201090003976493'


truncate table #tempcoradr1 
drop table #tempcoradr1 

END 

if @pa_criteria = 'PERADR1'
BEGIN

select dpam_crn_no,dpam_sba_no , adr_1, adr_2, adr_3 , adr_city, adr_state, adr_country, adr_zip
into #tempperadr1 from dp_acct_mstr 
,addresses
,entity_adr_conc 
where dpam_crn_no = entac_ent_id 
and entac_adr_conc_id = adr_id 
and entac_concm_cd ='per_adr1'

select  boid,Addr1 , ADR_1
,Addr2 , ADR_2
,Addr3 , ADR_3
,City , ADR_CITY
,State, ADR_STATE
,Country, ADR_COUNTRY
,PinCode, ADR_ZIP
from (select boid,max(Addr1) Addr1
,max(Addr2) Addr2
,max(Addr3) Addr3
,max(City) City
,max(State) State
,max(Country) Country
,max(PinCode) PinCode
from dps8_pc12 group by boid ) a left outer join #tempperadr1
on boid = dpam_sba_no 
where (ltrim(rtrim(Addr1))<> ltrim(rtrim(isnull(ADR_1,'')))
or ltrim(rtrim(Addr2))<> ltrim(rtrim(isnull(ADR_2,'')))
or ltrim(rtrim(Addr3))<> ltrim(rtrim(isnull(ADR_3,'')))
or ltrim(rtrim(City))<> ltrim(rtrim(isnull(ADR_CITY,'')))
or ltrim(rtrim(State))<> ltrim(rtrim(isnull(ADR_STATe,'')))
or ltrim(rtrim(Country))<> ltrim(rtrim(isnull(ADR_COUNTRY,'')))
or ltrim(rtrim(PinCode))<> ltrim(rtrim(isnull(ADR_ZIP,'')))
)
and boid like '12010%'
and dpam_crn_no not in (select dpam_crn_no from dp_acct_mstr group by dpam_crn_no having count(1)>1)

--select * from dps8_pc1 where boid ='1201090003976493'


truncate table #tempperadr1 
drop table #tempperadr1 

END 
if @pa_criteria = 'EMAIL1'
BEGIN

select dpam_sba_no , conc_value
into #tempemail from dp_acct_mstr 
,contact_channels 
,entity_adr_conc 
where dpam_crn_no = entac_ent_id 
and entac_adr_conc_id = conc_id  
and entac_concm_cd ='email1'

select  boid,EMailId cdasemai,conc_value dmatemail
from dps8_pc1 left outer join #tempemail
on boid = dpam_sba_no where (
ltrim(rtrim(EMailId))<> ltrim(rtrim(isnull(conc_value,''))))
and boid like '12010%'

--select * from dps8_pc1 where boid ='1201090003976493'


truncate table #tempemail 
drop table #tempemail 

END 
if @pa_criteria = 'FAX1'
BEGIN
select dpam_sba_no , conc_value
into #tempfax from dp_acct_mstr 
,contact_channels 
,entity_adr_conc 
where dpam_crn_no = entac_ent_id 
and entac_adr_conc_id = conc_id  
and entac_concm_cd ='fax1'

select  boid,Fax cdasfax,conc_value dmatfax
from dps8_pc1 left outer join #tempfax
on boid = dpam_sba_no where (
ltrim(rtrim(Fax))<> ltrim(rtrim(isnull(conc_value,''))))
and boid like '12010%'

--select * from dps8_pc1 where boid ='1201090003976493'


truncate table #tempfax 
drop table #tempfax 

END 

--select boid,PriPhInd,PriPhNum,AltPhInd,AltPhNum from dps8_pc1
if @pa_criteria = 'MOBILE1'
BEGIN

select dpam_sba_no , conc_value
into #tempmobile from dp_acct_mstr 
,contact_channels 
,entity_adr_conc 
where dpam_crn_no = entac_ent_id 
and entac_adr_conc_id = conc_id  
and entac_concm_cd ='MOBILE1' 

select  boid,PriPhNum cdas,conc_value dmat
from dps8_pc1 left outer join #tempmobile
on boid = dpam_sba_no where (
ltrim(rtrim(PriPhNum))<> ltrim(rtrim(isnull(conc_value,'')))) and PriPhInd ='M'
and boid like '12010%'
--select * from dps8_pc1 where boid ='1201090003976493'


truncate table #tempmobile 
drop table #tempmobile 

END 
if @pa_criteria = 'RES_PH1'
BEGIN

select dpam_sba_no , conc_value
into #tempRES from dp_acct_mstr 
,contact_channels 
,entity_adr_conc 
where dpam_crn_no = entac_ent_id 
and entac_adr_conc_id = conc_id  
and entac_concm_cd ='RES_PH1' 

select  boid,PriPhNum cdas,conc_value dmat
from dps8_pc1 left outer join #tempRES
on boid = dpam_sba_no where (
ltrim(rtrim(PriPhNum))<> ltrim(rtrim(isnull(conc_value,'')))) and PriPhInd ='R'
and boid like '12010%'

--select * from dps8_pc1 where boid ='1201090003976493'


truncate table #tempRES 
drop table #tempRES 

END 
if @pa_criteria = 'OFF_pH1'
BEGIN

select dpam_sba_no , conc_value
into #tempOFF from dp_acct_mstr 
,contact_channels 
,entity_adr_conc 
where dpam_crn_no = entac_ent_id 
and entac_adr_conc_id = conc_id  
and entac_concm_cd ='OFF_PH1' 

select  boid,PriPhNum cdas,conc_value dmat
from dps8_pc1 left outer join #tempOFF
on boid = dpam_sba_no where (
ltrim(rtrim(PriPhNum))<> ltrim(rtrim(isnull(conc_value,'')))) and PriPhInd ='O'
and boid like '12010%'

--select * from dps8_pc1 where boid ='1201090003976493'


truncate table #tempOFF 
drop table #tempOFF

END  

if @pa_criteria = 'BANKACNO'
BEGIN

select  boid,DivBankAcctNo,CLIBA_AC_NO--,DivAcctType--,case when CLIBA_AC_TYPE='SAVINGS' then '10' 
--when CLIBA_AC_TYPE='OTHERS' then '13' 
--when CLIBA_AC_TYPE='CURRENT' then '11' end 
from dps8_pc1,dp_acct_mstr,client_bank_accts 
where dpam_sba_no = boid 
and   cliba_clisba_id = dpam_id 
and   ltrim(rtrim(CLIBA_AC_NO )) <>  ltrim(rtrim(DivBankAcctNo))

END 

if @pa_criteria = 'BANK'
BEGIN

select  boid,DivBankCd,DivIFScd,banm_micr,banm_rtgs_cd
from dps8_pc1,dp_acct_mstr,client_bank_accts 
,bank_mstr
where dpam_sba_no = boid 
and   cliba_clisba_id = dpam_id 
and banm_id = cliba_banm_id
and (DivBankCd<> isnull(banm_micr ,'') or DivIFScd<>isnull(banm_rtgs_cd,''))--48923
and DivIFScd not in ('1','D')

--
--select  boid,DivBankCd,DivIFScd,banm_micr,banm_rtgs_cd
--INTO #TEMPDATA from dps8_pc1,dp_acct_mstr,client_bank_accts 
--,bank_mstr
--where dpam_sba_no = boid 
--and   cliba_clisba_id = dpam_id 
--and banm_id = cliba_banm_id
--and (DivBankCd<> isnull(banm_micr ,'') or DivIFScd<>isnull(banm_rtgs_cd,''))--48923
--
--
--SELECT A1.*
--,A.banm_micr 
--,A.banm_rtgs_cd
--,A.BANM_ID 
--FROM #TEMPDATA A1,(SELECT banm_micr , banm_rtgs_cd ,MAX(BANM_ID) BANM_ID  FROM bank_mstr A GROUP BY banm_micr , banm_rtgs_cd) A 
--WHERE DivBankCd = A.banm_micr AND DivIFScd = A.banm_rtgs_cd 
--ORDER BY BOID 


END 

--
--select count(1)
--,dpam_crn_no  
--from dmat.citrus_ur.dp_acct_mstr 
--group by dpam_crn_no 
--having count(1) > 1


end

GO
