-- Object: PROCEDURE dbo.C_CashCompoCalSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*Select The Cash and Non Cash Composition at GlobalLevel/ClientTypeLevel/ Specific Party Level*/

CREATE Proc C_CashCompoCalSp
@Exchange Varchar(3),
@Segment Varchar(20),
@Party_Code varchar(10),
@Cl_Type Varchar(4),
@EffDate varchar(11)
As

Select Cash = isnull(( select Cash from CashComposition where party_code = @Party_code and Exchange = @Exchange 
		and Segment = @Segment and CLient_Type = ''  and Active = 1	and EffDate = (Select max(Effdate) from CashComposition 
		where EffDate <= @EffDate + ' 23:59' and party_code = @party_code and CLient_Type = '' and Exchange = @Exchange 
		and Segment = @Segment  and Active = 1)),
			isnull(( select Cash from CashComposition where party_code = '' and Exchange = @Exchange 
			and Segment = @Segment and CLient_Type = @Cl_Type  and Active = 1 and EffDate = (Select max(Effdate) from CashComposition 
			where EffDate <= @EffDate + ' 23:59' and party_code = '' and CLient_Type = @Cl_Type and Exchange = @Exchange 
			and Segment = @Segment  and Active = 1)),
				isnull(( select Cash from CashComposition where party_code = '' and Exchange = @Exchange 
				and Segment = @Segment and CLient_Type = ''  and Active = 1 and EffDate = (Select max(Effdate) from CashComposition 
				where EffDate <= @EffDate + ' 23:59' and party_code = '' and CLient_Type = '' and Exchange = @Exchange 
				and Segment = @Segment  and Active = 1)),0)
			)
		),
NonCash =  isnull(( select NonCash from CashComposition where party_code = @Party_code and Exchange = @Exchange 
		and Segment = @Segment and CLient_Type = ''  and Active = 1	and EffDate = (Select max(Effdate) from CashComposition 
		where EffDate <= @EffDate + ' 23:59' and party_code = @party_code and CLient_Type = '' and Exchange = @Exchange 
		and Segment = @Segment  and Active = 1)),
			isnull(( select NonCash from CashComposition where party_code = '' and Exchange = @Exchange 
			and Segment = @Segment and CLient_Type = @Cl_Type  and Active = 1 and EffDate = (Select max(Effdate) from CashComposition 
			where EffDate <= @EffDate + ' 23:59' and party_code = '' and CLient_Type = @Cl_Type and Exchange = @Exchange 
			and Segment = @Segment  and Active = 1)),
				isnull(( select NonCash from CashComposition where party_code = '' and Exchange = @Exchange 
				and Segment = @Segment and CLient_Type = ''  and Active = 1 and EffDate = (Select max(Effdate) from CashComposition 
				where EffDate <= @EffDate + ' 23:59' and party_code = '' and CLient_Type = '' and Exchange = @Exchange 
				and Segment = @Segment  and Active = 1)),0)
			)
		)

GO
