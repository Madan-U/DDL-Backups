-- Object: PROCEDURE dbo.C_margincalculationsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Procedure C_margincalculationsp (@exchange Varchar(3), @segment Varchar(20),@fromparty Varchar(10), @toparty Varchar(10),@effdate Varchar(11))
As
Declare @@cur Cursor,
@@get Cursor,
@@party_code Varchar(10),
@@accountcode Varchar(15),
@@sdt Varchar(11),
@@ldt Varchar(11),
@@openentrydate Varchar(20),
@@camt Money,
@@damt Money,
@@marginamt Money,
@@cashcompo Money,
@@noncashcompo Money,
@@cltype Varchar(10),
@@drcr Varchar(1)

Set @@accountcode = ''
/*take The Finacial Year From Parameter Table */
Set @@get = Cursor For	
	Select Left(convert(varchar,sdtcur,109),11) Sdtcur, Left(convert(varchar,ldtcur,109),11) Ldtcur
	From Parameter
	Where @effdate Between Sdtcur And Ldtcur
Open @@get
Fetch Next From @@get Into @@sdt, @@ldt
Close @@get
Deallocate @@get

/*find If There Is Any Opening Entry */
Set @@get = Cursor For	
	Select Distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt  From Marginledger
	Where Vtyp = '18' And  Vdt >= @@sdt And Vdt <= @@ldt +  ' 23:59:59'
Open @@get
If @@fetch_status = 0
Begin
	Fetch Next From @@get Into @@openentrydate
	Close @@get
	Deallocate @@get
End
Else
Begin
	/*if There Is No Open Entry For Selected Year Get Latest Openentry Date */
	Set @@get = Cursor For	
		Select Distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt  From Dbo.marginledger
		Where Vtyp = '18' And  Vdt < @@sdt						
	Open @@get	
	Fetch Next From @@get Into @@openentrydate
	Close @@get
	Deallocate @@get
End 


/*take The Margin Account From C_accountmapping Table For The Selected Parties.*/
Set @@cur = Cursor For
	Select Distinct Party_code From Marginledger
	Where Party_code >=@fromparty And Party_code <= @toparty Order By Party_code
Open @@cur
Fetch Next From @@cur Into @@party_code
While @@fetch_status = 0
Begin	
	Set @@get = Cursor For	
		Select Accountcode From Msajag.dbo.c_accountmapping Where Party_code = @@party_code
 		And Exchange = @exchange And Segment = @segment And Active = 1
 		And Effdate <= @effdate + ' 23:59' Order By Effdate Desc
	Open @@get
	Fetch Next From @@get Into @@accountcode	
	Close @@get
	Deallocate @@get			
						
	/*if Opening Entry Found Then Calculate From Opening Entry Date Else From Beginning*/
	If @@openentrydate <> '' 
	Begin
		Set @@get = Cursor For	
			Select Camt = Isnull((case When Drcr = 'c' Then Sum(amount) Else 0 End),0),
			Damt = Isnull((case When Drcr = 'd' Then Sum(amount) Else 0 End),0), Drcr
			From Marginledger Where Vdt >= @@sdt And Vdt <= @effdate + ' 23:59:59' 
			And Party_code = @@party_code And Exchange = @exchange
			And Segment = @segment And Mcltcode Like @@accountcode + '%'
			 Group By Drcr		
	End
	Else
	Begin
		Set @@get = Cursor For	
			Select Camt = Isnull((case When Drcr = 'c' Then Sum(amount) Else 0 End),0),
			Damt = Isnull((case When Drcr = 'd' Then Sum(amount) Else 0 End),0), Drcr
			From Marginledger Where Vdt <= @effdate + ' 23:59:59' 
			And Party_code = @@party_code And Exchange = @exchange
			And Segment = @segment And Mcltcode Like @@accountcode + '%'
			 Group By Drcr

	End 
	Open @@get
	Fetch Next From @@get Into @@camt, @@damt, @@drcr
	Set @@marginamt = 0
	While @@fetch_status = 0
	Begin
		If @@drcr = 'c' 
		Begin
	        		Set @@marginamt = @@marginamt + @@camt
		End
		Else
			Begin
				Set @@marginamt = @@marginamt - @@damt
			End	
	Fetch Next From @@get Into @@camt, @@damt, @@drcr
	End
	Close @@get
	Deallocate @@get
	
	If @@marginamt <> 0
	Begin
		Delete From Msajag..collateraldetails Where Party_code = @@party_code And Exchange = @exchange And Segment = @segment And Effdate Like @effdate + '%' And Coll_type = 'margin'
		
		Insert Into Msajag.dbo.collateraldetails Values(@effdate,@exchange,@segment,@@party_code,'','','',0, @@marginamt,0,0,@@marginamt,@@cashcompo,@@noncashcompo,'','', 'margin',@@cltype,'','',getdate(),'c','','','','')

	End
	Fetch Next From @@cur Into @@party_code
End

GO
