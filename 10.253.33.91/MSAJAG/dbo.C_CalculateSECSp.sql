-- Object: PROCEDURE dbo.C_CalculateSECSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*Calculates the SEC Amount Before hairCut and After Haircut for the specified Party Code*/
CREATE PROCEDURE C_CalculateSECSp(@Exchange Varchar(3), @Segment Varchar(20),@Party_Code Varchar(10),@Cl_Type Varchar(3),@EffDate Varchar(11), @TotalSecAmount money OUTPUT,	
				@TotNonCash money OUTPUT, @TotCash money OUTPUT, @OrgTotCash money OUTPUT, @OrgTotNonCash money OUTPUT)
As
Declare 
@@GetClRate Cursor,
@@Get Cursor,
@@GetSec Cursor,
@@Bank_Code varchar(20),
@@SecAmount	money,
@@Balance money,
@@Haircut money,
@@Cl_Rate money,
@@scrip_cd varchar(12),
@@series varchar(3),
@@Isin varchar(20),
@@Qty int,
@@CashCompo	 money,
@@Camt Money,
@@Damt Money,
@@DrCr varchar(1),
@@Group_cd varchar(20),
@@NonCashCompo money,
@@CashNCash varchar(1),
@@InstruType  varchar(6),
@@Bg_no varchar(20),
@@Maturity_Dt varchar(11),
@@Receive_Dt varchar(11),
@@OrgCashNcash money,
@@TotalSecAmount money,	
@@TotNonCash money,
@@TotCash	money,
@@OrgTotCash money,
@@OrgTotNonCash money

	Set @@SecAmount  	= 0	
	Set @@Balance 	= 0	
	Set @@Haircut 		= 0	
	Set @@CashCompo	= 0
	Set @@NonCashCompo = 0		
	Set @@Balance	= 0			
	Set @@OrgTotCash	= 0
	Set @@OrgTotNonCash	= 0	Set @@TotNonCash 	= 0
	Set @@TotCash	= 0	
	Set @@TotalSecAmount 	= 0

	/*OutPut parameters*/
	Set @TotalSecAmount 	= 0	
	Set @TotNonCash 	= 0 
	Set @TotCash 		= 0 
	Set @OrgTotCash 	= 0
	Set @OrgTotNonCash 	= 0

	/* Calculation for SEC*/		
	Set @@InstruType  = 'SEC'	
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
	
	Delete from Msajag.Dbo.CollateralDetails Where Exchange = @Exchange and Segment = @Segment and Party_code = @Party_Code and EffDate like @EffDate + '%' and Coll_Type = 'SEC'


	Set @@OrgCashNcash = 0
	/*Get balance Bg amount for BG*/
	Set @@GetSec = Cursor for				
		select BalQty = sum(Crqty) - sum(Drqty), scrip_cd, series, isin 
		from C_CalculateSecView
		where party_code = @Party_code and effdate <= @EffDate + '  23:59:59' and Exchange = @Exchange and Segment =  @Segment
		group by scrip_cd,series, isin
	Open @@GetSec
	Fetch Next from @@GetSec into @@Qty, @@Scrip_Cd, @@Series, @@Isin
	While @@Fetch_Status = 0
	Begin		
		/*Take the group code*/
		Set @@Get = Cursor for	
			select distinct group_code  from groupmst where scrip_cd = @@Scrip_Cd and series like @@Series + '%'
			and exchange = @Exchange and segment = @Segment and active = 1
			and effdate = (select max(effdate) from groupmst   where scrip_cd = @@Scrip_Cd and series like @@Series + '%'
		             and exchange = @Exchange and segment = @Segment
	     	             and effdate <= @EffDate + ' 23:59:59' and active = 1)
		Open @@Get
		Fetch Next From @@Get into @@Group_cd
		close @@Get
		Deallocate @@Get

		/*Take the Closing Rate */
		Set @@GetClRate = Cursor for
			select isnull(Cl_Rate,0) Cl_Rate From C_valuation where Scrip_Cd = @@Scrip_cd  and series like @@Series + '%'
			and exchange = @Exchange and Segment = @Segment and
			Sysdate = (Select max(sysdate) from C_valuation where sysdate <= @EffDate + '  23:59:59' and 
			Scrip_Cd = @@Scrip_cd  and series like  @@Series + '%'
		   	and exchange = @Exchange and Segment = @Segment)
		Open @@GetClRate
		Fetch Next From @@GetClRate into @@Cl_Rate
		Close @@GetClRate
		Deallocate @@GetClRate		

		Set @@SecAmount = (@@Qty * @@Cl_Rate)
		Set @@OrgCashNcash = @@OrgCashNcash + @@SecAmount  /*Added by vaishali on 20-03-2002*/

		/*Take the haircut*/
		Set @@Get = Cursor for
			select haircut = isnull((select haircut from securityhaircut where party_code = @Party_code and Scrip_Cd = @@Scrip_Cd and Series = @@Series and 
			 Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut 
			 where EffDate <= @EffDate + ' 23:59' and party_code = @Party_code and Scrip_Cd = @@Scrip_Cd and Series = @@Series AND 
			 Exchange = @Exchange and Segment = @Segment and Active = 1)),
			 isnull((select haircut from securityhaircut where party_code = @Party_code and Scrip_Cd = '' and Exchange = @Exchange 
				and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut where EffDate <= @EffDate + ' 23:59' 
				and party_code = @Party_code and Scrip_Cd = '' AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
				isnull((select haircut from securityhaircut where party_code = '' and Scrip_Cd = @@Scrip_Cd and Series = @@Series and 
					Exchange = @Exchange and Segment = @Segment and Active = 1 and EffDate = (Select max(Effdate) 
					from securityhaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
					Scrip_Cd = @@Scrip_Cd and Series = @@Series AND Exchange = @Exchange and Segment = @Segment and Active = 1)),
					Isnull((SELECT haircut from securityhaircut where party_code = '' and Scrip_Cd = '' and 
						Group_Cd = @@Group_Cd and Group_Cd <> ''  and Exchange = @Exchange and Segment = @Segment 
						and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut where EffDate <= @EffDate + ' 23:59' and 
						party_code = '' and Scrip_Cd = '' and Group_Cd = @@Group_Cd and Group_Cd <> '' AND 
						Exchange = @Exchange and Segment = @Segment and Active = 1)),
	 					Isnull((SELECT haircut from securityhaircut where party_code = '' and Scrip_Cd = '' and 
							Client_Type = @Cl_Type and Client_Type <> ''  and Exchange = @Exchange and Segment = @Segment 
							and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut where EffDate <= @EffDate + ' 23:59' and 
							party_code = '' and Scrip_Cd = '' and Client_Type = @Cl_Type and Client_Type <> '' AND 
							Exchange = @Exchange and Segment = @Segment and Active = 1)),
								isnull((select haircut from securityhaircut where party_code = '' and Scrip_Cd = '' and client_type = '' and Group_cd = ''
								and Active = 1 and Exchange = @Exchange and Segment = @Segment and EffDate = (Select max(Effdate) 
								from securityhaircut where EffDate <= @EffDate + ' 23:59' and party_code = '' and 
								Scrip_Cd = ''  and client_type = ''  and Group_cd = '' AND Exchange = @Exchange and Segment = @Segment and Active = 1)),0)
							)
						)
					)
				)
			)
		
		Open @@Get
		Fetch Next from @@Get into @@Haircut
		If @@Fetch_Status = 0
		Begin	
			Set  @@SecAmount = @@SecAmount - (@@SecAmount * @@Haircut/100)
		End
		close @@Get
		deallocate @@Get	
			
			
		Set @@TotalSecAmount = @@TotalSecAmount + @@SecAmount
	
		
		 Insert into Msajag.Dbo.CollateralDetails Values(@EffDate,@Exchange,@Segment,@Party_code,@@Scrip_Cd,@@Series,@@isin,@@Cl_rate,(@@Cl_rate * @@Qty),
		 @@Qty, @@haircut, @@SecAmount , @@CashCompo , @@NonCashCompo ,'','','SEC', @Cl_Type,'','',getdate(),@@CashNCash,'','','','')
	
		Fetch Next from @@GetSec into @@Qty, @@Scrip_Cd, @@Series, @@Isin		
	End
		
	

	If @@CashNcash = 'C'
	begin		
		set @@TotCash = @@TotCash + @@TotalSecAmount
		Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash 
	end
	Else if @@CashNcash = 'N'
	begin		
		set @@TotNonCash = @@TotNonCash + @@TotalSecAmount
		Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash  
	end 
	Else
	Begin		
		set @@TotNonCash = @@TotNonCash + @@TotalSecAmount
		Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash  
	End

	Set @TotCash = @@TotCash 
	Set @OrgTotCash = @@OrgTotCash 
	Set @TotNonCash  = @@TotNonCash 
	Set @OrgTotNonCash = @@OrgTotNonCash 
	Set @TotalSecAmount =  @@TotalSecAmount

Close @@GetSec
Deallocate @@GetSec			

Select @TotalSecAmount ,@TotCash ,@OrgTotCash ,@TotNonCash ,@OrgTotNonCash

GO
