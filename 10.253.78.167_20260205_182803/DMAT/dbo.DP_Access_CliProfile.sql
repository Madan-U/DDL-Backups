-- Object: VIEW dbo.DP_Access_CliProfile
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


      
CREATE View [dbo].[DP_Access_CliProfile]              
as              
select            
            
/* Client Profile */            
substring(CM_CD,9,8) as Client_id,            
CM_CD as Client_code,            
(Case when Type='' then 'Individual' else Type end) as ACCTYPE,            
CM_Name as Name,            
CM_CLIENTTYPE as SUB_TYPE,            
--CM_MIDDLENAME as Father_Husband_Name,        
FIRST_HOLD_FNAME as Father_Husband_Name,        
--convert(varchar(10),convert(datetime,BO_DOB,103),103) as DOB,          
--modified by sandeep on 07 oct 2015     
case when  ISNUMERIC(BO_DOB)=1 then convert(varchar(10),convert(datetime,isnull(substring(BO_DOB,1,2)+'/'+substring(BO_DOB,3,2)+'/'+substring(BO_DOB,5,4),''),103),103) else  BO_DOB end as DOB,          
--Ended by sandeep     
--Case when CM_DateofBirth <> '' then            
--convert(varchar(10),            
--convert(datetime,substring(CM_DateofBirth,1,2)+'/'+substring(CM_DateofBirth,3,2)+'/'+substring(CM_DateofBirth,5,2)),103)            
--else '' end            
--as DOB,            
[STATUS] as Acc_Status,            
CM_occupation as Occupation,    
case WHEN  
  ISNUMERIC(CM_Opendate)=1 THEN          
convert(varchar(10),            
convert(datetime,substring(CM_Opendate,1,2)+'/'+substring(CM_Opendate,3,2)+'/'+substring(CM_Opendate,5,2)),103) ELSE '' END as Open_date,            
Case when  ISNUMERIC(CM_ACC_CLosureDate)=1 then            
convert(varchar(10),            
convert(datetime,substring(CM_ACC_CLosureDate,1,2)+'/'+substring(CM_ACC_CLosureDate,3,2)+'/'+substring(CM_ACC_CLosureDate,5,2)),103)            
else '' end as Close_date,            
0 as Standing_inst,            
            
/* Basic Information */            
CM_ADD1 as CAdd1,            
CM_ADD2 as CAdd2,            
CM_ADD3 as CAdd3,            
CM_CITY as CCity,            
CM_STATE as CState,            
CM_COUNTRY as CCountry,            
CM_PIN as CPin,            
CM_Tele1 as CPhone,            
CM_fax as CFax,            
CM_Mobile as CMobile,            
            
/* Other Holder or Nominee Details */            
isnull(second_hold_name, '') as SH_Name,            
isnull(second_hold_itpan, '') as SH_PAN,            
isnull(third_hold_name, '') as TH_Name,            
isnull(third_hold_itpan, '') as TH_PAN,            
space(25) as Nominee_Name,            
space(50) as Nominee_Address,            
space(10) as Nominee_DOB,            
            
/* Financial Details */            
space(10) as Bank_Type,            
CM_BANKACTNO as BANK_ACC_NO,            
cm_micr AS MICR_COde,            
CM_BANKNAME as BANKNAME,            
space(25) as BRADD1,            
space(25) as BRADD2,            
space(25) as BRADD3,            
space(15) as BRADD4,            
space(10) as BRPIN,            
isnull(ITPAN, '') as FHPAN,            
space(15) as FH_RBI,            
space(15) as FH_SEBI,            
space(15) as FH_TDS,            
            
/* CHARGES */            
space(25) as CHARGES_SCHEME,            
space(25) as AMC_CHARGES,            
space(25) as Due_Date,            
            
/* Other info */            
CM_Email as email,            
isnull(EMAIL_FLAG, 'N') as ECN,            
isnull(first_sms_flag, 'N') as SMARTFLAG  ,          
FOREIGN_ADDR1,FOREIGN_ADDR2,FOREIGN_ADDR3,FOREIGN_CITY,FOREIGN_STATE,FOREIGN_CNTRY,FOREIGN_ZIP,FOREIGN_PHONE,FOREIGN_FAX          
from Inhouse.dbo.tbl_client_master t with (nolock),            
Inhouse.dbo.Client_Master a with (nolock) left outer join            
Inhouse.dbo.Beneficiary_status b with (nolock)            
on a.cm_active=b.bs_code            
where t.client_code = a.cm_cd

GO
