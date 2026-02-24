-- Object: PROCEDURE dbo.C_CashNonCashCalSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------







/****** Object:  Stored Procedure dbo.C_CashNonCashCalSp    Script Date: 12/26/2001 12:13:13 PM ******/

CREATE Proc C_CashNonCashCalSp
@Exchange Varchar(3),
@Segment Varchar(20),
@Party_Code varchar(10),
@Cl_Type Varchar(4),
@EffDate varchar(11),
@InstruType varchar(4)
As

select CN = isnull(( select Cash_Ncash from InstruTypeMst where party_code = @Party_code and Exchange = @Exchange 
		and Segment = @Segment and CLient_Type = '' and Instru_Type like @InstruType + '%' and Active = 1
		and EffDate = (Select max(Effdate) from InstruTypeMst 
		where EffDate <= @EffDate + ' 23:59' and party_code = @party_code and CLient_Type = '' and Exchange = @Exchange 
		and Segment = @Segment and Instru_Type like @InstruType + '%' and Active = 1)),
			isnull(( select Cash_Ncash from InstruTypeMst where party_code = '' and Exchange = @Exchange 
			and Segment = @Segment and CLient_Type = @Cl_Type and CLient_Type <> '' and Instru_Type like @InstruType + '%' and Active = 1
			and EffDate = (Select max(Effdate) from InstruTypeMst 
			where EffDate <= @EffDate + ' 23:59' and party_code = '' and CLient_Type = @Cl_Type and Exchange = @Exchange 
			and Segment = @Segment and Instru_Type like @InstruType + '%' and Active = 1)),
				isnull(( select Cash_Ncash from InstruTypeMst where party_code = '' and Exchange = @Exchange 
				and Segment = @Segment and CLient_Type = '' and Instru_Type like @InstruType + '%' and Active = 1
				and EffDate = (Select max(Effdate) from InstruTypeMst 
				where EffDate <= @EffDate + ' 23:59' and party_code = '' and CLient_Type = '' and Exchange = @Exchange 
				and Segment = @Segment and Instru_Type like @InstruType + '%' and Active = 1)),'')
			)
		)

GO
