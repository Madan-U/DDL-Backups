-- Object: PROCEDURE dbo.C_CalculateBGSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*Calculates the FD Amount Before hairCut and After Haircut for the specified Party Code*/
CREATE PROCEDURE C_CalculateBGSp(@Exchange Varchar(3), @Segment Varchar(20),@Party_Code Varchar(10),@Cl_Type Varchar(3),@EffDate Varchar(11), @TotalBgAmount money OUTPUT,	
				@TotNonCash money OUTPUT, @TotCash money OUTPUT, @OrgTotCash money OUTPUT, @OrgTotNonCash money OUTPUT)
As
Declare 
@@Get Cursor,
@@GetBg Cursor,
@@Bank_Code varchar(20),
@@BgAmount	money,
@@Balance money,
@@Haircut money,
@@CashCompo	 money,
@@NonCashCompo money,
@@CashNCash varchar(1),
@@InstruType  varchar(6),
@@Bg_no varchar(20),
@@Maturity_Dt varchar(11),
@@Receive_Dt varchar(11),
@@OrgCashNcash money,
@@TotalBgAmount money,	
@@TotNonCash money,
@@TotCash	money,
@@OrgTotCash money,
@@OrgTotNonCash money

	Set @@BgAmount  	= 0	
	Set @@Balance 	= 0	
	Set @@Haircut 		= 0	
	Set @@CashCompo	= 0
	Set @@NonCashCompo = 0		
	Set @@Balance	= 0			
	Set @@OrgTotCash	= 0
	Set @@OrgTotNonCash	= 0	Set @@TotNonCash 	= 0
	Set @@TotCash	= 0	
	Set @@TotalBgAmount 	= 0

	/*OutPut parameters*/
	Set @TotalBgAmount 	= 0	
	Set @TotNonCash 	= 0 
	Set @TotCash 		= 0 
	Set @OrgTotCash 	= 0
	Set @OrgTotNonCash 	= 0

	/* Calculation for BG*/		
	Set @@InstruType  = 'BG'	
	/*Get Cash Noncash */
	Set @@Get = Cursor For
		select CN = isnull(( select Cash_Ncash from InstruTypeMst where party_code = @Party_code and Exchange = @Exchange 
		and Segment = @Segment and CLient_Type = '' and Instru_Type like @@InstruType + '%' and Active = 1
		and EffDate = (Select max(Effdate) from InstruTypeMst 
		where EffDate <= @EffDate + ' 23:59' and party_code = @Party_code and CLient_Type = '' and Exchange = @Exchange 
		and Segment = @Segment and Instru_Type like @@InstruType + '%' and Active = 1)),
			isnull(( select Cash_Ncash from InstruTypeMst where party_code = '' and Exchange = @Exchange 
			and Segment = @Segment and CLient_Type = @Cl_Type and CLient_Type <> '' and Instru_Type like @@InstruType + '%' and Active = 1
			and EffDate = (Select max(Effdate) from InstruTypeMst 
			where EffDate <= @EffDate + ' 23:59' and party_code = '' and CLient_Type = @Cl_Type and Exchange = @Exchange 
			and Segment = @Segment and Instru_Type like @@InstruType + '%' and Active = 1)),
				isnull(( select Cash_Ncash from InstruTypeMst where party_code = '' and Exchange = @Exchange 
				and Segment = @Segment and CLient_Type = '' and Instru_Type like @@InstruType + '%' and Active = 1
				and EffDate = (Select max(Effdate) from InstruTypeMst 
				where EffDate <= @EffDate + ' 23:59' and party_code = '' and CLient_Type = '' and Exchange = @Exchange 
				and Segment = @Segment and Instru_Type like @@InstruType + '%' and Active = 1)),'')
			)
		)		
	Open @@Get
	Fetch Next from @@Get into @@CashNcash
	close @@Get
	deallocate @@Get				
	
	/*'Delete the duplicate records in case of 	Recalculation of FD*/
	Delete from Msajag.Dbo.CollateralDetails Where Exchange = @Exchange and Segment = @Segment and Party_code = @Party_Code and EffDate like @EffDate + '%' and Coll_Type = 'BG'

	Set @@OrgCashNcash = 0
	/*Get balance Bg amount for BG*/
	Set @@GetBg = Cursor for				
		select isnull(sum(balance),0) Balance, fm.Bank_Code ,fm.Bg_No, Fm.Receive_Date, fm.Maturity_Date
		From BankGuaranteeTrans F, BankGuaranteeMst Fm
		where F.Trans_Date = (select max(f1.Trans_Date) from BankGuaranteeTrans F1
 				       where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.Bg_no = f1.BG_no
				       and f1.Trans_Date <=  @EffDate + ' 23:59' and f1.branch_code = f1.branch_code)
		and F.Party_Code = @Party_code and Fm.Exchange = @Exchange and Fm.Segment = @Segment and f.branch_code = fm.branch_code
		and fm.party_Code = f.party_code and fm.Bank_Code = f.Bank_Code and fm.Bg_no = f.Bg_No and fm.Status = 'V' and  fm.Active = 1
		Group By fm.Bank_Code, fm.Bg_No, Fm.Receive_Date, fm.Maturity_Date
	Open @@GetBg
	Fetch Next from @@GetBg into @@Balance, @@Bank_Code, @@Bg_no, @@Receive_Dt, @@Maturity_DT
	While @@Fetch_Status = 0
	Begin
		Set @@Get = Cursor for
			/*Get HairCut*/
			select haircut = isnull((select haircut from bghaircut where party_code = @Party_code and bank_code = @@bank_code and 
			 Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from bghaircut 
			 where EffDate <= @EffDate + ' 23:59' and party_code = @Party_code and bank_code = @@bank_code AND 
			 Exchange = @Exchange and Segment = @Segment and Active = 1)),
			 isnull((select haircut from bghaircut where party_code = @Party_code and bank_code = '' and Exchange = @Exchange 
				and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from bghaircut where EffDate <= @EffDate + ' 23:59' 
				and party_code = @Party_code and bank_code = '' AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
				isnull((select haircut from bghaircut where party_code = '' and bank_code = @@bank_code and 
					Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) 
					from bghaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
					bank_code = @@bank_code AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
 					Isnull((SELECT haircut from bghaircut where party_code = '' and bank_code = '' and 
						Client_Type = @Cl_Type and Client_Type <> ''  and Exchange = @Exchange and Segment = @Segment 
						and Active = 1 and EffDate = (Select max(Effdate) from bghaircut where EffDate <= @EffDate + ' 23:59' and 
						party_code = '' and bank_code = '' and Client_Type = @Cl_Type and Client_Type <> '' AND 
						Exchange = @Exchange and Segment = @Segment and Active = 1)),
							isnull((select haircut from bghaircut where party_code = '' and bank_code = '' and client_type = '' 
							and Active = 1 and Exchange = @Exchange and Segment = @Segment and EffDate = (Select max(Effdate) 
							from bghaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
							bank_code = ''  and client_type = ''  AND Exchange = @Exchange and Segment = @Segment and Active = 1)),0)
						)
					)
				)
			)
		Open @@Get
		Fetch Next from @@Get into @@Haircut
		close @@Get
		deallocate @@Get	
				
		Set @@OrgCashNcash = @@OrgCashNcash + @@Balance 
		Set @@BgAmount = @@Balance - ( @@Balance * @@haircut/100)	
		Set @@TotalBgAmount = @@TotalBgAmount + @@BgAmount
		
		
		 Insert into Msajag.Dbo.CollateralDetails Values(@EffDate,@Exchange,@Segment,@Party_code,'','','',0,@@Balance,0,@@haircut, @@BgAmount, @@CashCompo ,@@NonCashCompo,
		@@Receive_Dt,@@Maturity_Dt, 'BG', @Cl_Type ,'','',getdate(),@@CashNCash,'',@@Bg_No,@@Bank_Code,'B')
		
		Set @@haircut 		= 0
		Set @@BgAmount 	= 0
		Set @@Balance 	= 0

		Fetch Next from @@GetBg into @@Balance, @@Bank_Code, @@Bg_no, @@Receive_Dt, @@Maturity_DT 
		
	End
	If @@CashNcash = 'C'
	begin
		set @@TotCash = @@TotCash + @@TotalBgAmount
		Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash  
	end
	Else if @@CashNcash = 'N'
	begin
		set @@TotNonCash = @@TotNonCash + @@TotalBgAmount
		Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash  
	end 
	Else
	Begin
		set @@TotCash = @@TotCash + @@TotalBgAmount
		Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash  
	End

	Set @TotCash = @@TotCash 
	Set @OrgTotCash = @@OrgTotCash 
	Set @TotNonCash  = @@TotNonCash 
	Set @OrgTotNonCash = @@OrgTotNonCash 
	Set @TotalBgAmount =  @@TotalBgAmount


close @@GetBg
deallocate @@GetBg			

Select @TotalBgAmount ,@TotCash ,@OrgTotCash ,@TotNonCash ,@OrgTotNonCash

GO
