-- Object: PROCEDURE dbo.rpt_VBB_Scheme_Mapping
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Procedure  [dbo].[rpt_VBB_Scheme_Mapping]

   @Date_Frm Varchar(12),
   @Party_Frm Varchar(20),
   @Party_To Varchar(20),
   @Instru_type Varchar(5),
   @SP_Scrip Varchar(10),
   @scheme_type Varchar(8)


AS

	if @Party_To = '' begin set @Party_To = 'zzzzz' end
	if @SP_Scrip = '' begin set @SP_Scrip = 'ALL' end

   set transaction isolation level read uncommitted

Select 

   SP_Party_Code,
   Long_Name,
   SP_Computation_Level = case when SP_Computation_Level = 'T' then 'Trade' 
                               when SP_Computation_Level = 'O' then 'Order'
                               when SP_Computation_Level = 'S' then 'Scrip'
                               when SP_Computation_Level = 'C' then 'Contract'
                             end, 
   SP_Inst_Type,
   SP_Scrip,
   SP_Scheme_Id,
   SP_Trd_Type,
   SP_Scheme_Type = case when SP_Scheme_Type = '0' then 'Default'
                         when SP_Scheme_Type = '1' then 'Max BuyFL'
                         when SP_Scheme_Type = '3' then 'Max SellFL'
                        end,
   SP_Multiplier,
   SP_Buy_Brok_Type = case when SP_Buy_Brok_Type='P' then '%' else 'V' end,
   SP_Sell_Brok_Type  = case when SP_Sell_Brok_Type='P' then '%' else 'V' end,
   SP_Buy_Brok,
   SP_Sell_Brok,
   SP_Value_From,
   SP_Value_To,
   SP_TurnOverOn,
   SP_Brok_ComputeOn = case when SP_Brok_ComputeOn = 'v' then 'Value Of Lot' 
                           when SP_Brok_ComputeOn = 'L' then 'Lot Size'
                           when SP_Brok_ComputeOn = 'Q' then 'Quantity'
                           when SP_Brok_ComputeOn = 'T' then 'Turn Over'
                        end,
   SP_Brok_ComputeType = case when SP_Brok_ComputeType = 'V' then 'Variable' 
                             when SP_Brok_ComputeType = 'I' then 'Incremental' 
                        end,
   SP_Min_BrokAmt,
   SP_Max_BrokAmt,
   SP_Min_ScripAmt,
   SP_Max_ScripAmt,
   SP_Date_From = convert(varchar,SP_Date_From,106),
   SP_Date_To   = convert(varchar,SP_Date_To,106)

  From 
        Scheme_Mapping(nolock) , Client1(nolock) , client2(nolock)
 
 Where
      client1.cl_code= client2.cl_code and client2.party_code = sp_party_code 
      AND @Date_Frm BETWEEN  SP_Date_From AND SP_Date_To + ' 23:29'
      AND SP_Party_Code BETWEEN @Party_Frm AND @Party_To
      AND  1 = Case 
					When @instru_type = 'BOTH' 
					Then
						1
					Else 
						Case When SP_Inst_Type = @instru_type then 1 else 2 End
					End 
      AND 1 = Case 
					When @scheme_type = 'ALL' 
					Then
						1
					Else 
						Case When SP_Trd_Type = @scheme_type then 1 else 2 End
					End 

      AND SP_Scrip = @SP_Scrip

  Order By

        SP_Party_Code,
        SP_Date_From,
        SP_Inst_Type,
        SP_Trd_Type, 
        SP_Scrip,
        SP_Value_From

GO
