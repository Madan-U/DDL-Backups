-- Object: PROCEDURE dbo.GetManualBankReco
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE  Proc GetManualBankReco
	@BankCode Varchar(10),
	@FDate Varchar(11),
	@TDate Varchar(11),
	@Edit SmallInt,
	@SVtyp Varchar(5),
	@OrderBy Varchar(15),
      @DDno Varchar(15),
	@SelectRl Varchar(20) = ''
As
Declare @@SelectQury As Varchar(2000)
	Select @@SelectQury = "Select L.AcName, L1.DrCr, L.CltCode, L1.DDNO, Convert(Varchar(10), dddt, 103) as Dddt, CONVERT(VARCHAR(10),reldt,103) AS  reldt1, "
	Select @@SelectQury = @@SelectQury + "L.Vamt as RelAmt, Convert(Varchar(10), L.Vdt, 103) As Vdt, "
	Select @@SelectQury = @@SelectQury + "CONVERT(VARCHAR(10),vdt,101) AS   vdt1,l1.vno,l1.vtyp,l1.booktype,l1.lno,reldt ,ShortDesc "
	Select @@SelectQury = @@SelectQury + "From Ledger L, Ledger1 L1, VMast V, (Select Vno, Vtyp, BookType From Ledger Where CltCode = '" + @BankCode + "' "
	If @SVtyp = 'All'
		Begin
			Select @@SelectQury = @@SelectQury + "And Vtyp In (2,3,5,19,20,17) "
		End
	Else
		Begin
			If @SVtyp = '2'
				Begin
					Select @@SelectQury = @@SelectQury + "And Vtyp = 2 "
				End
			Else
				Begin
					If @SVtyp = '3'
						Begin
							Select @@SelectQury = @@SelectQury + "And Vtyp = 3 "
						End
				End
		End
      If @FDate <> ''
        Begin
	    Select @@SelectQury = @@SelectQury + "And Vdt Between '" + @FDate + "' And '" + @TDate + " 23:59:59') L2 "
        End
      Else
        Begin
            Select @@SelectQury = @@SelectQury + ") L2 "
        End
	Select @@SelectQury = @@SelectQury + "Where L.Vno = L2.Vno and L.Vtyp = L2.Vtyp And L.BookType = L2.Booktype And L.CLtcode <> '" + @BankCode + "' "
	Select @@SelectQury = @@SelectQury + "And L.Vno = L1.Vno and L.Vtyp = L1.Vtyp ANd L.BookType = L1.Booktype ANd L.Lno = L1.Lno "
      If @Ddno <> ''
        Begin
	     Select @@SelectQury = @@SelectQury + "And L1.Ddno = '" + @Ddno + "'"
        End
/*
	If @SelectRl = 'chkRelDt'
		Begin
			Select @@SelectQury = @@SelectQury + "And L1.RelDt Between '" + @FDate + "' And '" + @TDate + " 23:59:59' "
		End
	Else
		Begin
			Select @@SelectQury = @@SelectQury + "And L.Vdt Between '" + @FDate + "' And '" + @TDate + " 23:59:59' "
		End
*/
	If @Edit = 1
		Begin
			Select @@SelectQury = @@SelectQury + "And reldt Not Like 'Jan  1 1900%' "
		End
	Else
		Begin
			Select @@SelectQury = @@SelectQury + "And reldt Like 'Jan  1 1900%' "
		End
	Select @@SelectQury = @@SelectQury + "And v.Vtype = l.vtyp and (upper(clear_mode) <> 'C') "
	If @OrderBy = 'relamt'
		Begin
			Select @@SelectQury = @@SelectQury + "Order By relamt ,vdt1 ,l1.vtyp,l1.vno "
		End
	Else
		Begin
			If @OrderBy = 'vdt'
				Begin
					Select @@SelectQury = @@SelectQury + "Order By vdt1, relamt, l1.vtyp, l1.vno "
				End
			Else
				Begin
					If @OrderBy = 'ddno'
						Begin
							Select @@SelectQury = @@SelectQury + "Order By ddno, relamt, l1.vtyp, l1.vno "
						End
					Else
						Begin
							If @OrderBy = 'reldt'
								Begin
									Select @@SelectQury = @@SelectQury + "Order By reldt, relamt, l1.vtyp, l1.vno "
								End
						End
				End
		End
Print @@SelectQury
Exec (@@SelectQury)

GO
