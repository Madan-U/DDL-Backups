-- Object: PROCEDURE dbo.AngelLast3Trx
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE Procedure [dbo].[AngelLast3Trx] 
(@ClTDpId Varchar(20))

As
set nocount on



SELECT TOP 10  *  INTO #TRXN  FROM TRXN_DETAILS WHERE ltrim(rtrim(td_ac_code)) = @CltDpId Order By Td_curdate Desc 


SELECT  Td_Isin_Code = Td_Isin_Code , Sc_IsinName = ISIN_NAME,Sc_Company_Name = ISIN_COMP_NAME, 
Td.Td_Qty As Qty,Td.Td_Amount As Value ,Td_Debit_Credit = Td_Debit_Credit, 
convert(varchar, cast(td_trxdate as datetime), 103) as TransDate, Td_ac_code = Td_ac_code
From #TRXN Td With(NoLock) , citrus_usr.isin_mstr Se With(NoLock)
Where
--td.td_counterdp in ('IN300126','12033200')
--And
--ltrim(rtrim(td_ac_code)) = @CltDpId
--And
--td_ac_code in('1203320000000028','1203320000000066')

Td_Isin_Code = ISIN_CD  
Order By Td_curdate Desc,Sc_Company_Name Asc 


 
set nocount off

GO
