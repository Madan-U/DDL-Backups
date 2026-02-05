-- Object: PROCEDURE citrus_usr.pr_insert_hst
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create   procedure [citrus_usr].[pr_insert_hst](@pa_Table varchar(50))
as
begin
--
if @pa_table = 'branch'
begin
--
Insert into branch_hst
(br_id
,branch_code
,branch
,long_name
,address1
,address2
,city
,state
,nation
,zip
,phone1
,phone2
,fax
,email
,contact_person
,prefix
,br_created_dt
,br_lst_upd_dt
,br_changed
,migrate_yn
)
select br_id
,branch_code
,branch
,long_name
,address1
,address2
,city
,state
,nation
,zip
,phone1
,phone2
,fax
,email
,contact_person
,prefix
,br_created_dt
,br_lst_upd_dt
,br_changed
,migrate_yn
from branch
where migrate_yn in (1,3)
--
delete from branch where migrate_yn in (1,3)
--
end
if @pa_table = 'BRANCH_COMMODITIES'
begin
--
Insert into branch_comm_hst
(br_id
,branch_code
,branch
,long_name
,address1
,address2
,city
,state
,nation
,zip
,phone1
,phone2
,fax
,email
,contact_person
,prefix
,br_created_dt
,br_lst_upd_dt
,br_changed
,migrate_yn
)
select br_id
,branch_code
,branch
,long_name
,address1
,address2
,city
,state
,nation
,zip
,phone1
,phone2
,fax
,email
,contact_person
,prefix
,br_created_dt
,br_lst_upd_dt
,br_changed
,migrate_yn
from branch_comm
where migrate_yn in (1,3)
--
delete from branch_comm where migrate_yn in (1,3)
--
end
if @pa_table = 'custodian'
begin
--
Insert into custodian_mstr_hst
(custodiancode
,short_name
,long_name
,address1
,address2
,city
,state
,nation
,zip
,fax
,off_phone1
,off_phone2
,email
,cltdpno
,dpid
,sebiregno
,exchange
,segment
,cd_created_dt
,cd_lst_upd_dt
,cd_changed
,migrate_yn
,cd_id
)
select custodiancode
,short_name
,long_name
,address1
,address2
,city
,state
,nation
,zip
,fax
,off_phone1
,off_phone2
,email
,cltdpno
,dpid
,sebiregno
,exchange
,segment
,cd_created_dt
,cd_lst_upd_dt
,cd_changed
,migrate_yn
,cd_id
from custodian_mstr
where migrate_yn in (1,3)

delete from custodian_mstr where migrate_yn in (1,3)
--
end
--
if @pa_table = 'sbu_master'
begin
--
Insert into relation_mgr_hst
(Sbu_Code
,Sbu_Name
,Sbu_Addr1
,Sbu_Addr2
,Sbu_Addr3
,Sbu_City
,Sbu_State
,Sbu_Zip
,Sbu_Phone1
,Sbu_Phone2
,Sbu_Type
,Sbu_Party_Code
,relm_created_dt
,relm_lst_upd_dt
,relm_changed
,migrate_yn
,RM_ID

)
select Sbu_Code
,Sbu_Name
,Sbu_Addr1
,Sbu_Addr2
,Sbu_Addr3
,Sbu_City
,Sbu_State
,Sbu_Zip
,Sbu_Phone1
,Sbu_Phone2
,Sbu_Type
,Sbu_Party_Code
,relm_created_dt
,relm_lst_upd_dt
,relm_changed
,migrate_yn
,RM_ID
from relation_mgr
where migrate_yn in (1,3)
--
delete from relation_mgr where migrate_yn in (1,3)
--
end
else if @pa_table = 'area'
begin
--
insert into area_hst(ar_id
,areacode
,description
,branch_code
,ar_created_dt
,ar_lst_upd_dt
,ar_changed
,migrate_yn
)
select ar_id
,areacode
,description
,branch_code
,ar_created_dt
,ar_lst_upd_dt
,ar_changed
,migrate_yn
from area
where migrate_yn in (1,3)

delete from area where migrate_yn in (1,3)
--
end
else if @pa_table = 'region'
begin
--
insert into region_hst(re_id
,regioncode
,description
,branch_code
,re_created_dt
,re_lst_upd_dt
,re_changed
,migrate_yn
)
select
re_id
,regioncode
,description
,branch_code
,re_created_dt
,re_lst_upd_dt
,re_changed
,migrate_yn
from region
where migrate_yn in (1,3)

delete from region where migrate_yn in (1,3)
--
end
else if @pa_table = 'subbrokers'
begin
--
insert into subbrokers_hst(sb_id
,sub_broker
,name
,address1
,address2
,city
,state
,nation
,zip
,fax
,phone1
,phone2
,reg_no
,registered
,email
,contact_person
,branch_code
,sb_created_dt
,sb_lst_upd_dt
,sb_changed
,migrate_yn
)
select
sb_id
,sub_broker
,name
,address1
,address2
,city
,state
,nation
,zip
,fax
,phone1
,phone2
,reg_no
,registered
,email
,contact_person
,branch_code
,sb_created_dt
,sb_lst_upd_dt
,sb_changed
,migrate_yn
from subbrokers
where migrate_yn in (1,3)
--

delete from subbrokers where migrate_yn in (1,3)

end
else if @pa_table = 'SUBBROKERS_COMMODITIES'
begin
--
insert into subbrokers_comm_hst(sb_id
,sub_broker
,name
,address1
,address2
,city
,state
,nation
,zip
,fax
,phone1
,phone2
,reg_no
,registered
,email
,contact_person
,branch_code
,sb_created_dt
,sb_lst_upd_dt
,sb_changed
,migrate_yn


)
select
sb_id
,sub_broker
,name
,address1
,address2
,city
,state
,nation
,zip
,fax
,phone1
,phone2
,reg_no
,registered
,email
,contact_person
,branch_code
,sb_created_dt
,sb_lst_upd_dt
,sb_changed
,migrate_yn

from subbrokers_comm
where migrate_yn in (1,3)
--

delete from subbrokers_comm where migrate_yn in (1,3)

end
else if @pa_table = 'branches'
begin
--
insert into branches_hst(dl_id
,branch_cd
,short_name
,long_name
,address1
,address2
,city
,state
,nation
,zip
,phone1
,phone2
,fax
,email
,contact_person
,terminal_id
,dl_created_dt
,dl_lst_upd_dt
,dl_changed
,migrate_yn
)
select
dl_id
,branch_cd
,short_name
,long_name
,address1
,address2
,city
,state
,nation
,zip
,phone1
,phone2
,fax
,email
,contact_person
,terminal_id
,dl_created_dt
,dl_lst_upd_dt
,dl_changed
,migrate_yn
from branches
where migrate_yn in (1,3)

delete from branches where migrate_yn in (1,3)
end
else if @pa_table = 'pobank'
begin
--
insert into pobank_hst(banm_id
,bank_name
,branch_name
,address1
,address2
,city
,state
,nation
,zip
,phone1
,phone2
,fax
,email
,pob_created_dt
,pob_lst_upd_dt
,pob_changed
,migrate_yn

)
select
banm_id
,bank_name
,branch_name
,address1
,address2
,city
,state
,nation
,zip
,phone1
,phone2
,fax
,email
,pob_created_dt
,pob_lst_upd_dt
,pob_changed
,migrate_yn

from pobank
where migrate_yn in (3,1)
--

delete from pobank where migrate_yn in (3,1)
end
else if @pa_table = 'bank'
begin
--
insert into bank_hst(dpm_id
,bankid
,bankname
,address1
,address2
,city
,pincode
,phone1
,phone2
,phone3
,phone4
,fax1
,fax2
,email
,banktype
,dpm_created_dt
,dpm_lst_upd_dt
,dpm_changed
,migrate_yn
)
select dpm_id
,bankid
,bankname
,address1
,address2
,city
,pincode
,phone1
,phone2
,phone3
,phone4
,fax1
,fax2
,email
,banktype
,dpm_created_dt
,dpm_lst_upd_dt
,dpm_changed
,migrate_yn
from bank
where migrate_yn in (1,3)

delete from bank where migrate_yn in (1,3)
--
end
else if @pa_table = 'clientstatus'
begin
--
insert into clientstatus_hst(cls_id
,cl_status
,description
,cl_created_dt
,cl_lst_upd_dt
,cl_changed
,migrate_yn
)
select
cls_id
,cl_status
,description
,cl_created_dt
,cl_lst_upd_dt
,cl_changed
,migrate_yn
from clientstatus
where migrate_yn in (1,3)

delete from clientstatus where migrate_yn in (1,3)
--
end
else if @pa_table = 'clienttype'
begin
--
insert into clienttype_hst(enttm_id
,cl_type
,description
,group_code
,prefix
,ct_created_dt
,ct_lst_upd_dt
,ct_changed
,migrate_yn
)
select enttm_id
,cl_type
,description
,group_code
,prefix
,ct_created_dt
,ct_lst_upd_dt
,ct_changed
,migrate_yn
from clienttype
where migrate_yn in (1,3)

delete from clienttype
where migrate_yn in (1,3)
--
end
else if @pa_table = 'client_details'
begin
--
insert into client_details_hst(client_id
,branch_cd
,party_code
,sub_broker
,trader
,long_name
,short_name
,l_address1
,l_city
,l_address2
,l_state
,l_address3
,l_nation
,l_zip
,pan_gir_no
,ward_no
,sebi_regn_no
,res_phone1
,res_phone2
,off_phone1
,off_phone2
,mobile_pager
,fax
,email
,cl_type
,cl_status
,family
,region
,area
,p_address1
,p_city
,p_address2
,p_state
,p_address3
,p_nation
,p_zip
,addemailid
,sex
,dob
,approver
,interactmode
,passport_no
,passport_issued_at
,passport_issued_on
,passport_expires_on
,licence_no
,licence_issued_at
,licence_issued_on
,licence_expires_on
,rat_card_no
,rat_card_issued_at
,rat_card_issued_on
,votersid_no
,votersid_issued_at
,votersid_issued_on
,it_return_yr
,it_return_filed_on
,regr_no
,regr_at
,regr_on
,regr_authority
,client_agreement_on
,dealing_with_other_tm
,other_ac_no
,introducer_id
,introducer
,introducer_relation
,chk_kyc_form
,chk_corporate_deed
,chk_bank_certificate
,chk_annual_report
,chk_networth_cert
,chk_corp_dtls_recd
,sbu
,modifidedby
,modifiedon
,mapin_id
,ucc_code
,fm_code
,micr_no
,director_name
,paylocation
,cd_created_dt
,cd_lst_upd_dt
,cd_changed
,migrate_yn


)
select client_id
,branch_cd
,party_code
,sub_broker
,trader
,long_name
,short_name
,l_address1
,l_city
,l_address2
,l_state
,l_address3
,l_nation
,l_zip
,pan_gir_no
,ward_no
,sebi_regn_no
,res_phone1
,res_phone2
,off_phone1
,off_phone2
,mobile_pager
,fax
,email
,cl_type
,cl_status
,family
,region
,area
,p_address1
,p_city
,p_address2
,p_state
,p_address3
,p_nation
,p_zip
,addemailid
,sex
,dob
,approver
,interactmode
,passport_no
,passport_issued_at
,passport_issued_on
,passport_expires_on
,licence_no
,licence_issued_at
,licence_issued_on
,licence_expires_on
,rat_card_no
,rat_card_issued_at
,rat_card_issued_on
,votersid_no
,votersid_issued_at
,votersid_issued_on
,it_return_yr
,it_return_filed_on
,regr_no
,regr_at
,regr_on
,regr_authority
,client_agreement_on
,dealing_with_other_tm
,other_ac_no
,introducer_id
,introducer
,introducer_relation
,chk_kyc_form
,chk_corporate_deed
,chk_bank_certificate
,chk_annual_report
,chk_networth_cert
,chk_corp_dtls_recd
,sbu
,modifidedby
,modifiedon
,mapin_id
,ucc_code
,fm_code
,micr_no
,director_name
,paylocation
,cd_created_dt
,cd_lst_upd_dt
,cd_changed
,migrate_yn



from client_details
where migrate_yn in (1,3)

delete from client_details where migrate_yn in (1,3)
--
end
--
--added by vivek on 191208 for client details commodities
--
else if @pa_table = 'client_details_commodities'
begin
--
--
insert into client_details_hst_commodities(client_id
,branch_cd
,party_code
,sub_broker
,trader
,long_name
,short_name
,l_address1
,l_city
,l_address2
,l_state
,l_address3
,l_nation
,l_zip
,pan_gir_no
,ward_no
,sebi_regn_no
,res_phone1
,res_phone2
,off_phone1
,off_phone2
,mobile_pager
,fax
,email
,cl_type
,cl_status
,family
,region
,area
,p_address1
,p_city
,p_address2
,p_state
,p_address3
,p_nation
,p_zip
,addemailid
,sex
,dob
,approver
,interactmode
,passport_no
,passport_issued_at
,passport_issued_on
,passport_expires_on
,licence_no
,licence_issued_at
,licence_issued_on
,licence_expires_on
,rat_card_no
,rat_card_issued_at
,rat_card_issued_on
,votersid_no
,votersid_issued_at
,votersid_issued_on
,it_return_yr
,it_return_filed_on
,regr_no
,regr_at
,regr_on
,regr_authority
,client_agreement_on
,dealing_with_other_tm
,other_ac_no
,introducer_id
,introducer
,introducer_relation
,chk_kyc_form
,chk_corporate_deed
,chk_bank_certificate
,chk_annual_report
,chk_networth_cert
,chk_corp_dtls_recd
,sbu
,modifidedby
,modifiedon
,mapin_id
,ucc_code
,fm_code
,micr_no
,director_name
,paylocation
,cd_created_dt
,cd_lst_upd_dt
,cd_changed
,migrate_yn
,ucc_no
,bank_name
,branch_name
,ac_type
,ac_num
,rel_mgr
,Depository1
,Dpid1
,CltDpId1
,Poa1
,c_group
)
select client_id
,branch_cd
,party_code
,sub_broker
,trader
,long_name
,short_name
,l_address1
,l_city
,l_address2
,l_state
,l_address3
,l_nation
,l_zip
,pan_gir_no
,ward_no
,sebi_regn_no
,res_phone1
,res_phone2
,off_phone1
,off_phone2
,mobile_pager
,fax
,email
,cl_type
,cl_status
,family
,region
,area
,p_address1
,p_city
,p_address2
,p_state
,p_address3
,p_nation
,p_zip
,addemailid
,sex
,dob
,approver
,interactmode
,passport_no
,passport_issued_at
,passport_issued_on
,passport_expires_on
,licence_no
,licence_issued_at
,licence_issued_on
,licence_expires_on
,rat_card_no
,rat_card_issued_at
,rat_card_issued_on
,votersid_no
,votersid_issued_at
,votersid_issued_on
,it_return_yr
,it_return_filed_on
,regr_no
,regr_at
,regr_on
,regr_authority
,client_agreement_on
,dealing_with_other_tm
,other_ac_no
,introducer_id
,introducer
,introducer_relation
,chk_kyc_form
,chk_corporate_deed
,chk_bank_certificate
,chk_annual_report
,chk_networth_cert
,chk_corp_dtls_recd
,sbu
,modifidedby
,modifiedon
,mapin_id
,ucc_code
,fm_code
,micr_no
,director_name
,paylocation
,cd_created_dt
,cd_lst_upd_dt
,cd_changed
,migrate_yn
,ucc_no
,bank_name
,branch_name
,ac_type
,ac_num
,rel_mgr
,Depository1
,Dpid1
,CltDpId1
,Poa1
,c_group

from client_details_commodities
where migrate_yn in (1,3)

delete from client_details_commodities where migrate_yn in (1,3)
--
end
--
--
--
else if @pa_table = 'client_brok_details'
--
begin
--
insert into client_brok_details_hst(cl_code
,exchange
,segment
,profile_id
,clibd_created_dt
,clibd_lst_upd_dt
,clibd_changed
,migrate_yn

)
select cl_code
,exchange
,segment
,profile_id
,clibd_created_dt
,clibd_lst_upd_dt
,clibd_changed
,migrate_yn


from client_brok_details
where migrate_yn in (1,3)

delete from client_brok_details where migrate_yn in (1,3)
--
end
--
--added by vivek on 191208 for client brok details commodities
--
--
else if @pa_table = 'client_brok_details_commodities'
begin
--
--
insert into client_brok_details_hst_commodities(cl_code
,exchange
,segment
,profile_id
,clibd_created_dt
,clibd_lst_upd_dt
,clibd_changed
,migrate_yn
,status_flag
,Participant_Code
,Custodian_Code
,STP_Provider
,STP_Rp_Style
,Inst_Contract
,roundin_method
,Round_To_Digit
,pay_bank_name
,pay_branch_name
, pay_payment_mode
,pay_b3b_payment
,inactive_from  --added on 13102008 by vivek
,clibd_id
)
select cl_code
,exchange
,segment
,profile_id
,clibd_created_dt
,clibd_lst_upd_dt
,clibd_changed
,migrate_yn
,status_flag
,Participant_Code
,Custodian_Code
,STP_Provider
,STP_Rp_Style
,Inst_Contract
,roundin_method
,Round_To_Digit
,pay_bank_name
,pay_branch_name
, pay_payment_mode
,pay_b3b_payment
,inactive_from
,clibd_id
from client_brok_details_commodities

where migrate_yn in (1,3)
--
delete from client_brok_details_commodities where migrate_yn in (1,3)
--
end
--
--
--
--
--
else if @pa_table = 'multicltid'
begin
--
insert into multicltid_hst(Party_Code
,Cltdpno
,Dpid
,Introducer
,Dptype
,poatype
,Def
,clidpa_created_dt
,clidpa_lst_upd_dt
,clidpa_changed
,migrate_yn

)
select Party_Code
,Cltdpno
,Dpid
,Introducer
,Dptype
,poatype
,Def
,clidpa_created_dt
,clidpa_lst_upd_dt
,clidpa_changed
,migrate_yn

from multicltid
where migrate_yn in (1,3)

delete from multicltid where migrate_yn in (1,3)
--
end
--
--added by vivek on 181208 for multicltid commodity
--
else if @pa_table = 'multicltid_commodities'
begin
--
--
insert into multicltid_hst_commodities(Party_Code
,Cltdpno
,Dpid
,Introducer
,Dptype
,poatype
,Def
,clidpa_created_dt
,clidpa_lst_upd_dt
,clidpa_changed
,migrate_yn
,clidpa_id
)
select Party_Code
,Cltdpno
,Dpid
,Introducer
,Dptype
,poatype
,Def
,clidpa_created_dt
,clidpa_lst_upd_dt
,clidpa_changed
,migrate_yn
,clidpa_id
from multicltid_commodities
where migrate_yn in (1,3)

delete from multicltid_commodities where migrate_yn in (1,3)
--
end
--
--
--
else if @pa_table = 'multibankid'
begin
--
insert into multibankid_hst(Accno
,Acctype
,Chequename
,Defaultbank
,banm_name
,banm_branch
,cltcd
,cliba_created_dt
,cliba_lst_upd_dt
,cliba_changed
,migrate_yn


)
select Accno
,Acctype
,Chequename
,Defaultbank
,banm_name
,banm_branch
,cltcd
,cliba_created_dt
,cliba_lst_upd_dt
,cliba_changed
,migrate_yn

from multibankid
where migrate_yn in (1,3)
--
delete from multibankid where migrate_yn in (1,3)
end
--
--added by vivek on 181208 for multibankid commodity
--
else if @pa_table = 'multibankid_commodities'
begin
--
--
insert into multibankid_hst_commodities(Accno
,Acctype
,Chequename
,Defaultbank
,banm_name
,banm_branch
,cltcd
,cliba_created_dt
,cliba_lst_upd_dt
,cliba_changed
,migrate_yn
,cliba_id
)
select Accno
,Acctype
,Chequename
,Defaultbank
,banm_name
,banm_branch
,cltcd
,cliba_created_dt
,cliba_lst_upd_dt
,cliba_changed
,migrate_yn
,cliba_id
from multibankid_commodities
where migrate_yn in (1,3)
--
delete from multibankid_commodities where migrate_yn in (1,3)
end
--
--
--
--ADDED BY VIVEK ON 03/10/2008
--
else if @pa_table = 'client_contact_details'
begin
--
insert into client_contact_details_hst(cl_code
,line_no
,contact_name
,address1
,address2
,address3
,city
,state
,nation
,zip
,phone_no
,mobileno
,panno
,designation
,email
,clicd_created_dt
,clicd_lst_upd_dt
,clicd_changed
,migrate_yn
)
select cl_code
,line_no
,contact_name
,address1
,address2
,address3
,city
,state
,nation
,zip
,phone_no
,mobileno
,panno
,designation
,email
,clicd_created_dt
,clicd_lst_upd_dt
,clicd_changed
,migrate_yn
from client_contact_details
where migrate_yn in (1,3)
--
delete from client_contact_details where migrate_yn in (1,3)
end
--
--
--added by vivek on 190609
else if @pa_table = 'client_contact_details_commodities'
begin
--
insert into client_contact_details_hst_commodities(cl_code
,line_no
,contact_name
,address1
,address2
,address3
,city
,state
,nation
,zip
,phone_no
,mobileno
,panno
,designation
,email
,clicd_created_dt
,clicd_lst_upd_dt
,clicd_changed
,migrate_yn
)
select cl_code
,line_no
,contact_name
,address1
,address2
,address3
,city
,state
,nation
,zip
,phone_no
,mobileno
,panno
,designation
,email
,clicd_created_dt
,clicd_lst_upd_dt
,clicd_changed
,migrate_yn
from client_contact_details_commodities
where migrate_yn in (1,3)
--
delete from client_contact_details_commodities where migrate_yn in (1,3)
end
--

--added by jitesh on 080610
else if @pa_table = 'client_mutual_details'
begin
--
INSERT INTO MFSS_CLIENT_HST
(CLIENT_ID
,CLIENT_NAME
,GENDER
,OCCUPATION_CODE
,TAX_STATUS
,PAN_NO
,KYC_FLAG
,ADDR1
,ADDR2
,ADDR3
,CITY
,STATE
,ZIP
,OFFICE_PHONE
,RES_PHONE
,MOBILE_NO
,EMAIL_ID
,BANK_NAME
,BANK_BRANCH
,BANK_CITY
,ACC_NO
,PAYMODE
,MICR_NO
,DOB
,GAURDIAN_NAME
,GAURDIAN_PAN_NO
,NOMINEE_NAME
,NOMINEE_RELATION
,BANK_AC_TYPE
,STAT_COMM_MODE
,MODIFIEDBY
,MODIFIEDON
,CD_CREATED_DT
,CD_LST_UPD_DT
,CD_CHANGED
,MIGRATE_YN
)
select CLIENT_ID
,CLIENT_NAME
,GENDER
,OCCUPATION_CODE
,TAX_STATUS
,PAN_NO
,KYC_FLAG
,ADDR1
,ADDR2
,ADDR3
,CITY
,STATE
,ZIP
,OFFICE_PHONE
,RES_PHONE
,MOBILE_NO
,EMAIL_ID
,BANK_NAME
,BANK_BRANCH
,BANK_CITY
,ACC_NO
,PAYMODE
,MICR_NO
,DOB
,GAURDIAN_NAME
,GAURDIAN_PAN_NO
,NOMINEE_NAME
,NOMINEE_RELATION
,BANK_AC_TYPE
,STAT_COMM_MODE
,MODIFIEDBY
,MODIFIEDON
,CD_CREATED_DT
,CD_LST_UPD_DT
,CD_CHANGED
,MIGRATE_YN
FROM MFSS_CLIENT
WHERE MIGRATE_YN IN (1,3)
--
DELETE FROM MFSS_CLIENT_HST WHERE MIGRATE_YN IN (1,3)
END
--
--
--
--
end

GO
