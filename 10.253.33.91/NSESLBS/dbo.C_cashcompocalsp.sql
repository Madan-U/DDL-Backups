-- Object: PROCEDURE dbo.C_cashcompocalsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_cashcompocalsp
@exchange Varchar(3),
@segment Varchar(20),
@party_code Varchar(10),
@cl_type Varchar(4),
@effdate Varchar(11)
As

Select Cash = Isnull(( Select Cash From Cashcomposition Where Party_code = @party_code And Exchange = @exchange 
		And Segment = @segment And Client_type = ''  And Active = 1	And Effdate = (select Max(effdate) From Cashcomposition 
		Where Effdate <= @effdate + ' 23:59' And Party_code = @party_code And Client_type = '' And Exchange = @exchange 
		And Segment = @segment  And Active = 1)),
			Isnull(( Select Cash From Cashcomposition Where Party_code = '' And Exchange = @exchange 
			And Segment = @segment And Client_type = @cl_type  And Active = 1 And Effdate = (select Max(effdate) From Cashcomposition 
			Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = @cl_type And Exchange = @exchange 
			And Segment = @segment  And Active = 1)),
				Isnull(( Select Cash From Cashcomposition Where Party_code = '' And Exchange = @exchange 
				And Segment = @segment And Client_type = ''  And Active = 1 And Effdate = (select Max(effdate) From Cashcomposition 
				Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = '' And Exchange = @exchange 
				And Segment = @segment  And Active = 1)),0)
			)
		),
Noncash =  Isnull(( Select Noncash From Cashcomposition Where Party_code = @party_code And Exchange = @exchange 
		And Segment = @segment And Client_type = ''  And Active = 1	And Effdate = (select Max(effdate) From Cashcomposition 
		Where Effdate <= @effdate + ' 23:59' And Party_code = @party_code And Client_type = '' And Exchange = @exchange 
		And Segment = @segment  And Active = 1)),
			Isnull(( Select Noncash From Cashcomposition Where Party_code = '' And Exchange = @exchange 
			And Segment = @segment And Client_type = @cl_type  And Active = 1 And Effdate = (select Max(effdate) From Cashcomposition 
			Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = @cl_type And Exchange = @exchange 
			And Segment = @segment  And Active = 1)),
				Isnull(( Select Noncash From Cashcomposition Where Party_code = '' And Exchange = @exchange 
				And Segment = @segment And Client_type = ''  And Active = 1 And Effdate = (select Max(effdate) From Cashcomposition 
				Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = '' And Exchange = @exchange 
				And Segment = @segment  And Active = 1)),0)
			)
		)

GO
