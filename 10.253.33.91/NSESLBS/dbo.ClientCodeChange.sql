-- Object: PROCEDURE dbo.ClientCodeChange
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc ClientCodeChange (
 @FromParty Varchar(10),
 @ToParty   Varchar(10),
 @Branch    Varchar(10),
 @SubBroker Varchar(10),
 @Trader    Varchar(10),
 @Area      Varchar(10),
 @Region    Varchar(10) )
AS

If (Select IsNull(Count(1),0) From Client_Details Where Party_Code = @FromParty ) = 0
Begin
	Select Msg = 'Invalid From Party Code'
	Return 
End
If (Select IsNull(Count(1),0) From Client_Details Where Party_Code = @ToParty ) = 0
Begin
	Select Msg = 'Invalid To Party Code'
	Return 
End
If (Select IsNull(Count(1),0) From Branch Where Branch_Code = @Branch ) = 0
Begin
	Select Msg = 'Invalid Branch Code'
	Return 
End
If (Select IsNull(Count(1),0) From SubBrokers Where Sub_Broker = @SubBroker And Branch_Code = @Branch) = 0
Begin
	Select Msg = 'Invalid Sub Broker Code'
	Return 
End
If (Select IsNull(Count(1),0) From Branches Where Short_Name = @Trader And Branch_Cd = @Branch) = 0
Begin
	Select Msg = 'Invalid Trader Code'
	Return 
End
If (Select IsNull(Count(1),0) From Area Where AreaCode = @Area And Branch_Code = @Branch) = 0
Begin
	Select Msg = 'Invalid Area Code'
	Return 
End
If (Select IsNull(Count(1),0) From Region Where RegionCode = @Region And Branch_Code = @Branch) = 0
Begin
	Select Msg = 'Invalid Region Code'
	Return 
End

Select @ToParty,@branch,@ToParty,@SubBroker,@Trader,long_name,short_name,l_address1,l_city,l_address2,l_state,
l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,off_phone1,off_phone2,
mobile_pager,fax,email,cl_type,cl_status,@ToParty,@Region,@Area,p_address1,p_city,p_address2,p_state,p_address3,
p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,passport_no,passport_issued_at,
passport_issued_on,passport_expires_on,licence_no,licence_issued_at,licence_issued_on,licence_expires_on,
rat_card_no,rat_card_issued_at,rat_card_issued_on,votersid_no,votersid_issued_at,votersid_issued_on,it_return_yr,
it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,client_agreement_on,sett_mode,dealing_with_other_tm,
other_ac_no,introducer_id,introducer_relation,repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,
chk_bank_certificate,chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,
Depository1,DpId1,CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,rel_mgr,c_group,
sbu,Status='I',Imp_Status=0,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,Director_name,paylocation
From Client_Details Where Cl_Code = @FromParty

Select @ToParty,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,InActive_From,
Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,
Market_Type,Multiplier,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,
TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,Del_Tran_Chrgs,
Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,Round_To_Digit,Round_To_Paise,
Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,
Fut_Stamp_Duty,Fut_Other_Chrgs,Status='I',Modifiedon,Modifiedby,Imp_Status=0,Pay_B3B_Payment,Pay_Bank_name,
Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,GetDate(),Active_Date,
CheckActiveClient
From Client_Brok_Details Where Cl_Code = @FromParty

Update Client_Details Set 
Depository1 = '', DpId1 = '', CltDpId1 = '', Poa1 = '',
Depository2 = '', DpId2 = '', CltDpId2 = '', Poa2 = '',
Depository3 = '', DpId3 = '', CltDpId3 = '', Poa3 = ''
Where Cl_Code = @FromParty

Delete From Client4 Where Party_Code = @FromParty And Depository in ('NSDL', 'CDSL')
Delete From BSEDB.DBO.Client4 Where Party_Code = @FromParty And Depository in ('NSDL', 'CDSL')
Delete From NSEFO.DBO.Client4 Where Party_Code = @FromParty And Depository in ('NSDL', 'CDSL')

Delete From MultiCltID Where Party_Code = @FromParty
Delete From BSEDB.DBO.MultiCltID Where Party_Code = @FromParty
Delete From NSEFO.DBO.MultiCltID Where Party_Code = @FromParty

Select Msg = 'Party Data Transferred Successfully.'

GO
