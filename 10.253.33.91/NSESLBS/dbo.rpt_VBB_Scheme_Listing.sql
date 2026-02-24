-- Object: PROCEDURE dbo.rpt_VBB_Scheme_Listing
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Procedure  [dbo].[rpt_VBB_Scheme_Listing]

   @Scheme_Type varchar(3),
   @Computation_Type varchar(3)

AS
   set transaction isolation level read uncommitted

Select 

     SM_Scheme_ID,
     SM_Scheme_Desc, 
     SM_ComputationOn = case when SM_ComputationOn = 'v' then 'Value Of Lot' 
                             when SM_ComputationOn = 'T' then 'TurnOver'
                             when SM_ComputationOn = 'Q' then 'Quantity'
                             when SM_ComputationOn = 'L' then 'Lot Size'
                             end,
     SM_ComputationType = case when SM_ComputationType = 'V' then 'Variable'
                               when SM_ComputationType = 'I' then 'Incremental'
                               end,
     SM_Trd_Type,
     SM_TurnOverOn,
     SM_Value_From,
     SM_Value_To,
     SM_Res_Multiplier,
     SM_Buy_Brok_Type,
     SM_Sell_Brok_Type,
     SM_Buy_Brok,
     SM_Sell_Brok 

From 
     Scheme_master 

Where
	1 = Case 
		When @Scheme_Type = 'ALL' 
		Then 1
		Else 
			Case When SM_Trd_Type = @Scheme_Type then 1 else 2 End
		End AND					
	1 = Case 
		When @Computation_Type = 'ALL' 
		Then 1
		Else 
			Case When SM_ComputationType = @Computation_Type then 1 else 2 end
		End

  Order By 
         SM_Scheme_ID,
         SM_Value_From

GO
