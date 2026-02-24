-- Object: PROCEDURE dbo.InsDelShareCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



Create Proc InsDelShareCheck (@Sett_No Varchar(7),@Sett_Type Varchar(2)) As

select D.Party_code,D.Scrip_Cd,D.Qty,
RecQty=(Select Sum(Qty) From DelTrans Where DrCr = 'C' and Sett_No = D.Sett_no and Sett_Type = D.Sett_Type
And Party_Code = D.Party_Code and Scrip_Cd = D.Scrip_Cd and Filler2 = 1 )
into DelScripBalance from DeliveryClt D,Sett_Mst S
Where S.Sett_No = D.Sett_no and S.Sett_Type = D.Sett_Type
and End_Date >= (Select End_Date from Sett_Mst Where Sett_No = @Sett_No
and sett_type = @Sett_Type) and End_Date <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59' And InOut = 'I'
Group by D.Sett_no,D.Sett_Type,D.Party_code,D.Scrip_Cd,D.Qty
Having Qty > (Select Sum(Qty) From DelTrans Where DrCr = 'C' and Sett_No = D.Sett_no and Sett_Type = D.Sett_Type
And Party_Code = D.Party_Code and Scrip_Cd = D.Scrip_Cd and Filler2 = 1 )

GO
