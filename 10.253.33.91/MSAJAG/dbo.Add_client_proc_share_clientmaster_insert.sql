-- Object: PROCEDURE dbo.Add_client_proc_share_clientmaster_insert
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  Proc Add_client_proc_share_clientmaster_insert As
Insert Into Clientmaster 
		Select
			C1.cl_code,party_code,short_name,long_name,l_address1,l_address2,l_city,l_state,l_nation,l_zip,
			Fax,res_phone1,res_phone2,off_phone1,off_phone2,email,branch_cd,credit_limit,cl_type,cl_status,
			Gl_code,fd_code,family,penalty,confirm_fax,phoneold,l_address3,mobile_pager,pan_gir_no 
		From
			Client1 C1, Client2 C2
		Where
			C1.cl_code = C2.cl_code And Party_code Not In (select Party_code From Clientmaster)


		Insert Into Tmp_client_details_dump
		Select * From Tmp_client_details

		Delete From Tmp_client_details
		Where
			Tmppartycode In (select Party_code From Clientmaster)

		Delete From Tmp_client_details_multiclientdpid
		Where
			Tmppartycode In (select Party_code From Clientmaster)

GO
