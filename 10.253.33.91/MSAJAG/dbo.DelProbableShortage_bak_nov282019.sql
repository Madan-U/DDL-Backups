-- Object: PROCEDURE dbo.DelProbableShortage_bak_nov282019
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/* Drop Proc DelProbableShortage */
CREATE Proc DelProbableShortage As 
DeClare 
@@Sett_No Varchar(7),
@@Sett_Type Varchar(2),
@@Party_Code Varchar(10),
@@Scrip_Cd Varchar(12),
@@ScripCode Varchar(12),
@@Series Varchar(3),
@@ScripName Varchar(50),
@@Isin varchar(12),
@@Exchg Varchar(3),
@@Qty int,
@@PQty int,
@@DQty int,
@@CQty int,
@@IQty int,
@@DpType Varchar(4),
@@DpId Varchar(8),
@@CltDpId Varchar(16),
@@POAFlag int, 
@@Start_Date DateTime,
@@Status Varchar(10),
@@SettCur cursor,
@@DelCur cursor

select @@DQty = 0 
select @@CQty = 0 
select @@IQty = 0 
Select @@Scrip_CD = '0'

Select @@DpType = ''
Select @@DpId = ''
Select @@CltDpId = ''
Select @@POAFlag = 0

Delete From DelCDSLBalance Where Party_Code Not in (Select Party_Code From Bsedb.DBO.Multicltid Where Def = 1 And Party_code = DelCDSLBalance.Party_Code ) 

Update DelCDSLBalance Set totalBalance = FreeBal

Truncate Table DelPOAShortage

Truncate Table DelPoaTemp

Insert Into DelPoaTemp
select R.Sett_No,R.Sett_Type,R.Party_Code,ScripName=M.Scrip_Cd,M.Scrip_Cd,M.Series,Qty=Sum(DelQty-RecQty-ISettQty-IBenQty),M.IsIn,
Exchg='NSE',Start_Date,Status = ( Case When Sec_PayIn < GetDate() Then 'Confirm' Else 'Probable' End )
from Rpt_DelPayInMatch R, Sett_mst S , MultiIsin M
Where S.Sett_no = R.Sett_no And S.Sett_Type = R.Sett_Type 
And End_date <= GetDate() + 1 And Sec_PayIn + 1 >= GetDate() 
And M.IsIn = R.CertNo
Group by R.Sett_No,R.Sett_Type,R.Party_Code,M.Scrip_Cd,M.Series,M.IsIn,Start_Date,Sec_PayIn
Having Sum(DelQty-RecQty-ISettQty-IBenQty) > 0 

Insert Into DelPoaTemp
select R.Sett_No,R.Sett_Type,R.Party_Code,ScripName=S2.Scrip_Cd,M.Scrip_Cd,M.Series,Qty=Sum(DelQty-RecQty-ISettQty-IBenQty),M.IsIn,
Exchg='BSE',Start_Date,Status = ( Case When Sec_PayIn < GetDate() Then 'Confirm' Else 'Probable' End )
from BSEDB.DBO.Rpt_DelPayInMatch R, BSEDB.DBO.Sett_mst S , BSEDB.DBO.MultiIsin M, BSEDB.DBO.Scrip2 S2
Where S.Sett_no = R.Sett_no And S.Sett_Type = R.Sett_Type 
And End_date <= GetDate() + 1 And Sec_PayIn + 1 >= GetDate() 
And M.IsIn = R.CertNo And S2.BseCode = M.Scrip_Cd
Group by R.Sett_No,R.Sett_Type,R.Party_Code,S2.Scrip_cd,M.Scrip_Cd,M.Series,M.IsIn,Start_Date,Sec_PayIn
Having Sum(DelQty-RecQty-ISettQty-IBenQty) > 0 

Set @@SettCur = Cursor for
Select Sett_No,Sett_Type,Party_Code,ScripName,Scrip_Cd,Series,Qty,IsIn,Exchg,Start_Date,Status From DelPoaTemp
Order BY Exchg Desc,Sett_no,Sett_Type,Party_code,Scrip_CD
Open @@SettCur
Fetch Next From @@SettCur Into @@Sett_No,@@Sett_Type,@@Party_Code,@@ScripName,@@Scrip_Cd,@@Series,@@Qty,@@Isin,@@Exchg,@@Start_Date,@@Status
While @@Fetch_Status = 0 
Begin
	Select @@PQty = @@Qty 
	if @@PQty > 0
	Begin
		Select @@DQty = 0 
		Set @@DelCur = Cursor For
		Select TotalBalance From MSajag.DBO.DelCDSLBalance Where IsIn = @@IsIn 
		And Party_Code = @@Party_Code And @@Status <> 'Confirm'
		Open @@DelCur
		Fetch Next From @@DelCur into @@DQty
		if @@DQty >= @@PQty 
		Begin
			insert into DelPOAShortage Values (@@Sett_No,@@Sett_Type,@@Party_Code,@@ScripName,@@Scrip_Cd,@@Series,@@Qty,@@Isin,@@Exchg,'0',@@PQty,@@DQty,@@DpType,@@DpId,@@CltDpId,@@POAFlag,@@Start_Date,@@Status)
			Update MSajag.DBO.DelCDSLBalance Set TotalBalance = @@DQty - @@PQty Where IsIn = @@IsIn 
			And Party_Code = @@Party_Code
		End
		Else
		Begin
			insert into DelPOAShortage Values (@@Sett_No,@@Sett_Type,@@Party_Code,@@ScripName,@@Scrip_Cd,@@Series,@@Qty,@@Isin,@@Exchg,'0',@@PQty,@@DQty,@@DpType,@@DpId,@@CltDpId,@@POAFlag,@@Start_Date,@@Status)
			Update MSajag.DBO.DelCDSLBalance Set TotalBalance = 0 Where IsIn = @@IsIn 
			And Party_Code = @@Party_Code
		End
		Close @@DelCur		
	End	
	Fetch Next From @@SettCur into @@Sett_No,@@Sett_Type,@@Party_Code,@@ScripName,@@Scrip_Cd,@@Series,@@Qty,@@Isin,@@Exchg,@@Start_Date,@@Status
End

Update DelPOAShortage Set POAFlag = 1, DpType = M.DpType, DpId = M.DpId, CltDpID = M.CltDpNo From MultiCltId M Where Def = 1 And DelPoaShortage.Party_Code = M.Party_Code 
And Exchg = 'NSE' 

Update DelPOAShortage Set POAFlag = 1, DpType = M.DpType, DpId = M.DpId, CltDpID = M.CltDpNo From BSEDB.DBO.MultiCltId M Where Def = 1 And DelPoaShortage.Party_Code = M.Party_Code 
And Exchg = 'BSE'

GO
