-- Object: PROCEDURE dbo.dharmesh
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create proc dharmesh
as
select top 1 * from owner

/*
<%@Language="VBScript"%>
<!--#include file="../../get_cookie.asp"-->
<!-- #include file="../../connnection.asp" -->
<!--#include file="Include/convertdate.asp"-->
<%
if Request.form("txtPartyCode")="" then
		response.redirect "PartyCodeApproval.asp"
end if
Dim OtherState,Party_code

	set objCon = Server.CreateObject("ADODB.connection")
	objCon.CursorLocation = 3		'Client Side Cursor
	objCon.ConnectionTimeout = 1200	'20 Min.
	objCon.CommandTimeout = 1200	'20 Mins.
	objCon.Open connectionstr1	

	set objRS = Server.CreateObject("ADODB.connection")
	set objRSdpid = Server.CreateObject("ADODB.RecordSet")
	stralert = "Record Updates Successfully...."
	strMessage = "Updates Successfully"


 'for FAMILYCODE 
		if Request.Form("txtFamilyCode") <> Request.Form("txtPartyCode") then
			 If (Ucase(StatusId) = "BROKER" or StatusId = "" )Then
							strSQL = "select cl_code from Client_details "
							strSQL = strSQL & "where "
							strSQL = strSQL & 	"	cl_code = '" &  Request.form("txtFamilyCode") & "'"
			else
							strSQL = "select cl_code from Client_details "
							strSQL = strSQL & "where "
							strSQL = strSQL & 	"	cl_code = '" &  Request.form("txtFamilyCode") & "' and Branch_cd = '" & Ucase(statusname) & "'"
			
			end if
							Response.Write "<!--" & strSQL & "-->" & vbNewLine
							Set objRS = objCon.Execute(strSQL)
							
							If objRS.EOF=True Then
									WriteMissingError "FAMILYCODE", Request.form("txtFamilyCode")
							End If
		End if
							
	Dim strBankid
		set objMiscRSMs = Server.CreateObject("ADODB.recordset")

	'	strSQL = vbNullString
		'strSQL = strSQL & "set transaction isolation level read uncommitted "
	'	strSQL = strSQL & " select ltrim(rtrim(BANKID)) from Pobank "
	'	strSQL = strSQL & " where bank_name = '" & Request.form("txtBankName") & "' and Branch_Name = '" & Request.form("txtBranchName") & "'"
		'objMiscRSMs.Open strSQL,connectionstr1
	'	strBankid = objMiscRSMs(0)
	'	objMiscRSMs.close


	set rsTemp3 = Server.CreateObject("ADODB.recordset")  

	 if UCase(Request.form("txtState")) <> "OTHER" then 
				OtherState = UCase(Request.form("txtState"))
		else
				OtherState = UCase(Request.form("txtOtherState"))
		end if


 
	objCon.BeginTrans

		strMiscSQL = " insert into Client_Details_Log select cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,l_address2,l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,off_phone1,off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,p_address2,p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,passport_no,passport_issued_at,passport_issued_on,passport_expires_on,licence_no,licence_issued_at,licence_issued_on,licence_expires_on,rat_card_no,rat_card_issued_at,rat_card_issued_on,votersid_no,votersid_issued_at,votersid_issued_on,it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,client_agreement_on,sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,introducer_relation,repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,chk_bank_certificate,chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,Depository1,DpId1,CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,rel_mgr,c_group,sbu,Status,Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,'" & UCase(Trim(uname)) & "',Getdate(),Director_name,Paylocation,FmCode  from Client_Details where cl_code='" & Trim(Request.Form("txtPartyCode")) & "' "

		strMiscSQL = strMiscSQL & "  Update Client_Details Set "
		strMiscSQL = strMiscSQL & "	party_code='" & UCase(Request.form("txtPartyCode")) & "',"
		strMiscSQL = strMiscSQL & "	cl_code='" & UCase(Request.form("txtPartyCode")) & "',"
		strMiscSQL = strMiscSQL & " family = '" &  UCase(Request.form("txtFamilyCode")) & "',"	
  		strMiscSQL = strMiscSQL & " ModifidedOn = getdate() ," 
		strMiscSQL = strMiscSQL & "ModifidedBy ='" & UCase(Trim(uname)) & "',"
		strMiscSQL = strMiscSQL & " Status = 'I',"
		strMiscSQL = strMiscSQL & " Imp_status= '" & Trim(Request.form("fldclientMakerCheker")) & "'"	
		strMiscSQL = strMiscSQL & " Where cl_code='" & UCase(Request.form("txtOrigPartyCode")) & "'"
		

		 
		objCon.Execute strMiscSQL												
		objCon.CommitTrans
		WriteHTMLSuccessBody
		WriteHTMLFooter


	Private Function WriteMissingError (varWhatIsWrong, varWrongValue)
		With Response
			.Write "				<script language=""javascript"">"

			Select Case Trim(UCase(varWhatIsWrong)) 
				Case "SUBBROKER"
					.Write "					alert('The Entered Sub-Broker Code, " & varWrongValue & ", Does Not Exist.');"
					.Write "					window.parent.frmAddClientMin.txtSubBrokerCode.select();"

				Case "FAMILYCODE" 
					.Write "					alert('The Entered Family Code, " & varWrongValue & ", Does Not Exist.');"
					.Write "					window.parent.frmAddClientMin.txtFamilyCode.select();"

				Case "TRADERCODE"
					.Write "					alert('The Entered Trader Code, " & varWrongValue & ", Does Not Exist.');"
					.Write "					window.parent.frmAddClientMin.txtTraderCode.select();"

			   Case "AREACODE"
					.Write "					alert('The Entered Area Code, " & varWrongValue & ", Does Not Exist.');"
					.Write "					window.parent.frmAddClientMin.txtAreaCode.select();"
					

			  Case "REGIONCODE"
					.Write "					alert('The Entered Region Code, " & varWrongValue & ", Does Not Exist.');"
					.Write "					window.parent.frmAddClientMin.txtRegionCode.select();"
		

			  Case "RELMANAGER"
					.Write "					alert('The Entered Rel. Manager Code, " & varWrongValue & ", Does Not Exist.');"

			  Case "GROUPCODE"
					.Write "					alert('The Entered Group Code, " & varWrongValue & ", Does Not Exist.');"
					.Write "					window.parent.frmAddClientMin.txtGroupCode.select();"

			  Case "SBUCODE"
					.Write "					alert('The Entered SBU Code, " & varWrongValue & ", Does Not Exist.');"
					.Write "					window.parent.frmAddClientMin.txtSBUCode.select();"

			  Case "PANNO"
							.Write " counter='" & objRS("count") & "';"
							.write " var  strlength = window.parent.window.document.frmAddClientMin.	txtPANNo.value; "
							.write " var  strPanNoVal = window.parent.window.document.frmAddClientMin.	hdntxtPANNo.value; "
							.write " strcountlength = strlength.length;"
							.write " if (strcountlength >0 && strlength != strPanNoVal)"
							.write " {"
							.write " if (counter > 0)"
							.write " {"
							.Write "			alert('The PAN/GIR No, " & varWrongValue & ", Already Exist. For " & Party_code & " Party');"
							.Write "			window.parent.window.document.frmAddClientMin.txtPANNo.select();"
							.Write " }"
							.Write " }"


			  Case "PASSPORTNO"
							.Write " counter='" & objRS("count") & "';"
							.write " var  strlength = window.parent.window.document.frmAddClientMin.txtPassportNo.value; "
							.write " var  strPassportNoVal = window.parent.window.document.frmAddClientMin.hdntxtPassportNo.value; "
							.write " strcountlength = strlength.length;"
							.write " if (strcountlength >0 && strlength != strPassportNoVal)"
							.write " {"
							.write " if (counter > 0)"
							.write " {"
							.Write "			alert('The Passport No, " & varWrongValue & ", Already Exist. For " & Party_code & " Party');"
							.Write "			window.parent.window.document.frmAddClientMin.txtPassportNo.select();"
							.Write " }"
							.Write " }"
			  Case "DLNO"
							.Write " counter='" & objRS("count") & "';"
							.write " var  strlength = window.parent.window.document.frmAddClientMin.txtLicenceNo.value; "
							.write " var  strDlNoVal = window.parent.window.document.frmAddClientMin.hdntxtLicenceNo.value; "
							.write " strcountlength = strlength.length;"
							.write " if (strcountlength >0 && strlength != strDlNoVal)"
							.write " {"
							.write " if (counter > 0)"
							.write " {"
							.Write "			alert('The Drv. Lic.  No, " & varWrongValue & ", Already Exist. For " & Party_code & " Party');"
							.Write "			window.parent.window.document.frmAddClientMin.txtLicenceNo.select();"
							.Write " }"
							.Write " }"
							
			  Case "VOTERID"
							.Write " counter='" & objRS("count") & "';"
							.write " var  strlength = window.parent.window.document.frmAddClientMin.txtVoterIDNo.value; "
							.write " var  strVoteridVal = window.parent.window.document.frmAddClientMin.hdntxtVoterIDNo.value; "
							.write " strcountlength = strlength.length;"
							.write " if (strcountlength >0 && strlength != strVoteridVal)"
							.write " {"
							.write " if (counter > 0)"
							.write " {"
							.Write "			alert('The Voter ID  No, " & varWrongValue & ", Already Exist. For " & Party_code & " Party');"
							.Write "			window.parent.window.document.frmAddClientMin.txtVoterIDNo.select();"
							.Write " }"
							.Write " }"

			  Case "SEBIREGNNO"
							.Write " counter='" & objRS("count") & "';"
							.write " var  strlength = window.parent.window.document.frmAddClientMin.	txtSEBIRegnNo.value; "
							.write " var  strPanNoVal = window.parent.window.document.frmAddClientMin.	txthdnSEBIRegnNo.value; "
							.write " strcountlength = strlength.length;"
							.write " if ((strcountlength >0 && strlength != strPanNoVal)) "
							.write " {"
							.write "		if (counter > 0)"
							.write "   {"
							.Write "			alert('Please Enter Valid Sabi Regn. No....');"
							.Write "			window.parent.window.document.frmAddClientMin.txtSEBIRegnNo.select();"
							.Write "	}"
							.Write " }"

			  Case "DPID-1"
							.Write "					alert('The Entered DPID-1, " & varWrongValue & ", Already Exist. For " & Party_code & " Party');"
							.Write "					window.parent.frmAddClientMin.txtDPIDOpt000.select();"
							
			  Case "DPID-11"
							.Write "					alert('The Entered DPID-1, " & varWrongValue & ", Not Exist.');"
							.Write "					window.parent.frmAddClientMin.txtDPIDOpt000.select();"
							
			  Case "DPID-12"
							.Write "					alert('The Entered DPID-2, " & varWrongValue & ", Not Exist.');"
							.Write "					window.parent.frmAddClientMin.txtDPIDOpt001.select();"
							
			  Case "DPID-13"
							.Write "					alert('The Entered DPID-3, " & varWrongValue & ", Not Exist.');"
							.Write "					window.parent.frmAddClientMin.txtDPIDOpt002.select();"														
							
			  Case "DPID-2"
							.Write "					alert('The Entered DPID-2, " & varWrongValue & ", Already Exist. For " & Party_code & " Party');"
							.Write "					window.parent.frmAddClientMin.txtDPIDOpt001.select();"
							
			  Case "DPID-3"
							.Write "					alert('The Entered DPID-3, " & varWrongValue & ", Already Exist. For " & Party_code & " Party');"
							.Write "					window.parent.frmAddClientMin.txtDPIDOpt002.select();"
										

			End Select	
					.Write " if (window.parent.frmAddClientMin.hdntxtClientType.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtClientType.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdntxtState.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtState.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdntxtClientStatus.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtClientStatus.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdntxtDepositoryOpt000.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtDepositoryOpt000.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdntxtDepositoryOpt001.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtDepositoryOpt001.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdntxtDepositoryOpt002.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtDepositoryOpt002.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdntxtACType.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtACType.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdntxtSex.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtSex.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdntxtInteractionMode.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtInteractionMode.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdntxtSettMode.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtSettMode.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdntxtOtherTM.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.txtOtherTM.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdnchkCorporateDetails.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.chkCorporateDetails.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdnchkNetworthCertification.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.chkNetworthCertification.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdnchkAnnualReport.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.chkAnnualReport.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdnchkBankCertificate.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.chkBankCertificate.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdnchkCorporateDeed.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.chkCorporateDeed.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdnchkKYCForm.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.chkKYCForm.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdnchkPOAOpt000.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.chkPOAOpt000.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdnchkPOAOpt001.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.chkPOAOpt001.disabled = true;"
					.Write " }"
					.Write " if (window.parent.frmAddClientMin.hdnchkPOAOpt002.value !='')"
					.Write " {"
					.Write "   window.parent.frmAddClientMin.chkPOAOpt002.disabled = true;"
					.Write " }"

			.Write "					window.parent.frmAddClientMin.btnSubmit.disabled = false;"
			.Write "					window.parent.frmAddClientMin.btnCancel.disabled = false;"


			.Write "				</script>"
			WriteHTMLBody
			WriteHTMLFooter
			.End
		End With
	End Function		'Private Function WriteMissingError (varWhatIsWrong, varWrongValue)

	Private Sub WriteHTMLHeader
		With Response
			.Write "	<html>"
			.Write "		<head>"
			.Write "			<meta http-equiv=""expires"" content=""-100"">"
			.Write "				<link href=""/aspdepend/css/consol_new.css"" type=""text/css"" rel=""stylesheet"">"
		End With
	End Sub		'Private WriteHTMLHeader

	Private Sub WriteHTMLSuccessBody()
		With Response
			.Write "				<script language=""javascript"">"
			.Write "					function sendvalues()"
			.Write "					{"
			.Write "						alert('" & stralert & "');"
 			.Write "							window.parent.document.location = 'client_module_start.asp?strMessage=Party Code "& Request.form("txtPartyCode") & " " & strMessage & "' ;"
 			.Write "					}"
			.Write "				</script>"
		End With
	End Sub

	Private Sub WriteHTMLBody()
		With Response
			.Write "				<script language=""javascript"">"
			.Write "					function sendvalues()"
			.Write "					{"
			.Write "					}"
			.Write "				</script>"
		End With
	End Sub

	Private Sub WriteHTMLFooter
		With Response
			.Write "			<body onload=""javascript:sendvalues();"">"
			.Write "			</body>"
			.Write "		</html>"
		End With
	End Sub		'Private WriteHTMLFooter

%>
*/

GO
