-- Object: PROCEDURE dbo.V2_Inactive_Client_Ledger
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc V2_Inactive_Client_Ledger
(
	@PartyCode 	varchar(10) = ''
)

as

	if @PartyCode <> ''
	begin

		set transaction isolation level read uncommitted
		Select Distinct
		l.CltCode, 
		P.Short_Name, 
		InactiveFrom = left(p.InactiveFrom,11), 
		Vdt = left(l.Vdt,11),
		l.Vno,
		l.Vtyp,
		l.BookType,
		l.DrCr,
		l.Vamt,
		NewVdt= Convert(varchar, l.vdt,112)
		From 
			Account_Ab.dbo.Ledger l with(index(ledind),nolock),
			(
				select 
					c2.party_code, 
					c1.Short_Name,
					c5.inactivefrom 
				from 
					client5 c5 (nolock),
					client2 c2 (nolock),
					client1 c1 (nolock)
				where 
					c5.inactivefrom <= 'dec  31 2049'
					and c2.cl_code = c1.cl_code
					and c1.cl_code = c5.cl_code
					and c2.party_Code = @PartyCode
				
			) P
		where
			l.CltCode = p.Party_code
			and l.Vdt >= p.InactiveFrom
			and l.CltCode = @PartyCode
		Order by l.CltCode, L.Vdt desc
	End
	else
	begin
		set transaction isolation level read uncommitted
		Select Distinct
		l.CltCode, 
		P.Short_Name, 
		InactiveFrom = left(p.InactiveFrom,11), 
		Vdt = left(l.Vdt,11),
		l.Vno,
		l.Vtyp,
		l.BookType,
		l.DrCr,
		l.Vamt,
		NewVdt= Convert(varchar, l.vdt,112)

		From 
			Account_Ab.dbo.Ledger l with(index(ledind),nolock),
			(
				select 
					c2.party_code, 
					c1.Short_Name,
					c5.inactivefrom 
				from 
					client5 c5 (nolock),
					client2 c2 (nolock),
					client1 c1 (nolock)
				where 
					c5.inactivefrom <= 'dec  31 2049'
					and c2.cl_code = c1.cl_code
					and c1.cl_code = c5.cl_code
			) P
		where
			l.CltCode = p.Party_code
			and l.Vdt >= p.InactiveFrom
		Order by l.CltCode, L.Vdt desc
	End

GO
