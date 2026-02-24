-- Object: PROCEDURE dbo.C_AddCollCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/*Changes done by Vaishao on 21/03/2002 Added two fields in the Collateral table- orginal cash amount and non cash amount i.e Before haircut*/
CREATE PROCEDURE C_AddCollCursor
As
Declare @@Cur  cursor,
@@Get Cursor,
@@GetFdBg Cursor,
@@GetClRate Cursor,
@@party_code varchar(15),
@@Cl_Type Varchar(3),
@@Cl_Rate money,
@@Tcode int,
@@effdate varchar(11),
@@Vdate varchar(11),
@@scrip_cd varchar(12),
@@Bank_Code varchar(20),
@@series varchar(3),
@@Isin varchar(20),
@@Qty int,
@@FdAmount	money,
@@Balance money,
@@BgAmount	money,
@@marginamt	money,
@@Haircut money,
@@TotNonCash money,
@@TotCash	money,
@@Actualnoncash money,
@@Actualcash	money,
@@SecAmount	money,
@@TotalSecAmount money,
@@TotalFdAmount money,	
@@TotalBGAmount money,
@@CashCompo	 money,
@@NonCashCompo money,
@@CashNCash varchar(1),@@Exchange varchar(3) ,
@@Segment Varchar(20) ,
@@InstruType  varchar(6),
@@Fdr_no varchar(20),
@@Bg_No varchar(20),
@@Maturity_Dt varchar(11),
@@Receive_Dt varchar(11),
@@Camt Money,
@@Damt Money,
@@DrCr varchar(1),
@@Group_cd varchar(20),
@@TotalCashNonCash  money,
@@Actualnoncash1 money,
@@EffectiveColl money,
/* Added on 21/03/2002*/
@@OrgCashNcash money,			
@@OrgTotCash money,
@@OrgTotNonCash money,
@@FD_Type Varchar(1)

set @@Exchange = 'NSE'
set @@Segment = 'CAPITAL'

Set @@Cur = Cursor For
	Select distinct Party_Code,  left(convert(varchar,Coll_Date,109),11) EffDate From msajag.dbo.focollateral where  Exchange = @@Exchange  and MarketType like @@Segment + '%'
	/*and party_code = '07220'*/
	order by Party_Code
Open @@Cur
Fetch Next from @@Cur into @@Party_code, @@EffDate
While @@Fetch_Status = 0
Begin
	Set @@FdAmount  	= 0	
	Set @@Balance 	= 0
	Set @@BgAmount	= 0
	Set @@marginamt	= 0
	Set @@Haircut 		= 0
	Set @@TotNonCash 	= 0
	Set @@TotCash	= 0
	Set @@Actualnoncash 	= 0
	Set @@Actualcash	= 0
	Set @@SecAmount	= 0
	Set @@TotalSecAmount= 0
	Set @@TotalFdAmount 	= 0
	Set @@TotalBGAmount= 0
	Set @@CashCompo	= 0
	Set @@NonCashCompo= 0
	Set @@Cl_rate 		= 0
	Set @@Qty		= 0
	Set  @@Haircut		= 0
	Set @@Balance		= 0
	Set @@OrgCashNcash	= 0					
	Set @@OrgTotCash	= 0
	Set @@OrgTotNonCash	= 0	Set @@Cl_Type 	= ''

	set @@Get = Cursor for
		Select isnull(Cl_type,'') Cl_type from msajag.dbo.clientmaster where party_code =  @@Party_Code
	Open @@Get
	Fetch Next from @@Get into @@Cl_Type
	close @@Get
	deallocate @@Get	


	/* Get Cash and Noncash composition*/
	set @@Get = Cursor for
		Select Cash = isnull(( select Cash from CashComposition where party_code = @@Party_code and Exchange = @@Exchange 
		and Segment = @@Segment and CLient_Type = ''  and Active = 1	and EffDate = (Select max(Effdate) from CashComposition 
		where EffDate <= @@EffDate + ' 23:59' and party_code = @@party_code and CLient_Type = '' and Exchange = @@Exchange 
		and Segment = @@Segment  and Active = 1)),
			isnull(( select Cash from CashComposition where party_code = '' and Exchange = @@Exchange 
			and Segment = @@Segment and CLient_Type = @@Cl_Type  and Active = 1 and EffDate = (Select max(Effdate) from CashComposition 
			where EffDate <= @@EffDate + ' 23:59' and party_code = '' and CLient_Type = @@Cl_Type and Exchange = @@Exchange 
			and Segment = @@Segment  and Active = 1)),
				isnull(( select Cash from CashComposition where party_code = '' and Exchange = @@Exchange 
				and Segment = @@Segment and CLient_Type = ''  and Active = 1 and EffDate = (Select max(Effdate) from CashComposition 
				where EffDate <= @@EffDate + ' 23:59' and party_code = '' and CLient_Type = '' and Exchange = @@Exchange 
				and Segment = @@Segment  and Active = 1)),0)
			)
		),
		NonCash =  isnull(( select NonCash from CashComposition where party_code = @@Party_code and Exchange = @@Exchange 
		and Segment = @@Segment and CLient_Type = ''  and Active = 1	and EffDate = (Select max(Effdate) from CashComposition 
		where EffDate <= @@EffDate + ' 23:59' and party_code = @@party_code and CLient_Type = '' and Exchange = @@Exchange 
		and Segment = @@Segment  and Active = 1)),
			isnull(( select NonCash from CashComposition where party_code = '' and Exchange = @@Exchange 
			and Segment = @@Segment and CLient_Type = @@Cl_Type  and Active = 1 and EffDate = (Select max(Effdate) from CashComposition 
			where EffDate <= @@EffDate + ' 23:59' and party_code = '' and CLient_Type = @@Cl_Type and Exchange = @@Exchange 
			and Segment = @@Segment  and Active = 1)),
				isnull(( select NonCash from CashComposition where party_code = '' and Exchange = @@Exchange 
				and Segment = @@Segment and CLient_Type = ''  and Active = 1 and EffDate = (Select max(Effdate) from CashComposition 
				where EffDate <= @@EffDate + ' 23:59' and party_code = '' and CLient_Type = '' and Exchange = @@Exchange 
				and Segment = @@Segment  and Active = 1)),0)
			)
		)

	Open @@Get
	Fetch Next from @@Get into @@CashCompo, @@NonCashCompo 	
	close @@Get
	deallocate @@Get		
	/* End Of Get Cash and Noncash composition*/

	/*Get The Margin amount as a Cash*/		
	Set @@Get = Cursor for
		select Camt = isnull((case when drcr = 'c' then sum(Amount) else 0 end),0),  Damt = isnull((Case when drcr = 'd' then sum(Amount) else 0 end),0), drcr
		from Account.dbo.MarginLedger 
		where vdt <= @@EffDate  + ' 23:59' and party_code = @@Party_code and exchange = @@Exchange and segment = @@Segment
		group by drcr
	Open @@Get
	Fetch Next From @@Get into @@Camt, @@Damt, @@DrCr
	While @@Fetch_Status = 0
	Begin	
		If  @@drcr = 'C' 
		begin
		            Set @@marginamt =  @@marginamt  + @@Camt
		end
		Else If @@drcr = 'D'
		begin
			Set @@marginamt  = @@marginamt - @@Damt
		end
		Fetch Next From @@Get into @@Camt, @@Damt, @@DrCr
	End
	Set @@TotCash = @@TotCash + @@marginamt   
	close @@Get
	deallocate @@Get		
	if @@marginamt <> 0 
	begin
		Set @@OrgTotCash = @@OrgTotCash + @@marginamt /*Added by vaishali on 20-03-2002*/

		 Insert into Msajag.Dbo.CollateralDetails Values(@@Effdate,@@Exchange,@@Segment,@@Party_Code, '','','',0, @@marginamt, 0, 0, @@marginamt ,  @@CashCompo , @@NonCashCompo,
		'','', 'MARGIN', @@cl_type,'','',getdate(),'C','','','','')
	End

	/*Update Account.Dbo.MarginLedger Set McltCode = '' where McltCode Like Null*/
	/*End of Get The Margin amount as a Cash*/		

	/* Calculation for FD*/		
	Set @@InstruType  = 'FD'	
	Set @@Get = Cursor For
		select CN = isnull(( select Cash_Ncash from InstruTypeMst where party_code = @@Party_code and Exchange = @@Exchange 
		and Segment = @@Segment and CLient_Type = '' and Instru_Type like @@InstruType + '%' and Active = 1
		and EffDate = (Select max(Effdate) from InstruTypeMst 
		where EffDate <= @@EffDate + ' 23:59' and party_code = @@party_code and CLient_Type = '' and Exchange = @@Exchange 
		and Segment = @@Segment and Instru_Type like @@InstruType + '%' and Active = 1)),
			isnull(( select Cash_Ncash from InstruTypeMst where party_code = '' and Exchange = @@Exchange 
			and Segment = @@Segment and CLient_Type = @@Cl_Type and CLient_Type <> '' and Instru_Type like @@InstruType + '%' and Active = 1
			and EffDate = (Select max(Effdate) from InstruTypeMst 
			where EffDate <= @@EffDate + ' 23:59' and party_code = '' and CLient_Type = @@Cl_Type and Exchange = @@Exchange 
			and Segment = @@Segment and Instru_Type like @@InstruType + '%' and Active = 1)),
				isnull(( select Cash_Ncash from InstruTypeMst where party_code = '' and Exchange = @@Exchange 
				and Segment = @@Segment and CLient_Type = '' and Instru_Type like @@InstruType + '%' and Active = 1
				and EffDate = (Select max(Effdate) from InstruTypeMst 
				where EffDate <= @@EffDate + ' 23:59' and party_code = '' and CLient_Type = '' and Exchange = @@Exchange 
				and Segment = @@Segment and Instru_Type like @@InstruType + '%' and Active = 1)),'')
			)
		)		
	Open @@Get
	Fetch Next from @@Get into @@CashNcash
	close @@Get
	deallocate @@Get				
	
	Set @@OrgCashNcash = 0
	
	Set @@GetFdBg = Cursor for
		select isnull(sum(balance),0) Balance, fm.Bank_Code, fm.FD_Type, fm.Fdr_No, Fm.Receive_Date, fm.Maturity_Date
		From FixedDepositTrans F, FixedDepositMst Fm
		where F.Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1
 					where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.fdr_no = f1.fdr_no
		       			and f1.Trans_Date <=  @@EffDate + ' 23:59' and f1.branch_code = f1.branch_code)
		and F.Party_Code = @@Party_Code and Fm.Exchange = @@Exchange and Fm.Segment = @@Segment and f.branch_code = fm.branch_code
		and fm.party_Code = f.party_code and fm.Bank_Code = f.Bank_Code and fm.Fdr_no = f.Fdr_No and fm.Status = 'V' and  fm.Active = 1
		Group By fm.Bank_Code, fm.FD_Type, fm.Fdr_No, Fm.Receive_Date, fm.Maturity_Date

	Open @@GetFdBg
	Fetch Next from @@GetFdBg into @@Balance, @@Bank_Code, @@Fdr_no, @@Receive_Dt, @@Maturity_DT, @@FD_Type 
	While @@Fetch_Status = 0
	Begin
		Set @@Get = Cursor for
			select haircut = isnull((select haircut from fdhaircut where party_code = @@party_code and bank_code = @@bank_code and 
			 Exchange = @@Exchange and Segment = @@Segment and Active = 1 and EffDate = (Select max(Effdate) from fdhaircut 
			 where EffDate <= @@EffDate + ' 23:59' and party_code = @@party_code and bank_code = @@bank_code AND 
			 Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
			 isnull((select haircut from fdhaircut where party_code = @@party_code and bank_code = '' and Exchange = @@Exchange 
				and Segment = @@Segment and Active = 1 and EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @@EffDate + ' 23:59' 
				and party_code = @@party_code and bank_code = '' AND Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
				isnull((select haircut from fdhaircut where party_code = '' and bank_code = @@bank_code and 
					Exchange = @@Exchange and Segment = @@Segment and Active = 1 and EffDate = (Select max(Effdate) 
					from fdhaircut where EffDate <= @@EffDate + ' 23:59' and party_code = '' and 
					bank_code = @@bank_code AND Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
 					Isnull((SELECT haircut from fdhaircut where party_code = '' and bank_code = '' and 
						Client_Type = @@Cl_Type and Client_Type <> '' and Active = 1 and Exchange = @@Exchange and Segment = @@Segment and 
						EffDate = (Select max(Effdate) from fdhaircut where EffDate <= @@EffDate + ' 23:59' and 
						party_code = '' and bank_code = '' and Client_Type = @@Cl_Type and Client_Type <> '' AND 
						Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
							isnull((select haircut from fdhaircut where party_code = '' and bank_code = '' and client_type = '' and
							Exchange = @@Exchange and Segment = @@Segment and Active = 1 and EffDate = (Select max(Effdate) 
							from fdhaircut where EffDate <= @@EffDate + ' 23:59' and party_code = '' and 
							bank_code = ''  and client_type = '' AND Exchange = @@Exchange and Segment = @@Segment and Active = 1)),0)
						)
					)
				)
			)
		
		Open @@Get
		Fetch Next from @@Get into @@Haircut
		close @@Get
		deallocate @@Get	
				
		Set @@OrgCashNcash = @@OrgCashNcash + @@Balance  /*Added By vaishali on 21/03/2002*/

		Set @@FdAmount = @@Balance - ( @@Balance * @@haircut/100)	
		Set @@TotalFdAmount = @@TotalFdAmount + @@FdAmount
		
		
		 Insert into Msajag.Dbo.CollateralDetails Values(@@Effdate,@@Exchange,@@Segment,@@Party_Code,'','','',0,@@Balance,0,@@haircut, @@FdAmount, @@CashCompo ,@@NonCashCompo,
		@@Receive_Dt,@@Maturity_Dt, 'FD', @@cl_type ,'','',getdate(),@@CashNCash,'',@@Fdr_No,@@Bank_Code,@@FD_Type)

		Fetch Next from @@GetFdBg into @@Balance, @@Bank_Code, @@Fdr_no, @@Receive_Dt, @@Maturity_DT, @@FD_Type
	End
	If @@CashNcash = 'C'
	begin
		set @@TotCash = @@TotCash + @@TotalFdAmount
		Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash  /*Added by vaishali on 20-03-2002*/
	end
	Else if @@CashNcash = 'N'
	begin
		set @@TotNonCash = @@TotNonCash + @@TotalFdAmount
		Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash  /*Added by vaishali on 20-03-2002*/
	end 
	Else
	Begin
		set @@TotCash = @@TotCash + @@TotalFdAmount
		Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash  /*Added by vaishali on 20-03-2002*/
	End

		
	close @@GetFdBg
	deallocate @@GetFdBg				
	/* End Of Calculation for FD*/			

	Set @@OrgCashNcash = 0
	/* Calculation for BG*/		
	Set @@InstruType  = 'BG'	
	Set @@Get = Cursor For
		select CN = isnull(( select Cash_Ncash from InstruTypeMst where party_code = @@Party_code and Exchange = @@Exchange 
		and Segment = @@Segment and CLient_Type = '' and Instru_Type like @@InstruType + '%' and Active = 1
		and EffDate = (Select max(Effdate) from InstruTypeMst 
		where EffDate <= @@EffDate + ' 23:59' and party_code = @@party_code and CLient_Type = '' and Exchange = @@Exchange 
		and Segment = @@Segment and Instru_Type like @@InstruType + '%' and Active = 1)),
			isnull(( select Cash_Ncash from InstruTypeMst where party_code = '' and Exchange = @@Exchange 
			and Segment = @@Segment and CLient_Type = @@Cl_Type and CLient_Type <> '' and Instru_Type like @@InstruType + '%' and Active = 1
			and EffDate = (Select max(Effdate) from InstruTypeMst 
			where EffDate <= @@EffDate + ' 23:59' and party_code = '' and CLient_Type = @@Cl_Type and Exchange = @@Exchange 
			and Segment = @@Segment and Instru_Type like @@InstruType + '%' and Active = 1)),
				isnull(( select Cash_Ncash from InstruTypeMst where party_code = '' and Exchange = @@Exchange 
				and Segment = @@Segment and CLient_Type = '' and Instru_Type like @@InstruType + '%' and Active = 1
				and EffDate = (Select max(Effdate) from InstruTypeMst 
				where EffDate <= @@EffDate + ' 23:59' and party_code = '' and CLient_Type = '' and Exchange = @@Exchange 
				and Segment = @@Segment and Instru_Type like @@InstruType + '%' and Active = 1)),'')
			)
		)		
	Open @@Get
	Fetch Next from @@Get into @@CashNcash
	close @@Get
	deallocate @@Get				
	
	
	Set @@GetFdBg = Cursor for
		select isnull(sum(balance),0) Balance, fm.Bank_Code ,fm.Bg_No, Fm.Receive_Date, fm.Maturity_Date
		From BankGuaranteeTrans F, BankGuaranteeMst Fm
		where F.Trans_Date = (select max(f1.Trans_Date) from BankGuaranteeTrans F1
 				       where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.Bg_no = f1.BG_no
				       and f1.Trans_Date <=  @@EffDate + ' 23:59' and f1.branch_code = f1.branch_code)
		and F.Party_Code = @@Party_Code and Fm.Exchange = @@Exchange and Fm.Segment = @@Segment and f.branch_code = fm.branch_code
		and fm.party_Code = f.party_code and fm.Bank_Code = f.Bank_Code and fm.Bg_no = f.Bg_No and fm.Status = 'V' and  fm.Active = 1
		Group By fm.Bank_Code, fm.Bg_No, Fm.Receive_Date, fm.Maturity_Date
	Open @@GetFdBg
	Fetch Next from @@GetFdBg into @@Balance, @@Bank_Code, @@bg_no, @@Receive_Dt, @@Maturity_DT 
	While @@Fetch_Status = 0
	Begin
		Set @@Get = Cursor for
			select haircut = isnull((select haircut from bghaircut where party_code = @@party_code and bank_code = @@bank_code and 
			 Exchange = @@Exchange and Segment = @@Segment and Active = 1 and EffDate = (Select max(Effdate) from bghaircut 
			 where EffDate <= @@EffDate + ' 23:59' and party_code = @@party_code and bank_code = @@bank_code AND 
			 Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
			 isnull((select haircut from bghaircut where party_code = @@party_code and bank_code = '' and Exchange = @@Exchange 
				and Segment = @@Segment and Active = 1 and EffDate = (Select max(Effdate) from bghaircut where EffDate <= @@EffDate + ' 23:59' 
				and party_code = @@party_code and bank_code = '' AND Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
				isnull((select haircut from bghaircut where party_code = '' and bank_code = @@bank_code and 
					Exchange = @@Exchange and Segment = @@Segment and Active = 1 and EffDate = (Select max(Effdate) 
					from bghaircut where EffDate <= @@EffDate + ' 23:59' and party_code = '' and 
					bank_code = @@bank_code AND Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
 					Isnull((SELECT haircut from bghaircut where party_code = '' and bank_code = '' and 
						Client_Type = @@Cl_Type and Client_Type <> ''  and Exchange = @@Exchange and Segment = @@Segment 
						and Active = 1 and EffDate = (Select max(Effdate) from bghaircut where EffDate <= @@EffDate + ' 23:59' and 
						party_code = '' and bank_code = '' and Client_Type = @@Cl_Type and Client_Type <> '' AND 
						Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
							isnull((select haircut from bghaircut where party_code = '' and bank_code = '' and client_type = '' 
							and Active = 1 and Exchange = @@Exchange and Segment = @@Segment and EffDate = (Select max(Effdate) 
							from bghaircut where EffDate <= @@EffDate + ' 23:59' and party_code = '' and 
							bank_code = ''  and client_type = ''  AND Exchange = @@Exchange and Segment = @@Segment and Active = 1)),0)
						)
					)
				)
			)
		
		Open @@Get
		Fetch Next from @@Get into @@Haircut
		close @@Get
		deallocate @@Get	

		Set @@OrgCashNcash = @@OrgCashNcash + @@Balance  /*Added by vaishali on 20-03-2002*/

		Set @@BgAmount = @@Balance - ( @@Balance * @@haircut/100)	
		Set @@TotalBgAmount = @@TotalBgAmount + @@BgAmount

		 Insert into Msajag.Dbo.CollateralDetails Values(@@Effdate,@@Exchange,@@Segment,@@Party_Code,'','','',0,@@Balance,0,@@haircut, @@BgAmount, @@CashCompo ,@@NonCashCompo,
		@@Receive_Dt,@@Maturity_Dt, 'BG', @@cl_type ,'','',getdate(),@@CashNCash,'',@@Bg_No,@@Bank_Code,'B')

		Fetch Next from @@GetFdBg into @@Balance, @@Bank_Code, @@Bg_no, @@Receive_Dt, @@Maturity_DT 
	End
	If @@CashNcash = 'C'
	begin
		set @@TotCash = @@TotCash + @@TotalBgAmount
		Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash  /*Added by vaishali on 20-03-2002*/
	end
	Else if @@CashNcash = 'N'
	begin
		set @@TotNonCash = @@TotNonCash + @@TotalBgAmount
		Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash  /*Added by vaishali on 20-03-2002*/
	end 
	Else
	Begin
		set @@TotCash = @@TotCash + @@TotalBgAmount
		Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash  /*Added by vaishali on 20-03-2002*/
	End
	close @@GetFdBg
	deallocate @@GetFdBg				
	/*End of Calculation for BG*/		

	Set @@OrgCashNcash  = 0
/* Calculation for SEC*/		
	Set @@InstruType  = 'SEC'	
	/*Take cashnoncah*/
	Set @@Get = Cursor For
		select CN = isnull(( select Cash_Ncash from InstruTypeMst where party_code = @@Party_code and Exchange = @@Exchange 
		and Segment = @@Segment and CLient_Type = '' and Instru_Type like @@InstruType + '%' and Active = 1
		and EffDate = (Select max(Effdate) from InstruTypeMst 
		where EffDate <= @@EffDate + ' 23:59' and party_code = @@party_code and CLient_Type = '' and Exchange = @@Exchange 
		and Segment = @@Segment and Instru_Type like @@InstruType + '%' and Active = 1)),
			isnull(( select Cash_Ncash from InstruTypeMst where party_code = '' and Exchange = @@Exchange 
			and Segment = @@Segment and CLient_Type = @@Cl_Type and CLient_Type <> '' and Instru_Type like @@InstruType + '%' and Active = 1
			and EffDate = (Select max(Effdate) from InstruTypeMst 
			where EffDate <= @@EffDate + ' 23:59' and party_code = '' and CLient_Type = @@Cl_Type and Exchange = @@Exchange 
			and Segment = @@Segment and Instru_Type like @@InstruType + '%' and Active = 1)),
				isnull(( select Cash_Ncash from InstruTypeMst where party_code = '' and Exchange = @@Exchange 
				and Segment = @@Segment and CLient_Type = '' and Instru_Type like @@InstruType + '%' and Active = 1
				and EffDate = (Select max(Effdate) from InstruTypeMst 
				where EffDate <= @@EffDate + ' 23:59' and party_code = '' and CLient_Type = '' and Exchange = @@Exchange 
				and Segment = @@Segment and Instru_Type like @@InstruType + '%' and Active = 1)),'')
			)
		)		
	Open @@Get
	Fetch Next from @@Get into @@CashNcash
	close @@Get
	deallocate @@Get				
	

	Set @@GetFdBg = Cursor for
		select BalQty = sum(Crqty) - sum(Drqty), scrip_cd, series, isin 
		from C_CalculateSecView
		where party_code = @@Party_Code and effdate <= @@Effdate + '  23:59:59' and Exchange = @@Exchange and Segment =  @@Segment
		group by scrip_cd,series, isin
		
	Open @@GetFdBg
	Fetch Next from @@GetFdBg into @@Qty, @@Scrip_Cd, @@Series, @@Isin
	While @@Fetch_Status = 0
	Begin		
		/*Take the group code*/
		Set @@Get = Cursor for	
			select distinct group_code  from groupmst where scrip_cd = @@Scrip_Cd and series like @@Series + '%'
			and exchange = @@Exchange and segment = @@Segment and active = 1
			and effdate = (select max(effdate) from groupmst   where scrip_cd = @@Scrip_Cd and series like @@Series + '%'
		             and exchange = @@Exchange and segment = @@Segment
	     	             and effdate <= @@EffDate + ' 23:59:59' and active = 1)
		Open @@Get
		Fetch Next From @@Get into @@Group_cd
		close @@Get
		Deallocate @@Get

		/*Take the Closing Rate */
		Set @@GetClRate = Cursor for
			select isnull(Cl_Rate,0) Cl_Rate From C_valuation where Scrip_Cd = @@Scrip_cd  and series like @@Series + '%'
			and exchange = @@Exchange and Segment = @@Segment and
			Sysdate = (Select max(sysdate) from c_valuation where sysdate <= @@Effdate + '  23:59:59' and 
			Scrip_Cd = @@Scrip_cd  and series like  @@Series + '%'
		   	and exchange = @@Exchange and Segment = @@Segment)
		Open @@GetClRate
		Fetch Next From @@GetClRate into @@Cl_Rate
		If @@Fetch_Status = 0
		Begin
					
			Set @@SecAmount = (@@Qty * @@Cl_Rate)
			Set @@OrgCashNcash = @@OrgCashNcash + @@SecAmount  /*Added by vaishali on 20-03-2002*/

			/*Take the haircut*/
			Set @@Get = Cursor for
				select haircut = isnull((select haircut from securityhaircut where party_code = @@party_code and Scrip_Cd = @@Scrip_Cd and Series = @@Series and 
				 Exchange = @@Exchange and Segment = @@Segment and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut 
				 where EffDate <= @@EffDate + ' 23:59' and party_code = @@party_code and Scrip_Cd = @@Scrip_Cd and Series = @@Series AND 
				 Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
				 isnull((select haircut from securityhaircut where party_code = @@party_code and Scrip_Cd = '' and Exchange = @@Exchange 
					and Segment = @@Segment and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut where EffDate <= @@EffDate + ' 23:59' 
					and party_code = @@party_code and Scrip_Cd = '' AND Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
					isnull((select haircut from securityhaircut where party_code = '' and Scrip_Cd = @@Scrip_Cd and 
						Exchange = @@Exchange and Segment = @@Segment and Active = 1 and EffDate = (Select max(Effdate) 
						from securityhaircut where EffDate <= @@EffDate + ' 23:59' and party_code = '' and 
						Scrip_Cd = @@Scrip_Cd AND Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
						Isnull((SELECT haircut from securityhaircut where party_code = '' and Scrip_Cd = '' and 
							Group_Cd = @@Group_Cd and Group_Cd <> ''  and Exchange = @@Exchange and Segment = @@Segment 
							and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut where EffDate <= @@EffDate + ' 23:59' and 
							party_code = '' and Scrip_Cd = '' and Group_Cd = @@Group_Cd and Group_Cd <> '' AND 
							Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
		 					Isnull((SELECT haircut from securityhaircut where party_code = '' and Scrip_Cd = '' and 
								Client_Type = @@Cl_Type and Client_Type <> ''  and Exchange = @@Exchange and Segment = @@Segment 
								and Active = 1 and EffDate = (Select max(Effdate) from securityhaircut where EffDate <= @@EffDate + ' 23:59' and 
								party_code = '' and Scrip_Cd = '' and Client_Type = @@Cl_Type and Client_Type <> '' AND 
								Exchange = @@Exchange and Segment = @@Segment and Active = 1)),
									isnull((select haircut from securityhaircut where party_code = '' and Scrip_Cd = '' and client_type = '' and Group_cd = ''
									and Active = 1 and Exchange = @@Exchange and Segment = @@Segment and EffDate = (Select max(Effdate) 
									from securityhaircut where EffDate <= @@EffDate + ' 23:59' and party_code = '' and 
									Scrip_Cd = ''  and client_type = ''  and Group_cd = '' AND Exchange = @@Exchange and Segment = @@Segment and Active = 1)),0)
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
		
			 Insert into Msajag.Dbo.CollateralDetails Values(@@Effdate,@@Exchange,@@Segment,@@Party_Code,@@Scrip_Cd,@@Series,@@isin,@@Cl_rate,(@@Cl_rate * @@Qty),
			 @@Qty, @@haircut, @@SecAmount , @@CashCompo , @@NonCashCompo ,'','','SEC', @@cl_type,'','',getdate(),@@CashNCash,'','','','')
		End
		close @@GetClRate
		Deallocate @@GetClRate
	
		Fetch Next from @@GetFdBg into @@Qty, @@Scrip_Cd, @@Series, @@Isin		
	End
		
	

	If @@CashNcash = 'C'
	begin		
		set @@TotCash = @@TotCash + @@TotalSecAmount
		Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash  /*Added by vaishali on 20-03-2002*/
	end
	Else if @@CashNcash = 'N'
	begin		
		set @@TotNonCash = @@TotNonCash + @@TotalSecAmount
		Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash  /*Added by vaishali on 20-03-2002*/
	end 
	Else
	Begin		
		set @@TotNonCash = @@TotNonCash + @@TotalSecAmount
		Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash  /*Added by vaishali on 20-03-2002*/
	End
	
	close @@GetFdBg
	deallocate @@GetFdBg				
	/*End of Calculation for SEC*/		
	
	

	Set @@TotalCashNonCash = @@TotCash + @@TotNonCash
	/*Apply the Cash Composition Ratio*/
	If @@CashCompo = 0 And @@NonCashCompo = 0 
	Begin
		Set @@Actualcash = @@TotCash
		Set @@Actualnoncash = @@TotNonCash
		Set @@EffectiveColl = @@TotalCashNonCash
	End
	Else
	Begin
		If @@TotCash <  @@TotNonCash
		Begin
			Set @@Actualcash = @@TotCash
			Set @@Actualnoncash1 = (@@TotCash *100)/ @@CashCompo
			If @@Actualnoncash1 < @@TotalCashNonCash
			Begin
				Set @@EffectiveColl = @@Actualnoncash1
			End
			Else
			Begin
				Set @@EffectiveColl = @@TotalCashNonCash
			End				
		End
		Else
		Begin
			Set @@Actualcash = @@TotCash
			Set @@Actualnoncash = @@TotNonCash
			Set @@EffectiveColl = @@TotalCashNonCash
		End 
	End
	Set @@Actualnoncash = @@EffectiveColl - @@Actualcash

	If @@TotCash <> 0 Or @@TotNonCash <> 0
	Begin		
		 Insert into msajag.dbo.Collateral Values(@@Exchange,@@Segment,@@Party_Code, @@Effdate,@@TotCash, @@TotNonCash, @@Actualcash, @@Actualnoncash,
		 @@EffectiveColl,1,0,'','',getdate(), @@TotalFdAmount , @@TotalBgAmount , @@TotalSecAmount , @@marginamt, @@OrgTotCash, @@OrgTotNonCash )							
	End	
	
Fetch Next from @@Cur into @@Party_code, @@EffDate
End
close @@Cur
deallocate @@Cur

GO
