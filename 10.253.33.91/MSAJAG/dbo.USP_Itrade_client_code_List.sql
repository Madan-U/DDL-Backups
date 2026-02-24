-- Object: PROCEDURE dbo.USP_Itrade_client_code_List
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--exec USP_Itrade_client_code_List
	CREATE proc USP_Itrade_client_code_List

	AS
	BEGIN 

		select distinct  cl_code into #client_code from client_details

		Select distinct sp_party_code into #ItradeClient from scheme_mapping (NOLOCK)
		where SP_Date_To >getdate() and sp_computation_level ='O' 

		select * into #customplan_21 from #client_code a left join #ItradeClient b
		on a.cl_code = b.sp_party_code
		where b.sp_party_code is null

		select b.*,a.b2c into #final_Custon_plan from [INTRANET].risk.dbo.client_details a inner join  #customplan_21 b 
		on a.cl_code = b.cl_code 
		where a.b2c ='N'

		select * from #final_Custon_plan 


	END

GO
