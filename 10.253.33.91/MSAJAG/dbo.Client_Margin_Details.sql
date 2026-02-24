-- Object: PROCEDURE dbo.Client_Margin_Details
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 
 Create Proc Client_Margin_Details (@Margindate datetime,@party_code varchar(11))
 As

select h.* into #Margin from TBL_COMBINE_REPORTING_DETAIL  H(Nolock) 
where MARGINDATE =@Margindate and PARTY_CODE =@party_code
 
select  h.* into #PMargin  from TBL_COMBINE_REPORTING_PEAK_DETAIL H(Nolock)
Where MARGINDATE=@Margindate and PARTY_CODE =@party_code

Create Table #Margin_Final (Margin_date datetime,party_code varchar(11),exchange Varchar(10),Segment varchar(16),
Tday_Ledger money,tday_noncash money,epn money,Total_Available Money,Tday_Margin money,tday_MTM Money,
Total_tday_Margin Money,peak_Margin money) 

Insert into  #Margin_Final (Margin_date,party_code,exchange,Segment)
Select Distinct margindate,party_Code,exchange,Segment from (
Select * from #Margin where EXCHANGE ='EPN'
Union 
Select * from #PMargin )A where exchange not in ('EPN')
 
 
 Update M set  tday_ledger=d.tday_ledger,tday_noncash=d.tday_noncash,
 tday_margin=d.tday_margin ,tday_mtm=d.tday_mtm from #Margin_Final M,#Margin D where M.Margin_date=D.margindate and m.party_Code=d.party_Code
 and m.exchange=d.exchange and m.segment=d.segment

  Update M set  tday_ledger=d.tday_ledger,tday_noncash=d.tday_noncash,
  peak_Margin=d.tday_margin  from #Margin_Final M,#PMargin D where M.Margin_date=D.margindate and m.party_Code=d.party_Code
 and m.exchange=d.exchange and m.segment=d.segment 

  Update M set  epn = TDAY_CASHCOLL  from #Margin_Final M,#Margin D where M.Margin_date=D.margindate and m.party_Code=d.party_Code
  and d.EXCHANGE ='EPN'

   Update M set  epn = TDAY_CASHCOLL  from #Margin_Final M,#PMargin D where M.Margin_date=D.margindate and m.party_Code=d.party_Code
  and d.EXCHANGE ='EPN' and epn is null

  
   Update M set  epn = 0  from #Margin_Final M  where epn is null
   Update M set  Tday_Margin = 0  from #Margin_Final M  where Tday_Margin is null
   Update M set  tday_MTM = 0  from #Margin_Final M  where tday_MTM is null
   Update M set  peak_Margin = 0  from #Margin_Final M  where peak_Margin is null
   Update M set Total_Available= Tday_Ledger+tday_noncash+epn  from #Margin_Final M  
   Update M set Total_tday_Margin= Tday_Margin+tday_MTM  from #Margin_Final M  
 
 Alter table #Margin_Final add eod_margin_Short_fall money ,eod_margin_mtm_sm money,peak_mar_sm money
    Update M set  peak_mar_sm=T_MARGINAVL
	from #Margin_Final M,#PMargin D where M.Margin_date=D.margindate and m.party_Code=d.party_Code
 and m.exchange=d.exchange and m.segment=d.segment 

    Update M set  eod_margin_Short_fall=d.T_MARGINAVL  ,eod_margin_mtm_sm= T_MTMAVL   from #Margin_Final M,#Margin D where M.Margin_date=D.margindate and m.party_Code=d.party_Code
 and m.exchange=d.exchange and m.segment=d.segment 

 
  Update M set  eod_margin_Short_fall = 0  from #Margin_Final M  where eod_margin_Short_fall is null
  Update M set  eod_margin_mtm_sm = 0  from #Margin_Final M  where eod_margin_mtm_sm is null
  Update M set  peak_mar_sm = 0  from #Margin_Final M  where peak_mar_sm is null

  Update M set  eod_margin_Short_fall = 0  from #Margin_Final M  where eod_margin_Short_fall>0
  Update M set  eod_margin_mtm_sm = 0  from #Margin_Final M  where eod_margin_mtm_sm >0
  Update M set  peak_mar_sm = 0  from #Margin_Final M  where peak_mar_sm >0


  Select *   from #Margin_Final

GO
