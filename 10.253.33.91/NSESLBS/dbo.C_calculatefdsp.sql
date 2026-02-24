-- Object: PROCEDURE dbo.C_calculatefdsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Procedure C_calculatefdsp(@exchange Varchar(3), @segment Varchar(20),@party_code Varchar(10),@cl_type Varchar(3),@effdate Varchar(11), @totalfdamount Money Output,	
					@totnoncash Money Output, @totcash Money Output, @orgtotcash Money Output, @orgtotnoncash Money Output)
As
Declare 
@@get Cursor,
@@getfd Cursor,
@@bank_code Varchar(20),
@@fdamount	Money,
@@fd_type Varchar(1),
@@balance Money,
@@haircut Money,
@@cashcompo	 Money,
@@noncashcompo Money,
@@cashncash Varchar(1),
@@instrutype  Varchar(6),
@@fdr_no Varchar(20),
@@maturity_dt Varchar(11),
@@receive_dt Varchar(11),
@@orgcashncash Money,
@@totalfdamount Money,	
@@totnoncash Money,
@@totcash	Money,
@@orgtotcash Money,
@@orgtotnoncash Money

	Set @@fdamount  	= 0	
	Set @@balance 	= 0	
	Set @@haircut 		= 0	
	Set @@cashcompo	= 0
	Set @@noncashcompo = 0		
	Set @@balance	= 0			
	Set @@orgtotcash	= 0
	Set @@orgtotnoncash	= 0
	Set @@totnoncash 	= 0
	Set @@totcash	= 0	
	Set @@totalfdamount 	= 0
	Set @totalfdamount 	= 0	
	Set @totnoncash 	= 0 
	Set @totcash 		= 0 
	Set @orgtotcash 	= 0
	Set @orgtotnoncash 	= 0

	/* Calculation For Fd*/		
	Set @@instrutype  = 'fd'	
	Set @@get = Cursor For
		Select Cn = Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = @party_code And Exchange = @exchange 
		And Segment = @segment And Client_type = '' And Instru_type Like @@instrutype + '%' And Active = 1
		And Effdate = (select Max(effdate) From Instrutypemst 
		Where Effdate <= @effdate + ' 23:59' And Party_code = @party_code And Client_type = '' And Exchange = @exchange 
		And Segment = @segment And Instru_type Like @@instrutype + '%' And Active = 1)),
			Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange 
			And Segment = @segment And Client_type = @cl_type And Client_type <> '' And Instru_type Like @@instrutype + '%' And Active = 1
			And Effdate = (select Max(effdate) From Instrutypemst 
			Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = @cl_type And Exchange = @exchange 
			And Segment = @segment And Instru_type Like @@instrutype + '%' And Active = 1)),
				Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange 
				And Segment = @segment And Client_type = '' And Instru_type Like @@instrutype + '%' And Active = 1
				And Effdate = (select Max(effdate) From Instrutypemst 
				Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = '' And Exchange = @exchange 
				And Segment = @segment And Instru_type Like @@instrutype + '%' And Active = 1)),'')
			)
		)		
	Open @@get
	Fetch Next From @@get Into @@cashncash
	Close @@get
	Deallocate @@get				
	
	Delete From Msajag.dbo.collateraldetails Where Exchange = @exchange And Segment = @segment And Party_code = @party_code And Effdate Like @effdate + '%' And Coll_type = 'fd'

	Set @@orgcashncash = 0
	
	Set @@getfd = Cursor For				
		--Select Isnull(sum(balance),0) Balance,
		Select Isnull(sum(case when F.Drcr ='D' then F.Fd_Amount else - F.Fd_Amount End),0) Balance,
		 Fm.bank_code, Fm.fd_type, Fm.fdr_no, Fm.receive_date, Fm.maturity_date
		From Fixeddeposittrans F, Fixeddepositmst Fm
		Where F.trans_date = (select Max(f1.trans_date) From Fixeddeposittrans F1
 					Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.fdr_no = F1.fdr_no
		       			And F1.trans_date <=  @effdate + ' 23:59' And F1.branch_code = F1.branch_code)
		And F.party_code = @party_code And Fm.exchange = @exchange And Fm.segment = @segment And F.branch_code = Fm.branch_code
		And Fm.party_code = F.party_code And Fm.bank_code = F.bank_code And Fm.fdr_no = F.fdr_no And Fm.status = 'v' And  Fm.active = 1
		Group By Fm.bank_code, Fm.fd_type, Fm.fdr_no, Fm.receive_date, Fm.maturity_date
	Open @@getfd
	Fetch Next From @@getfd Into @@balance, @@bank_code, @@fd_type, @@fdr_no, @@receive_dt, @@maturity_dt
	While @@fetch_status = 0
	Begin
		Set @@get = Cursor For
			Select Haircut = Isnull((select Haircut From Fdhaircut Where Party_code = @party_code And Bank_code = @@bank_code And 
			 Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Fdhaircut 
			 Where Effdate <= @effdate + ' 23:59' And Party_code = @party_code And Bank_code = @@bank_code And 
			 Exchange = @exchange And Segment = @segment And Active = 1)),
			 Isnull((select Haircut From Fdhaircut Where Party_code = @party_code And Bank_code = '' And Fd_type = @@fd_type And Exchange = @exchange 
				And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Fdhaircut Where Effdate <= @effdate + ' 23:59' 
				And Party_code = @party_code And Bank_code = '' And Fd_type = @@fd_type And Exchange = @exchange And Segment = @segment And Active = 1)),
				Isnull((select Haircut From Fdhaircut Where Party_code = '' And Bank_code = @@bank_code And 
					Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) 
					From Fdhaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
					Bank_code = @@bank_code And Exchange = @exchange And Segment = @segment And Active = 1)),
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
		
		
		Open @@get
		Fetch Next From @@get Into @@haircut
		Close @@get
		Deallocate @@get	
				
		Set @@orgcashncash = @@orgcashncash + @@balance  

		Set @@fdamount = @@balance - ( @@balance * @@haircut/100)
		Set @@totalfdamount = @@totalfdamount + @@fdamount

	
		Insert Into Msajag.dbo.collateraldetails Values(@effdate,@exchange,@segment,@party_code,'','','',0,@@balance,0,@@haircut, @@fdamount, @@cashcompo ,@@noncashcompo,@@receive_dt,@@maturity_dt, 'fd', @cl_type ,'','',getdate(),@@cashncash,'',@@fdr_no,@@bank_code,@@fd_type)
		Set @@haircut 		= 0
		Set @@fdamount 	= 0
		Set @@balance 	= 0
		Fetch Next From @@getfd Into @@balance, @@bank_code  , @@fd_type , @@fdr_no, @@receive_dt, @@maturity_dt
		
	End
	If @@cashncash = 'c'
	Begin
		Set @@totcash = @@totcash + @@totalfdamount
		Set @@orgtotcash = @@orgtotcash + @@orgcashncash  		
	End
	Else If @@cashncash = 'n'
	Begin
		Set @@totnoncash = @@totnoncash + @@totalfdamount
		Set @@orgtotnoncash = @@orgtotnoncash + @@orgcashncash  		
	End 
	Else
	Begin
		Set @@totcash = @@totcash + @@totalfdamount
		Set @@orgtotcash = @@orgtotcash + @@orgcashncash  		
	End

	Set @totcash 		= @@totcash 
	Set @orgtotcash 	= @@orgtotcash 
	Set @totnoncash  	= @@totnoncash 
	Set @orgtotnoncash 	= @@orgtotnoncash 
	Set @totalfdamount 	= @@totalfdamount

	Close @@getfd
	Deallocate @@getfd				
	/* End Of Calculation For Fd*/			
	Select @totalfdamount ,@totcash ,@orgtotcash ,@totnoncash ,@orgtotnoncash

GO
