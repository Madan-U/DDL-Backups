-- Object: PROCEDURE dbo.C_cashnoncashcalsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  Proc C_cashnoncashcalsp
@exchange Varchar(3),
@segment Varchar(20),
@party_code Varchar(10),
@cl_type Varchar(4),
@effdate Varchar(11),
@instrutype Varchar(4)
As

Select Cn = Isnull(( Select distinct Cash_ncash From Instrutypemst Where Party_code = @party_code And Exchange = @exchange 
		And Segment = @segment And Client_type = '' And Instru_type Like @instrutype + '%' And Active = 1
		And Effdate = (select Max(effdate) From Instrutypemst 
		Where Effdate <= @effdate + ' 23:59' And Party_code = @party_code And Client_type = '' And Exchange = @exchange 
		And Segment = @segment And Instru_type Like @instrutype + '%' And Active = 1)),

			Isnull(( Select distinct Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange 
			And Segment = @segment And Client_type = @cl_type And Client_type <> '' And Instru_type Like @instrutype + '%' And Active = 1
			And Effdate = (select Max(effdate) From Instrutypemst 
			Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = @cl_type And Exchange = @exchange 
			And Segment = @segment And Instru_type Like @instrutype + '%' And Active = 1)),
				Isnull(( Select distinct Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange 
				And Segment = @segment And Client_type = '' And Instru_type Like @instrutype + '%' And Active = 1
				And Effdate = (select Max(effdate) From Instrutypemst 
				Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = '' And Exchange = @exchange 
				And Segment = @segment And Instru_type Like @instrutype + '%' And Active = 1)),'')
			)
		)

GO
