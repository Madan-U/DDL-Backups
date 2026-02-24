-- Object: PROCEDURE dbo.C_collateralcalculationsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Procedure C_collateralcalculationsp(@exchange Varchar(3), @segment Varchar(20),@fromparty Varchar(10), @toparty Varchar(10),@effdate Varchar(11),@status Int Output)
As
Declare @@cur  Cursor,
@@get Cursor,
@@getfdbg Cursor,
@@getclrate Cursor,
@@party_code Varchar(15),
@@cl_type Varchar(3),
@@cl_rate Money,
@@tcode Int,
@@vdate Varchar(11),
@@scrip_cd Varchar(12),
@@bank_code Varchar(20),
@@series Varchar(3),
@@isin Varchar(20),
@@qty Int,
@@fdamount	Money,
@@balance Money,
@@bgamount	Money,
@@marginamt	Money,
@@haircut Money,
@@totnoncash Money,
@@totcash	Money,
@@actualnoncash Money,
@@actualcash	Money,
@@secamount	Money,
@@totalsecamount Money,
@@totalfdamount Money,	
@@totalbgamount Money,
@@cashcompo	 Money,
@@noncashcompo Money,
@@cashncash Varchar(1),
@@instrutype  Varchar(6),
@@fdr_no Varchar(20),
@@bg_no Varchar(20),
@@fd_type Varchar(1),
@@maturity_dt Varchar(11),
@@receive_dt Varchar(11),
@@camt Money,
@@damt Money,
@@drcr Varchar(1),
@@group_cd Varchar(20),
@@totalcashnoncash  Money,
@@actualnoncash1 Money,
@@effectivecoll Money,
/* Added On 21/03/2002*/
@@orgcashncash Money,			
@@orgtotcash Money,
@@orgtotnoncash Money,
@@indicator Varchar(6),
@@checkparty Cursor,
@@partyfound Varchar(10)


Set @status = 0


Set @@cur = Cursor For	
	Select Distinct F.party_code,  Isnull(cl_type,'cli')  From Fixeddepositmst F, Clientmaster C   Where F.party_code >= @fromparty 
	And F.party_code <= @toparty And Exchange = @exchange And Segment = @segment And F.party_code = C.party_code
Union
    	Select Distinct F.party_code, Isnull(cl_type,'cli')  From Bankguaranteemst F , Clientmaster C  
	Where F.party_code >= @fromparty And F.party_code <= @toparty And Exchange = @exchange 
	And Segment =@segment And F.party_code = C.party_code
Union
	Select Distinct F.party_code , Isnull(cl_type,'cli')  From C_securitiesmst F, Clientmaster C  Where F.party_code <> 'broker' And Filler11 = 'party' 
	And F.party_code >= @fromparty And F.party_code <= @toparty And Exchange = @exchange And Segment =@segment And F.party_code = C.party_code
Union 
	Select Distinct  F.party_code , Isnull(cl_type,'cli')   From C_marginledger F, Clientmaster C 
    	Where F.party_code >=@fromparty And F.party_code <= @toparty And F.party_code = C.party_code Order By F.party_code

Open @@cur
Fetch Next From @@cur Into @@party_code, @@cl_type
While @@fetch_status = 0
Begin
	Set @@fdamount  	= 0	
	Set @@balance 	= 0
	Set @@bgamount	= 0
	Set @@marginamt	= 0
	Set @@haircut 		= 0
	Set @@totnoncash 	= 0
	Set @@totcash	= 0
	Set @@actualnoncash 	= 0
	Set @@actualcash	= 0
	Set @@secamount	= 0
	Set @@totalsecamount= 0
	Set @@totalfdamount 	= 0
	Set @@totalbgamount = 0
	Set @@cashcompo	= 0
	Set @@noncashcompo = 0
	Set @@cl_rate 		= 0
	Set @@qty		= 0
	Set  @@haircut		= 0
	Set @@balance	= 0
	Set @@orgcashncash	= 0					
	Set @@orgtotcash	= 0
	Set @@orgtotnoncash	= 0	/*set @@cl_type 	= ''*/
				
	/* Get Cash And Noncash Composition*/
	Set @@get = Cursor For
		Select Cash = Isnull(( Select Cash From Cashcomposition Where Party_code = @@party_code And Exchange = @exchange 
		And Segment = @segment And Client_type = ''  And Active = 1	And Effdate = (select Max(effdate) From Cashcomposition 
		Where Effdate <= @effdate + ' 23:59' And Party_code = @@party_code And Client_type = '' And Exchange = @exchange 
		And Segment = @segment  And Active = 1)),
			Isnull(( Select Cash From Cashcomposition Where Party_code = '' And Exchange = @exchange 
			And Segment = @segment And Client_type = @@cl_type  And Active = 1 And Effdate = (select Max(effdate) From Cashcomposition 
			Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = @@cl_type And Exchange = @exchange 
			And Segment = @segment  And Active = 1)),
				Isnull(( Select Cash From Cashcomposition Where Party_code = '' And Exchange = @exchange 
				And Segment = @segment And Client_type = ''  And Active = 1 And Effdate = (select Max(effdate) From Cashcomposition 
				Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = '' And Exchange = @exchange 
				And Segment = @segment  And Active = 1)),0)
			)
		),
		Noncash =  Isnull(( Select Noncash From Cashcomposition Where Party_code = @@party_code And Exchange = @exchange 
		And Segment = @segment And Client_type = ''  And Active = 1	And Effdate = (select Max(effdate) From Cashcomposition 
		Where Effdate <= @effdate + ' 23:59' And Party_code = @@party_code And Client_type = '' And Exchange = @exchange 
		And Segment = @segment  And Active = 1)),
			Isnull(( Select Noncash From Cashcomposition Where Party_code = '' And Exchange = @exchange 
			And Segment = @segment And Client_type = @@cl_type  And Active = 1 And Effdate = (select Max(effdate) From Cashcomposition 
			Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = @@cl_type And Exchange = @exchange 
			And Segment = @segment  And Active = 1)),
				Isnull(( Select Noncash From Cashcomposition Where Party_code = '' And Exchange = @exchange 
				And Segment = @segment And Client_type = ''  And Active = 1 And Effdate = (select Max(effdate) From Cashcomposition 
				Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = '' And Exchange = @exchange 
				And Segment = @segment  And Active = 1)),0)
			)
		)

	Open @@get
	Fetch Next From @@get Into @@cashcompo, @@noncashcompo 	
	Close @@get
	Deallocate @@get		
	/* End Of Get Cash And Noncash Composition*/

Set @@checkparty = Cursor For
		Select Party_code From C_marginledger Where Party_code = @@party_code
	Open @@checkparty 
	Fetch Next From @@checkparty Into @@partyfound
	If @@fetch_status = 0
	Begin	

		Set @@marginamt  = 0
		Delete From Msajag.dbo.collateraldetails Where Exchange = @exchange And Segment = @segment And Party_code = @@party_code 
		And Left(convert(varchar,effdate,109),11)  =  @effdate  And Coll_type = 'margin'

		/*get The Margin Amount As A Cash*/		
		Set @@get = Cursor For
			Select Bal = Isnull((sum(damt) - Sum(camt)),0) From C_marginledger Where Party_code = @@party_code
			Group By Party_code
		Open @@get
		Fetch Next From @@get Into @@marginamt
		If @@fetch_status = 0
		Begin	
			Set @@totcash = @@totcash + @@marginamt   		
		End
		Close @@get
		Deallocate @@get		
		If @@marginamt > 0 
		Begin
			Set @@orgtotcash = @@orgtotcash + @@marginamt 

			 Insert Into Msajag.dbo.collateraldetails Values(@effdate,@exchange,@segment,@@party_code, '','','',0, @@marginamt, 0, 0, @@marginamt ,  @@cashcompo , @@noncashcompo,
			'','', 'margin', @@cl_type,'','',getdate(),'c','','','','')
		End
	End
	/*end Of Get The Margin Amount As A Cash*/		
Close @@checkparty
Deallocate @@checkparty	


/* Calculation For Fd*/		
	Set @@checkparty = Cursor For
		Select Party_code From Fixeddepositmst Where Party_code = @@party_code
	Open @@checkparty 
	Fetch Next From @@checkparty Into @@partyfound
	If @@fetch_status = 0
	Begin		
		Set @@instrutype  = 'fd'	
		Set @@get = Cursor For
			Select Cn = Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = @@party_code And Exchange = @exchange 
			And Segment = @segment And Client_type = '' And Instru_type = @@instrutype  And Active = 1
			And Effdate = (select Max(effdate) From Instrutypemst 
			Where Effdate <= @effdate + ' 23:59' And Party_code = @@party_code And Client_type = '' And Exchange = @exchange 
			And Segment = @segment And Instru_type = @@instrutype  And Active = 1)),
				Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange 
				And Segment = @segment And Client_type = @@cl_type And Client_type <> '' And Instru_type = @@instrutype  And Active = 1
				And Effdate = (select Max(effdate) From Instrutypemst 
				Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = @@cl_type And Exchange = @exchange 
				And Segment = @segment And Instru_type = @@instrutype And Active = 1)),
					Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange 
					And Segment = @segment And Client_type = '' And Instru_type = @@instrutype  And Active = 1
					And Effdate = (select Max(effdate) From Instrutypemst 
					Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = '' And Exchange = @exchange 
					And Segment = @segment And Instru_type = @@instrutype  And Active = 1)),'')
				)
			)		
		Open @@get
		Fetch Next From @@get Into @@cashncash
		Close @@get
		Deallocate @@get				
		
		Set @@orgcashncash = 0
		
		Delete From Msajag.dbo.collateraldetails Where Exchange = @exchange And Segment = @segment And Party_code = @@party_code 
		And Left(convert(varchar,effdate,109),11)  =  @effdate  And Coll_type = 'fd'

		Set @@getfdbg = Cursor For		
			Select Isnull(sum(balance),0) Balance, Fm.bank_code, Fm.fd_type, Fm.fdr_no, Fm.receive_date, Fm.maturity_date
			From Fixeddeposittrans F, Fixeddepositmst Fm
			Where F.trans_date = (select Max(f1.trans_date) From Fixeddeposittrans F1
	 					Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.fdr_no = F1.fdr_no
			       			And F1.trans_date <=  @effdate + ' 23:59' And F1.branch_code = F1.branch_code 
						/*and Left(convert(varchar,fm.receive_date,109),11) = Left(convert(varchar,f1.trans_date,109),11)*/
						And F1.tcode = F.tcode)
			And F.party_code = @@party_code And Fm.exchange = @exchange And Fm.segment = @segment And F.branch_code = Fm.branch_code
			And Fm.party_code = F.party_code And Fm.bank_code = F.bank_code And Fm.fdr_no = F.fdr_no And Fm.status <> 'c' /*and  Fm.active = 1*/ 
			And @effdate + ' 23:59:59' >= Fm.receive_date And @effdate +' 00:00:00' < = Fm.maturity_date  And Fm.tcode = F.tcode
			Group By Fm.bank_code, Fm.fd_type,fm.fdr_no, Fm.receive_date, Fm.maturity_date
	
		Open @@getfdbg
		Fetch Next From @@getfdbg Into @@balance, @@bank_code, @@fd_type, @@fdr_no, @@receive_dt, @@maturity_dt 
		While @@fetch_status = 0
		Begin
			Set @@get = Cursor For
				Select Haircut = Isnull((select Haircut From Fdhaircut Where Party_code = @@party_code And Bank_code = @@bank_code And 
				 Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Fdhaircut 
				 Where Effdate <= @effdate + ' 23:59' And Party_code = @@party_code And Bank_code = @@bank_code And 
				 Exchange = @exchange And Segment = @segment And Active = 1)),
				 Isnull((select Haircut From Fdhaircut Where Party_code = @@party_code And Bank_code = '' And Fd_type = @@fd_type And Exchange = @exchange 
					And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Fdhaircut Where Effdate <= @effdate + ' 23:59' 
					And Party_code = @@party_code And Bank_code = '' And Fd_type = @@fd_type And Exchange = @exchange And Segment = @segment And Active = 1)),
					Isnull((select Haircut From Fdhaircut Where Party_code = '' And Bank_code = @@bank_code And 
						Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) 
						From Fdhaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
						Bank_code = @@bank_code And Exchange = @exchange And Segment = @segment And Active = 1)),
	 					Isnull((select Haircut From Fdhaircut Where Party_code = '' And Bank_code = '' And 
							Client_type = @@cl_type And Client_type <> '' And Active = 1 And Exchange = @exchange And Segment = @segment And 
							Effdate = (select Max(effdate) From Fdhaircut Where Effdate <= @effdate + ' 23:59' And 
							Party_code = '' And Bank_code = '' And Client_type = @@cl_type And Client_type <> '' And 
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
					
			Set @@orgcashncash = @@orgcashncash + @@balance  /*added By Vaishali On 21/03/2002*/
	
			Set @@fdamount = @@balance - ( @@balance * @@haircut/100)	
			Set @@totalfdamount = @@totalfdamount + @@fdamount			

			 Insert Into Msajag.dbo.collateraldetails Values(@effdate,@exchange,@segment,@@party_code,'','','',0,@@balance,0,@@haircut, @@fdamount, @@cashcompo ,@@noncashcompo,
			@@receive_dt,@@maturity_dt, 'fd', @@cl_type ,'','',getdate(),@@cashncash,'',@@fdr_no,@@bank_code,@@fd_type)

			Fetch Next From @@getfdbg Into @@balance, @@bank_code,@@fd_type, @@fdr_no, @@receive_dt, @@maturity_dt 
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
		
		Close @@getfdbg
		Deallocate @@getfdbg				
	End
	Close @@checkparty
	Deallocate @@checkparty	
/* End Of Calculation For Fd*/			

	Set @@orgcashncash = 0

/* Calculation For Bg*/		
	Set @@checkparty = Cursor For
		Select Party_code From Bankguaranteemst Where Party_code = @@party_code
	Open @@checkparty 
	Fetch Next From @@checkparty Into @@partyfound
	If @@fetch_status = 0
	Begin	
		Set @@instrutype  = 'bg'	
		Set @@get = Cursor For
			Select Cn = Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = @@party_code And Exchange = @exchange 
			And Segment = @segment And Client_type = '' And Instru_type = @@instrutype  And Active = 1
			And Effdate = (select Max(effdate) From Instrutypemst 
			Where Effdate <= @effdate + ' 23:59' And Party_code = @@party_code And Client_type = '' And Exchange = @exchange 
			And Segment = @segment And Instru_type = @@instrutype  And Active = 1)),
				Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange 
				And Segment = @segment And Client_type = @@cl_type And Client_type <> '' And Instru_type = @@instrutype  And Active = 1
				And Effdate = (select Max(effdate) From Instrutypemst 
				Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = @@cl_type And Exchange = @exchange 
				And Segment = @segment And Instru_type = @@instrutype And Active = 1)),
					Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange 
					And Segment = @segment And Client_type = '' And Instru_type = @@instrutype  And Active = 1
					And Effdate = (select Max(effdate) From Instrutypemst 
					Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = '' And Exchange = @exchange 
					And Segment = @segment And Instru_type = @@instrutype And Active = 1)),'')
				)
			)		
		Open @@get
		Fetch Next From @@get Into @@cashncash
		Close @@get
		Deallocate @@get				
	
		Delete From Msajag.dbo.collateraldetails Where Exchange = @exchange And Segment = @segment And Party_code = @@party_code 
		And Left(convert(varchar,effdate,109),11)  =  @effdate  And Coll_type = 'bg'

		Set @@getfdbg = Cursor For
			Select Isnull(sum(balance),0) Balance, Fm.bank_code ,fm.bg_no, Fm.receive_date, Fm.maturity_date
			From Bankguaranteetrans F, Bankguaranteemst Fm
			Where F.trans_date = (select Max(f1.trans_date) From Bankguaranteetrans F1
 					       Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.bg_no = F1.bg_no
					       And F1.trans_date <=  @effdate + ' 23:59' And F1.branch_code = F1.branch_code 
					       /*and Left(convert(varchar,fm.receive_date,109),11) = Left(convert(varchar,f1.trans_date,109),11)*/
					       And F1.tcode = F.tcode)
			And F.party_code = @@party_code And Fm.exchange = @exchange And Fm.segment = @segment And F.branch_code = Fm.branch_code
			And Fm.party_code = F.party_code And Fm.bank_code = F.bank_code And Fm.bg_no = F.bg_no And Fm.status <> 'c' /*and  Fm.active = 1*/
			And @effdate +' 23:59:59' >= Fm.receive_date And @effdate +' 00:00:00' <= Fm.maturity_date And Fm.tcode = F.tcode
			Group By Fm.bank_code, Fm.bg_no, Fm.receive_date, Fm.maturity_date		
			
		Open @@getfdbg
		Fetch Next From @@getfdbg Into @@balance, @@bank_code, @@bg_no, @@receive_dt, @@maturity_dt 
		While @@fetch_status = 0
		Begin
			Set @@get = Cursor For
				Select Haircut = Isnull((select Haircut From Bghaircut Where Party_code = @@party_code And Bank_code = @@bank_code And 
				 Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Bghaircut 
				 Where Effdate <= @effdate + ' 23:59' And Party_code = @@party_code And Bank_code = @@bank_code And 
				 Exchange = @exchange And Segment = @segment And Active = 1)),
				 Isnull((select Haircut From Bghaircut Where Party_code = @@party_code And Bank_code = '' And Exchange = @exchange 
					And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Bghaircut Where Effdate <= @effdate + ' 23:59' 
					And Party_code = @@party_code And Bank_code = '' And Exchange = @exchange And Segment = @segment And Active = 1)),
					Isnull((select Haircut From Bghaircut Where Party_code = '' And Bank_code = @@bank_code And 
						Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) 
						From Bghaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
						Bank_code = @@bank_code And Exchange = @exchange And Segment = @segment And Active = 1)),
 						Isnull((select Haircut From Bghaircut Where Party_code = '' And Bank_code = '' And 
							Client_type = @@cl_type And Client_type <> ''  And Exchange = @exchange And Segment = @segment 
							And Active = 1 And Effdate = (select Max(effdate) From Bghaircut Where Effdate <= @effdate + ' 23:59' And 
							Party_code = '' And Bank_code = '' And Client_type = @@cl_type And Client_type <> '' And 
							Exchange = @exchange And Segment = @segment And Active = 1)),
								Isnull((select Haircut From Bghaircut Where Party_code = '' And Bank_code = '' And Client_type = '' 
								And Active = 1 And Exchange = @exchange And Segment = @segment And Effdate = (select Max(effdate) 
								From Bghaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
								Bank_code = ''  And Client_type = ''  And Exchange = @exchange And Segment = @segment And Active = 1)),0)
							)
						)
					)
				)
			
			Open @@get
			Fetch Next From @@get Into @@haircut
			Close @@get
			Deallocate @@get	

			Set @@orgcashncash = @@orgcashncash + @@balance 

			Set @@bgamount = @@balance - ( @@balance * @@haircut/100)	
			Set @@totalbgamount = @@totalbgamount + @@bgamount

			 Insert Into Msajag.dbo.collateraldetails Values(@effdate,@exchange,@segment,@@party_code,'','','',0,@@balance,0,@@haircut, @@bgamount, @@cashcompo ,@@noncashcompo,
			@@receive_dt,@@maturity_dt, 'bg', @@cl_type ,'','',getdate(),@@cashncash,'',@@bg_no,@@bank_code,'b')

			Fetch Next From @@getfdbg Into @@balance, @@bank_code, @@bg_no, @@receive_dt, @@maturity_dt 
		End
		If @@cashncash = 'c'
		Begin
			Set @@totcash = @@totcash + @@totalbgamount
			Set @@orgtotcash = @@orgtotcash + @@orgcashncash  
		End
		Else If @@cashncash = 'n'
		Begin
			Set @@totnoncash = @@totnoncash + @@totalbgamount
			Set @@orgtotnoncash = @@orgtotnoncash + @@orgcashncash  
		End 
		Else
		Begin
			Set @@totcash = @@totcash + @@totalbgamount
			Set @@orgtotcash = @@orgtotcash + @@orgcashncash 
		End
		Close @@getfdbg
		Deallocate @@getfdbg						
	End
	Close @@checkparty
	Deallocate @@checkparty	
/*end Of Calculation For Bg*/		
	
	Set @@orgcashncash  = 0
	
/* Calculation For Sec*/		
	Set @@checkparty = Cursor For
		Select Party_code From C_securitiesmst Where Party_code = @@party_code
	Open @@checkparty 
	Fetch Next From @@checkparty Into @@partyfound
	If @@fetch_status = 0
	Begin	
		Set @@instrutype  = 'sec'	
		/*take Cashnoncah*/
		Set @@get = Cursor For
			Select Cn = Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = @@party_code And Exchange = @exchange 
			And Segment = @segment And Client_type = '' And Instru_type = @@instrutype And Active = 1
			And Effdate = (select Max(effdate) From Instrutypemst 
			Where Effdate <= @effdate + ' 23:59' And Party_code = @@party_code And Client_type = '' And Exchange = @exchange 
			And Segment = @segment And Instru_type = @@instrutype And Active = 1)),
				Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange 
				And Segment = @segment And Client_type = @@cl_type And Client_type <> '' And Instru_type = @@instrutype  And Active = 1
				And Effdate = (select Max(effdate) From Instrutypemst 
				Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = @@cl_type And Exchange = @exchange 
				And Segment = @segment And Instru_type = @@instrutype  And Active = 1)),
					Isnull(( Select Cash_ncash From Instrutypemst Where Party_code = '' And Exchange = @exchange 
					And Segment = @segment And Client_type = '' And Instru_type = @@instrutype  And Active = 1
					And Effdate = (select Max(effdate) From Instrutypemst 
					Where Effdate <= @effdate + ' 23:59' And Party_code = '' And Client_type = '' And Exchange = @exchange 
					And Segment = @segment And Instru_type = @@instrutype  And Active = 1)),'')
				)
			)		
		Open @@get
		Fetch Next From @@get Into @@cashncash
		Close @@get
		Deallocate @@get				
		
		Delete From Msajag.dbo.collateraldetails Where Exchange = @exchange And Segment = @segment And Party_code = @@party_code 
		And Left(convert(varchar,effdate,109),11)  =  @effdate  And Coll_type = 'sec'

		Set @@getfdbg = Cursor For
			Select Balqty = Sum(crqty) - Sum(drqty), Scrip_cd, Series, Isin 
			From C_calculatesecviewnew
			Where Party_code = @@party_code And Effdate <= @effdate + ' 23:59:59' And Exchange = @exchange And Segment =  @segment
			Group By Scrip_cd,series, Isin		
			
		Open @@getfdbg
		Fetch Next From @@getfdbg Into @@qty, @@scrip_cd, @@series, @@isin
		While @@fetch_status = 0
		Begin		
			/*take The Group Code*/
			Set @@get = Cursor For	
				Select Distinct Group_code  From Groupmst Where Scrip_cd = @@scrip_cd And Series Like @@series + '%'
				And Exchange = @exchange And Segment = @segment And Active = 1
				And Effdate = (select Max(effdate) From Groupmst   Where Scrip_cd = @@scrip_cd And Series Like @@series + '%'
			             And Exchange = @exchange And Segment = @segment
		     	             And Effdate <= @effdate + ' 23:59:59' And Active = 1)
			Open @@get
			Fetch Next From @@get Into @@group_cd
			Close @@get
			Deallocate @@get

			/*take The Closing Rate */
			Set @@getclrate = Cursor For
				Select Isnull(cl_rate,0) Cl_rate From C_valuation Where Scrip_cd = @@scrip_cd  And Series Like @@series + '%'
				And Exchange = @exchange And Segment = @segment  And
				Sysdate = (select Max(sysdate) From C_valuation Where Sysdate <= @effdate + ' 23:59:59' And 
				Scrip_cd = @@scrip_cd  And Series Like  @@series + '%'
			   	And Exchange = @exchange And Segment = @segment)

			Open @@getclrate
			Fetch Next From @@getclrate Into @@cl_rate
			If @@fetch_status = 0
			Begin
						
				Set @@secamount = (@@qty * @@cl_rate)
				Set @@orgcashncash = @@orgcashncash + @@secamount  /*added By Vaishali On 20-03-2002*/
				
				/*take The Haircut*/
				Set @@get = Cursor For
					Select Haircut = Isnull((select Haircut From Securityhaircut Where Party_code = @@party_code And Scrip_cd = @@scrip_cd And Series = @@series And 
					 Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut 
					 Where Effdate <= @effdate + ' 23:59' And Party_code = @@party_code And Scrip_cd = @@scrip_cd And Series = @@series And 
					 Exchange = @exchange And Segment = @segment And Active = 1)),
					 Isnull((select Haircut From Securityhaircut Where Party_code = @@party_code And Scrip_cd = '' And Exchange = @exchange 
						And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut Where Effdate <= @effdate + ' 23:59' 
						And Party_code = @@party_code And Scrip_cd = '' And Exchange = @exchange And Segment = @segment And Active = 1)),
						Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = @@scrip_cd And Series = @@series And
							Exchange = @exchange And Segment = @segment And Active = 1 And Effdate = (select Max(effdate) 
							From Securityhaircut Where Effdate <= @effdate + ' 23:59' And Party_code = '' And 
							Scrip_cd = @@scrip_cd And Series = @@series And Exchange = @exchange And Segment = @segment And Active = 1)),
							Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = '' And 
								Group_cd = @@group_cd And Group_cd <> ''  And Exchange = @exchange And Segment = @segment 
								And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut Where Effdate <= @effdate + ' 23:59' And 
								Party_code = '' And Scrip_cd = '' And Group_cd = @@group_cd And Group_cd <> '' And 
								Exchange = @exchange And Segment = @segment And Active = 1)),
			 					Isnull((select Haircut From Securityhaircut Where Party_code = '' And Scrip_cd = '' And 
									Client_type = @@cl_type And Client_type <> ''  And Exchange = @exchange And Segment = @segment 
									And Active = 1 And Effdate = (select Max(effdate) From Securityhaircut Where Effdate <= @effdate + ' 23:59' And 
									Party_code = '' And Scrip_cd = '' And Client_type = @@cl_type And Client_type <> '' And 
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
				
				Open @@get
				Fetch Next From @@get Into @@haircut
				If @@fetch_status = 0
				Begin	
					Set  @@secamount = @@secamount - (@@secamount * @@haircut/100)
				End
				Close @@get
				Deallocate @@get	
				
				
				Set @@totalsecamount = @@totalsecamount + @@secamount
			
				 Insert Into Msajag.dbo.collateraldetails Values(@effdate,@exchange,@segment,@@party_code,@@scrip_cd,@@series,@@isin,@@cl_rate,(@@cl_rate * @@qty),
				 @@qty, @@haircut, @@secamount , @@cashcompo , @@noncashcompo ,'','','sec', @@cl_type,'','',getdate(),@@cashncash,'','','','')
			End
			Close @@getclrate
			Deallocate @@getclrate
		
			Fetch Next From @@getfdbg Into @@qty, @@scrip_cd, @@series, @@isin		
		End
			
		

		If @@cashncash = 'c'
		Begin		
			Set @@totcash = @@totcash + @@totalsecamount
			Set @@orgtotcash = @@orgtotcash + @@orgcashncash  
		End
		Else If @@cashncash = 'n'
		Begin		
			Set @@totnoncash = @@totnoncash + @@totalsecamount
			Set @@orgtotnoncash = @@orgtotnoncash + @@orgcashncash  
		End 
		Else
		Begin		
			Set @@totnoncash = @@totnoncash + @@totalsecamount
			Set @@orgtotnoncash = @@orgtotnoncash + @@orgcashncash  
		End
		
		Close @@getfdbg
		Deallocate @@getfdbg					
	End
	Close @@checkparty
	Deallocate @@checkparty		
/*end Of Calculation For Sec*/		


	Set @@totalcashnoncash = @@totcash + @@totnoncash
	/*apply The Cash Composition Ratio*/
	If (@@cashcompo = 0) /* And @@noncashcompo = 0) */ /*commented On 18 Jun 2002*/
	Begin
		Set @@actualcash = @@totcash
		Set @@actualnoncash = @@totnoncash
		Set @@effectivecoll = @@totalcashnoncash
	End
	Else
	Begin
		If @@totcash <  @@totnoncash
		Begin
			Set @@actualcash = @@totcash			
			If @@cashcompo > 0 
				Begin
				/*included the following condtion - bug fix - sinu 6 dec 05*/
				if @@TotCash<>0 
					Begin
						Set @@Actualnoncash1 = (@@TotCash *100)/ @@CashCompo
					end
				else
					begin
						Set @@Actualnoncash1 = @@TotNonCash
					end
				End
			Else
			Begin
				Set @@actualnoncash1 = 0
			End

			If @@actualnoncash1 < @@totalcashnoncash
			Begin
				Set @@effectivecoll = @@actualnoncash1
			End
			Else
			Begin
				Set @@effectivecoll = @@totalcashnoncash
			End				
		End
		Else
		Begin
			Set @@actualcash = @@totcash
			Set @@actualnoncash = @@totnoncash
			Set @@effectivecoll = @@totalcashnoncash
		End 
	End
	Set @@actualnoncash = @@effectivecoll - @@actualcash

	Delete From Msajag.dbo.collateral Where Party_code = @@party_code And Exchange = @exchange And Segment = @segment And Left(convert(varchar,trans_date ,109),11)  =  @effdate 

	If @@totcash <> 0 Or @@totnoncash <> 0
	Begin		
		Set @status = 1
		 Insert Into Msajag.dbo.collateral Values(@exchange,@segment,@@party_code, @effdate,@@totcash, @@totnoncash, @@actualcash, @@actualnoncash,
		 @@effectivecoll,1,0,'','',getdate(), @@totalfdamount , @@totalbgamount , @@totalsecamount , @@marginamt, @@orgtotcash, @@orgtotnoncash )							
	End	
	
Fetch Next From @@cur Into @@party_code,@@cl_type
End
Close @@cur
Deallocate @@cur

Return

GO
