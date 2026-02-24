-- Object: PROCEDURE dbo.C_CalculateFDSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*Calculates the BG Amount Before hairCut and After Haircut for the specified Party Code*/
/*Changes done by Vaishao on 21/03/2002 Added two fields in the Collateral table- orginal cash amount and non cash amount i.e Before haircut*/
CREATE PROCEDURE C_CalculateFDSp(@Exchange Varchar(3), @Segment Varchar(20),@Party_Code Varchar(10),@Cl_Type Varchar(3),@EffDate Varchar(11), @TotalFdAmount money OUTPUT,	
					@TotNonCash money OUTPUT, @TotCash money OUTPUT, @OrgTotCash money OUTPUT, @OrgTotNonCash money OUTPUT)
As
Declare 
@@Get Cursor,
@@GetFd Cursor,
@@Bank_Code varchar(20),
@@FdAmount	money,
@@Fd_Type Varchar(1),
@@Balance money,
@@Haircut money,
@@CashCompo	 money,
@@NonCashCompo money,
@@CashNCash varchar(1),
@@InstruType  varchar(6),
@@Fdr_no varchar(20),
@@Maturity_Dt varchar(11),
@@Receive_Dt varchar(11),
@@OrgCashNcash money,
@@TotalFdAmount money,	
@@TotNonCash money,
@@TotCash	money,
@@OrgTotCash money,
@@OrgTotNonCash money

	Set @@FdAmount  	= 0	
	Set @@Balance 	= 0	
	Set @@Haircut 		= 0	
	Set @@CashCompo	= 0
	Set @@NonCashCompo = 0		
	Set @@Balance	= 0			
	Set @@OrgTotCash	= 0
	Set @@OrgTotNonCash	= 0	Set @@TotNonCash 	= 0
	Set @@TotCash	= 0	
	Set @@TotalFdAmount 	= 0
	Set @TotalFdAmount 	= 0	
	Set @TotNonCash 	= 0 
	Set @TotCash 		= 0 
	Set @OrgTotCash 	= 0
	Set @OrgTotNonCash 	= 0

	/* Calculation for FD*/		
	Set @@InstruType  = 'FD'	
	Set @@Get = Cursor For
		select CN = isnull(( select Cash_Ncash from InstruTypeMst where party_code = @Party_code and Exchange = @Exchange 
		and Segment = @Segment and CLient_Type = '' and Instru_Type like @@InstruType + '%' and Active = 1
		and EffDate = (Select max(Effdate) from InstruTypeMst 
		where EffDate <= @EffDate + ' 23:59' and party_code = @party_code and CLient_Type = '' and Exchange = @Exchange 
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
	
	Delete from Msajag.Dbo.CollateralDetails Where Exchange = @Exchange and Segment = @Segment and Party_code = @Party_Code and EffDate like @EffDate + '%' and Coll_Type = 'FD'

	Set @@OrgCashNcash = 0
	
	Set @@GetFd = Cursor for				
		select isnull(sum(balance),0) Balance, fm.Bank_Code, fm.FD_Type, fm.Fdr_No, Fm.Receive_Date, fm.Maturity_Date
		From FixedDepositTrans F, FixedDepositMst Fm
		where F.Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1
 					where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.fdr_no = f1.fdr_no
		       			and f1.Trans_Date <=  @EffDate + ' 23:59' and f1.branch_code = f1.branch_code)
		and F.Party_Code = @Party_Code and Fm.Exchange = @Exchange and Fm.Segment = @Segment and f.branch_code = fm.branch_code
		and fm.party_Code = f.party_code and fm.Bank_Code = f.Bank_Code and fm.Fdr_no = f.Fdr_No and fm.Status = 'V' and  fm.Active = 1
		Group By fm.Bank_Code, fm.FD_Type, fm.Fdr_No, Fm.Receive_Date, fm.Maturity_Date
	Open @@GetFd
	Fetch Next from @@GetFd into @@Balance, @@Bank_Code, @@Fd_Type, @@Fdr_no, @@Receive_Dt, @@Maturity_DT
	While @@Fetch_Status = 0
	Begin
		Set @@Get = Cursor for
			select haircut = isnull((select haircut from fdhaircut where party_code = @party_code and bank_code = @@bank_code and 
			 Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from fdhaircut 
			 where EffDate <= @EffDate + ' 23:59' and party_code = @party_code and bank_code = @@bank_code AND 
			 Exchange = @Exchange and Segment = @Segment and Active = 1)),
			 isnull((select haircut from fdhaircut where party_code = @party_code and bank_code = '' and Fd_Type = @@Fd_Type and Exchange = @Exchange 
				and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @EffDate + ' 23:59' 
				and party_code = @party_code and bank_code = '' and Fd_Type = @@Fd_Type AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
				isnull((select haircut from fdhaircut where party_code = '' and bank_code = @@bank_code and 
					Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) 
					from fdhaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
					bank_code = @@bank_code AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
 					Isnull((SELECT haircut from fdhaircut where party_code = '' and bank_code = '' and 
						Client_Type = @Cl_Type and Client_Type <> '' and Active = 1 and Exchange = @Exchange and Segment = @Segment and 
						EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @EffDate + ' 23:59' and 
						party_code = '' and bank_code = '' and Client_Type = @Cl_Type and Client_Type <> '' AND 
						Exchange = @Exchange and Segment = @Segment and Active = 1)),
							isnull((select haircut from fdhaircut where party_code = '' and bank_code = '' and client_type = '' and
							Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) 
							from fdhaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
							bank_code = ''  and client_type = '' AND Exchange = @Exchange and Segment = @Segment and Active = 1)),0)
						)
					)
				)
			)
		
		
		Open @@Get
		Fetch Next from @@Get into @@Haircut
		close @@Get
		deallocate @@Get	
				
		Set @@OrgCashNcash = @@OrgCashNcash + @@Balance  

		Set @@FdAmount = @@Balance - ( @@Balance * @@haircut/100)
		Set @@TotalFdAmount = @@TotalFdAmount + @@FdAmount

	
		Insert into Msajag.Dbo.CollateralDetails Values(@Effdate,@Exchange,@Segment,@Party_Code,'','','',0,@@Balance,0,@@haircut, @@FdAmount, @@CashCompo ,@@NonCashCompo,@@Receive_Dt,@@Maturity_Dt, 'FD', @cl_type ,'','',getdate(),@@CashNCash,'',@@Fdr_No,@@Bank_Code,@@FD_Type)
		Set @@haircut 		= 0
		Set @@FdAmount 	= 0
		Set @@Balance 	= 0
		Fetch Next from @@GetFd into @@Balance, @@Bank_Code  , @@Fd_Type , @@Fdr_no, @@Receive_Dt, @@Maturity_DT
		
	End
	If @@CashNcash = 'C'
	begin
		Set @@TotCash = @@TotCash + @@TotalFdAmount
		Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash  		
	end
	Else if @@CashNcash = 'N'
	begin
		Set @@TotNonCash = @@TotNonCash + @@TotalFdAmount
		Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash  		
	end 
	Else
	Begin
		Set @@TotCash = @@TotCash + @@TotalFdAmount
		Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash  		
	End

	Set @TotCash 		= @@TotCash 
	Set @OrgTotCash 	= @@OrgTotCash 
	Set @TotNonCash  	= @@TotNonCash 
	Set @OrgTotNonCash 	= @@OrgTotNonCash 
	Set @TotalFdAmount 	= @@TotalFdAmount

	close @@GetFd
	deallocate @@GetFd				
	/* End Of Calculation for FD*/			
	Select @TotalFdAmount ,@TotCash ,@OrgTotCash ,@TotNonCash ,@OrgTotNonCash

GO
