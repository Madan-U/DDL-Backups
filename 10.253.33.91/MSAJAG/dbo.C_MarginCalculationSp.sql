-- Object: PROCEDURE dbo.C_MarginCalculationSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE C_MarginCalculationSp (@Exchange Varchar(3), @Segment Varchar(20),@FromParty Varchar(10), @ToParty Varchar(10),@EffDate Varchar(11))
AS
Declare @@Cur Cursor,
@@Get Cursor,
@@Party_code Varchar(10),
@@AccountCode Varchar(15),
@@Sdt Varchar(11),
@@Ldt Varchar(11),
@@OpenEntryDate Varchar(20),
@@Camt Money,
@@Damt Money,
@@Marginamt Money,
@@CashCompo Money,
@@NonCashCompo Money,
@@ClType Varchar(10),
@@Drcr Varchar(1)

Set @@AccountCode = ''
/*Take the Finacial Year from Parameter Table */
Set @@Get = Cursor For	
	Select Left(Convert(Varchar,sdtcur,109),11) SdtCur, Left(Convert(Varchar,ldtcur,109),11) Ldtcur
	From Parameter
	Where @EffDate Between Sdtcur and Ldtcur
Open @@Get
Fetch Next From @@Get Into @@Sdt, @@Ldt
Close @@Get
Deallocate @@Get

/*Find if there is any opening entry */
Set @@Get = Cursor For	
	select distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt  from MarginLedger
	where vtyp = '18' and  vdt >= @@Sdt and vdt <= @@Ldt +  ' 23:59:59'
Open @@Get
If @@Fetch_Status = 0
Begin
	Fetch Next From @@Get Into @@OpenEntryDate
	Close @@Get
	Deallocate @@Get
End
Else
Begin
	/*If there is no open entry for selected year get latest openentry date */
	Set @@Get = Cursor For	
		select distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt  from Dbo.MarginLedger
		where vtyp = '18' and  vdt < @@Sdt						
	Open @@Get	
	Fetch Next From @@Get Into @@OpenEntryDate
	Close @@Get
	Deallocate @@Get
End 


/*Take the Margin Account from C_AccountMapping table for the selected parties.*/
Set @@Cur = Cursor For
	select distinct Party_code from MarginLedger
	where Party_code >=@FromParty and Party_Code <= @ToParty order by Party_Code
Open @@Cur
Fetch Next from @@Cur into @@Party_code
While @@Fetch_Status = 0
Begin	
	Set @@Get = Cursor For	
		Select Accountcode from msajag.dbo.C_AccountMapping where Party_code = @@Party_Code
 		and exchange = @Exchange and segment = @Segment and active = 1
 		and effdate <= @EffDate + ' 23:59' Order by Effdate desc
	Open @@Get
	Fetch Next From @@Get Into @@AccountCode	
	Close @@Get
	Deallocate @@Get			
						
	/*If opening entry found then calculate from opening entry date else from beginning*/
	If @@OpenEntryDate <> '' 
	Begin
		Set @@Get = Cursor For	
			select Camt = isnull((case when drcr = 'C' then sum(Amount) else 0 end),0),
			Damt = isnull((Case when drcr = 'D' then sum(Amount) else 0 end),0), drcr
			from MarginLedger where vdt >= @@Sdt and vdt <= @EffDate + ' 23:59:59' 
			and party_code = @@Party_code and exchange = @Exchange
			and segment = @Segment and MCltcode like @@AccountCode + '%'
			 group by drcr		
	End
	Else
	Begin
		Set @@Get = Cursor For	
			select Camt = isnull((case when drcr = 'C' then sum(Amount) else 0 end),0),
			Damt = isnull((Case when drcr = 'D' then sum(Amount) else 0 end),0), drcr
			from MarginLedger where vdt <= @EffDate + ' 23:59:59' 
			and party_code = @@Party_code and exchange = @Exchange
			and segment = @Segment and MCltcode like @@AccountCode + '%'
			 group by drcr

	End 
	Open @@Get
	Fetch Next From @@Get Into @@Camt, @@Damt, @@Drcr
	Set @@Marginamt = 0
	While @@Fetch_Status = 0
	Begin
		If @@Drcr = 'C' 
		Begin
	        		Set @@Marginamt = @@Marginamt + @@Camt
		End
		Else
			Begin
				Set @@Marginamt = @@Marginamt - @@Damt
			End	
	Fetch Next From @@Get Into @@Camt, @@Damt, @@Drcr
	End
	Close @@Get
	Deallocate @@Get
	
	If @@Marginamt <> 0
	Begin
		Delete From Msajag..CollateralDetails Where party_code = @@Party_code and exchange = @Exchange and segment = @Segment and EffDate like @Effdate + '%' and Coll_Type = 'MARGIN'
		
		Insert into Msajag.Dbo.CollateralDetails Values(@EffDate,@Exchange,@Segment,@@Party_Code,'','','',0, @@Marginamt,0,0,@@Marginamt,@@CashCompo,@@NonCashCompo,'','', 'MARGIN',@@Cltype,'','',getdate(),'C','','','','')

	End
	Fetch Next from @@Cur into @@Party_code
End

GO
