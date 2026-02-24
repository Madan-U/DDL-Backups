-- Object: PROCEDURE dbo.rpt_VBB_Broktabledetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE  Proc rpt_VBB_Broktabledetails
	(
	@PARTYCODE VARCHAR(15)
	)

	As

	If (Select Count(1) From Sysobjects Where Name ='Scheme_Mapping') > 0
	Begin

		Set NoCount On
		Set Transaction Isolation Level Read Uncommitted 
		
		Select  
		SchemeDt = left(SP_Date_From,11) + ' -  ' + left(SP_Date_to,11),
		SchemeId = SP_Scheme_Id,
		SchemeDesc = IsNull(SM_Scheme_Desc,''),
		SchemeType = Case 
				When SP_Trd_Type='TRD' Then 'Normal Trade' 
				When SP_Trd_Type='DEL' Then 'Delivery Trade' 
				Else '' End,
		Symbol = Sp_Scrip , 
		ComputationType = case SP_Brok_ComputeType when  'I' then 'Incremental' else 'Variable' end,
		BrokComputeOn = Case When SP_Brok_ComputeOn ='T' Then 'Turnover' Else
					Case When SP_Brok_ComputeOn ='Q' Then 'Quantity' Else
					Case When SP_Brok_ComputeOn ='L' Then 'Lot Size' Else
					'Value Of Lot' End End End ,
		ComputationLevel = Case When Sp_Computation_Level ='T' Then 'Trades' Else
					Case When Sp_Computation_Level ='O' Then 'Order' Else
					Case When Sp_Computation_Level ='S' Then 'Scrip' Else
						'Contract' End End End,
		Scheme = Case When Sp_Scheme_Type=0 then 'Default' else
				 Case When Sp_Scheme_Type=1 then 'Max Logic BS FL' else 
				'Max Logic SS FL' end end,
		ValueRange = convert(varchar,sp_value_from) + ' - ' + case when sp_value_to = -1 then 'Un Limit' else
			convert(varchar,sp_value_to) end,
		Brok = 'Buy ' + convert(varchar,sp_buy_brok) + Case when sp_buy_brok_type ='V' then ' Value' else ' Perc' end  +
			' Sell ' + convert(varchar,sp_sell_brok) + Case when sp_sell_brok_type ='V' then ' Value' else ' Perc' end,
	
		ScrOrd = case when SP_Scrip='ALL' then 1 else 2 end,
		RCount = 1
		From Scheme_Mapping MP Left Outer Join Scheme_Master MS on (SM_Scheme_Id = SP_Scheme_Id)
		Where SP_Party_Code = @PARTYCODE
		Order By 1,3,ScrOrd
	
	End
	Else
	Begin
		Select
		RCount = 0
	End

GO
