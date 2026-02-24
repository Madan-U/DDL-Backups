-- Object: PROCEDURE dbo.C_fdbghaircutcalsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_fdbghaircutcalsp
@exchange Varchar(3),
@segment Varchar(20),
@party_code Varchar(10),
@bank_code Varchar(20),
@cl_type Varchar(4),
@effdate Varchar(11),
@scrip_cd Varchar(12),
@series Varchar(3),
@group_cd Varchar(20),
@fd_type Varchar(1),
@flag Int
As

If @flag = 1 
Begin
Select Haircut = Isnull((select Haircut From Fdhaircut Where Party_code = @party_code And Bank_code = @bank_code And 
			 Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Fdhaircut 
			 Where Effdate <= @effdate + ' 23:59' And Party_code = @party_code And Bank_code = @bank_code And 
			 Exchange = @exchange And Segment = @segment And Active = 1)),
			 Isnull((select Haircut From Fdhaircut Where Party_code = @party_code And Bank_code = '' And Fd_type = @fd_type And Exchange = @exchange 
				And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Fdhaircut Where Effdate <= @effdate + ' 23:59' 
				And Party_code = @party_code And Bank_code = '' And Fd_type = @fd_type And Exchange = @exchange And Segment = @segment And Active = 1)),
				Isnull((select Haircut From Fdhaircut Where Party_code = '' And Bank_code = @bank_code And 
					Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) 
					From Fdhaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
					Bank_code = @bank_code And Exchange = @exchange And Segment = @segment And Active = 1)),
 					Isnull((select Haircut From Fdhaircut Where Party_code = '' And Bank_code = '' And 
						Client_type = @cl_type And Client_type <> '' And Active = 1 And Exchange = @exchange And Segment = @segment And 
						Effdate = (select Max(effdate) From Fdhaircut Where Effdate <= @effdate + ' 23:59' And 
						Party_code = '' And Bank_code = '' And Client_type = @cl_type And Client_type <> '' And 
						Exchange = @exchange And Segment = @segment And Active = 1)),
							Isnull((select Haircut From Fdhaircut Where Party_code = '' And Bank_code = '' And Client_type = '' And
							Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) 
							From Fdhaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
							Bank_code = ''  And Client_type = '' And Exchange = @exchange And Segment = @segment And Active = 1)),0)
						)
					)
				)
			)
End

If @flag = 2
Begin
Select Haircut = Isnull((select Haircut From Bghaircut Where Party_code = @party_code And Bank_code = @bank_code And 
			 Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Bghaircut 
			 Where Effdate <= @effdate + ' 23:59' And Party_code = @party_code And Bank_code = @bank_code And 
			 Exchange = @exchange And Segment = @segment And Active = 1)),
			 Isnull((select Haircut From Bghaircut Where Party_code = @party_code And Bank_code = '' And Exchange = @exchange 
				And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Bghaircut Where Effdate <= @effdate + ' 23:59' 
				And Party_code = @party_code And Bank_code = '' And Exchange = @exchange And Segment = @segment And Active = 1)),
				Isnull((select Haircut From Bghaircut Where Party_code = '' And Bank_code = @bank_code And 
					Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) 
					From Bghaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
					Bank_code = @bank_code And Exchange = @exchange And Segment = @segment And Active = 1)),
 					Isnull((select Haircut From Bghaircut Where Party_code = '' And Bank_code = '' And 
						Client_type = @cl_type And Client_type <> ''  And Exchange = @exchange And Segment = @segment 
						And Active = 1 And Effdate = (select Max(effdate) From Bghaircut Where Effdate <= @effdate + ' 23:59' And 
						Party_code = '' And Bank_code = '' And Client_type = @cl_type And Client_type <> '' And 
						Exchange = @exchange And Segment = @segment And Active = 1)),
							Isnull((select Haircut From Bghaircut Where Party_code = '' And Bank_code = '' And Client_type = '' 
							And Active = 1 And Exchange = @exchange And Segment = @segment And Effdate = (select Max(effdate) 
							From Bghaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
							Bank_code = ''  And Client_type = ''  And Exchange = @exchange And Segment = @segment And Active = 1)),0)
						)
					)
				)
			)
End

/*changes Done On April 20 2002 Added Series Condition In Third Case.*/

If @flag = 3
Begin
	Select Haircut = Isnull((select Haircut From Securityhaircut Where Party_code = @party_code And Scrip_cd = @scrip_cd And Series = @series And 
			 Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut 
			 Where Effdate <= @effdate + ' 23:59' And Party_code = @party_code And Scrip_cd = @scrip_cd And Series = @series And 
			 Exchange = @exchange And Segment = @segment And Active = 1)),
			 Isnull((select Haircut From Securityhaircut Where Party_code = @party_code And Scrip_cd = '' And Exchange = @exchange 
				And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut Where Effdate <= @effdate + ' 23:59' 
				And Party_code = @party_code And Scrip_cd = '' And Exchange = @exchange And Segment = @segment And Active = 1)),
				Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = @scrip_cd And Series = @series And 
					Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) 
					From Securityhaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
					Scrip_cd = @scrip_cd And Series = @series And Exchange = @exchange And Segment = @segment And Active = 1)),
					Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = '' And 
						Group_cd = @group_cd And Group_cd <> ''  And Exchange = @exchange And Segment = @segment 
						And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut Where Effdate <= @effdate + ' 23:59' And 
						Party_code = '' And Scrip_cd = '' And Group_cd = @group_cd And Group_cd <> '' And 
						Exchange = @exchange And Segment = @segment And Active = 1)),
	 					Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = '' And 
							Client_type = @cl_type And Client_type <> ''  And Exchange = @exchange And Segment = @segment 
							And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut Where Effdate <= @effdate + ' 23:59' And 
							Party_code = '' And Scrip_cd = '' And Client_type = @cl_type And Client_type <> '' And 
							Exchange = @exchange And Segment = @segment And Active = 1)),
								Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = '' And Client_type = '' And Group_cd = ''
								And Active = 1 And Exchange = @exchange And Segment = @segment And Effdate = (select Max(effdate) 
								From Securityhaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
								Scrip_cd = ''  And Client_type = ''  And Group_cd = '' And Exchange = @exchange And Segment = @segment And Active = 1)),0)
							)
						)
					)
				)
			)
End

GO
