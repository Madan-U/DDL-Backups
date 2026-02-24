-- Object: PROCEDURE dbo.Del_HoldingDateWise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Proc Del_HoldingDateWise as 
Drop Table AniDelTrans

Select * Into AniDelTrans From DelTrans 

Update AniDelTrans Set Filler4 = D.TransDate From DelTrans D Where AniDelTrans.TCode = D.TCode
And D.DrCr <> AniDelTrans.DrCr And D.DrCr = 'C' And D.Sett_No = AniDelTrans.Sett_No And D.Sett_Type = AniDelTrans.Sett_Type
And D.Scrip_Cd = AniDelTrans.Scrip_Cd And D.Series = AniDelTrans.Series And D.BDpId = AniDelTrans.BDpId 
And D.BCltDpId = AniDelTrans.BCltDpId 

Update AniDelTrans Set Filler4 = D.TransDate From DelTrans D Where AniDelTrans.TCode = D.TCode
And D.DrCr = AniDelTrans.DrCr And D.DrCr = 'D' And D.Sett_No = AniDelTrans.Sett_No And D.Sett_Type = AniDelTrans.Sett_Type
And D.Scrip_Cd = AniDelTrans.Scrip_Cd And D.Series = AniDelTrans.Series And D.BDpId <> AniDelTrans.BDpId 
And D.BCltDpId <> AniDelTrans.BCltDpId And AniDelTrans.Filler2 = 1 And D.Filler2 = 0
And D.Party_Code = AniDelTrans.Party_Code

GO
