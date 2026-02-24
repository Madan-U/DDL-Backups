-- Object: PROCEDURE dbo.report_Rpt_TransStatementBen
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[report_Rpt_TransStatementBen]               
(@FromDate varchar(11), @ToDate varchar(11), @FromParty varchar(10), @ToParty varchar(10), @FromScrip varchar(12), @ToScrip varchar(12),              
@CltDpId varchar(16), @DpId varchar(10), @Flag Int, @StatusID Varchar(50), @StatusName VarChar(50) )              
As               
            
If Len(@DpID) < 8         
 Select @DpId = 'AAAA'        
        
If Len(@CltDpId) < 8         
 Select @CltDpId = 'AAAA'        
    
--select top 1 * from Deltrans_Report With(NoLock)                 
    
Set Transaction isolation level read uncommitted                
select * into #Del_TransStat From Deltrans_Report With(NoLock)                 
Where Party_Code >= @FromParty And Party_Code <= @ToParty                
and Scrip_CD >= @FromScrip And Scrip_CD <= @ToScrip                
And TransDate >= @FromDate and TransDate <= @ToDate                
    
CREATE     
  INDEX [DELHOLD] ON [dbo].[#Del_TransStat] ([transdate], [Party_Code], [scrip_cd], [holdername], [DrCr], [BDpType], [BDpId], [BCltDpId])    
    
    
if @Flag = 1               
Begin              
 Select  TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
  c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
  D.Scrip_Cd, Scrip_Name = D.Scrip_Cd+'( ' + CertNo + ')', CertNo, CQty = Sum(Qty), DQty = 0, SlipNo, DpId=BDpId, CltDpId=BCltDpID, TrType,               
  Reason = (Case When HolderName Like 'Margin%' Then 'Trans To Margin' Else 'Trans To Ben' End),              
   BDpId, BCltDpId, TransDate1 = TransDate,FLAG=1              
 from  #Del_TransStat D,               
  Client2 C2,               
  Client1 C1              
 where  drcr = 'D'               
 And  ShareType <> 'AUCTION'               
 And  CertNo Like 'IN%'              
 and  Delivered = 'G'               
 And  Filler2 = 0               
 And  C2.Cl_Code = C1.Cl_Code               
 And  C2.Party_Code = D.Party_Code               
 And  TransDate >= @FromDate               
 And  TransDate <= @ToDate              
 And  d.Party_Code >= @FromParty               
 And  d.Party_Code <= @ToParty              
 And  D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip              
 And  HolderName Like '%' + RTrim(LTRim(@CltDpId)) + '%'              
 And HolderName Not Like 'MARGIN%'                  
 --And Sett_No <> '2000000'              
 AND  c1.branch_cd like  (case when @statusid = 'branch'   then @statusname else '%' end)              
 AND  c1.sub_broker like  (case when @statusid = 'subbroker'  then @statusname else '%' end)              
 AND  c1.trader like   (case when @statusid = 'trader'   then @statusname else '%' end)              
 AND  c1.family like   (case when @statusid = 'family'   then @statusname else '%' end)              
 AND  c2.party_code like  (case when @statusid = 'client'   then @statusname else '%' end)               
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
  c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
  D.Scrip_Cd, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId, HolderName                
              
 Union All              
              
 Select  TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
  c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
  D.Scrip_Cd, Scrip_Name = D.Scrip_Cd+'( ' + CertNo + ')', CertNo, CQty = Sum(Qty), DQty = 0, SlipNo, DpId=DpId, CltDpId=CltDpID, TrType,      
  Reason , BDpId, BCltDpId, TransDate1 = TransDate,FLAG=2                
 from  #Del_TransStat D,               
  Client2 C2,            
  Client1 C1              
 where  drcr = 'C'               
 And  ShareType <> 'AUCTION'               
 And  CertNo Like 'IN%'              
 /*and Delivered = '0'*/ And Filler2 = 1               
 And  C2.Cl_Code = C1.Cl_Code               
 And  C2.Party_Code = D.Party_Code               
 And  TransDate >= @FromDate               
 And  TransDate <= @ToDate              
 And  d.Party_Code >= @FromParty               
 And  d.Party_Code <= @ToParty              
 And  D.Scrip_Cd >= @FromScrip               
 And  D.Scrip_Cd <= @ToScrip              
 And BDpId = @DpId And BCltDpId = @CltDpId           
 /*And Sett_No = '2000000' */ AND FILLER1 NOT IN ('SPLIT','BONUS')              
 AND  c1.branch_cd like  (case when @statusid = 'branch'   then @statusname else '%' end)              
 AND  c1.sub_broker like  (case when @statusid = 'subbroker'  then @statusname else '%' end)              
 AND  c1.trader like   (case when @statusid = 'trader'   then @statusname else '%' end)              
 AND  c1.family like   (case when @statusid = 'family'   then @statusname else '%' end)              
 AND  c2.party_code like  (case when @statusid = 'client'   then @statusname else '%' end)               
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
  c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
  D.Scrip_Cd, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId ,Reason              
              
 Union All              
              
 Select  TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
  c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
  D.Scrip_Cd, Scrip_Name = D.Scrip_Cd+'( ' + CertNo + ')', CertNo, CQty = Sum(Qty), DQty = 0, SlipNo=0, DpId='', CltDpId='', TrType,               
  Reason , BDpId, BCltDpId, TransDate1 = TransDate,FLAG=3                
 from  #Del_TransStat D, Client2 C2, Client1 C1              
 where  drcr = 'C'               
 And  ShareType <> 'AUCTION'               
 And  CertNo Like 'IN%'              
 and  Delivered = '0'               
 And  Filler2 = 1               
 And  C2.Cl_Code = C1.Cl_Code               
 And  C2.Party_Code = D.Party_Code               
 And  TransDate >= @FromDate               
 And  TransDate <= @ToDate              
 And  d.Party_Code >= @FromParty               
 And  d.Party_Code <= @ToParty              
 And  D.Scrip_Cd >= @FromScrip               
 And  D.Scrip_Cd <= @ToScrip              
 And BDpId = @DpId And BCltDpId = @CltDpId           
 AND  FILLER1 IN ('SPLIT','BONUS')              
 AND  c1.branch_cd like  (case when @statusid = 'branch'   then @statusname else '%' end)              
 AND  c1.sub_broker like  (case when @statusid = 'subbroker'  then @statusname else '%' end)              
 AND  c1.trader like   (case when @statusid = 'trader'   then @statusname else '%' end)              
 AND  c1.family like   (case when @statusid = 'family'   then @statusname else '%' end)              
 AND  c2.party_code like  (case when @statusid = 'client'   then @statusname else '%' end)               
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
  c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
  D.Scrip_Cd, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId ,Reason              
              
 Union All              
              
 select  TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,              
  c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
  D.Scrip_Cd, Scrip_Name = D.Scrip_Cd+'( ' + CertNo + ')', CertNo, CQty = 0, DQty = Sum(Qty), SlipNo=(CASE WHEN FILLER1 = 'SPLIT' THEN 0 ELSE SLIPNO END),               
  DpId =  (Case  When TrType in (1000,907,908)  Then ''               
            When filler1 = 'split'    Then ''              
            when filler1 Like 'Change To%'  Then ''                
           Else DpId end),               
  CltDpId = (Case  When TrType in (1000,907,908)  then ''               
    When filler1 = 'split'    Then ''             
                         when filler1 Like 'Change To%'  Then ''              
      else CltDpId               
      end),              
  TrType,               
  Reason =  (Case  When TrType in (1000,907,908)  Then 'Trans To Pool - ' + ISett_No + '-' + ISett_Type               
           Else               
    (case  when filler1 = 'split'    then 'CORPORATE ACTION'               
                when filler1 Like 'Change To%'      then Filler1              
              Else               
    (Case  When Reason = 'DEMAT'           Then 'Pay-Out'               
    Else  Reason               
    End)               
    end)              
    End),               
  BDpId, BCltDpId, TransDate1 = TransDate,FLAG=4                
 from  #Del_TransStat D,               
  Client2 C2,               
  Client1 C1              
 where  filler2 = 1               
 and  drcr = 'D'               
 and  Delivered <> '0'               
 And  ShareType <> 'AUCTION'               
 And  CertNo Like 'IN%'              
 And  C2.Cl_Code = C1.Cl_Code               
 And  C2.Party_Code = D.Party_Code               
 And  TransDate >= @FromDate               
 And  TransDate <= @ToDate              
 And  d.Party_Code >= @FromParty               
 And  d.Party_Code <= @ToParty              
 And  D.Scrip_Cd >= @FromScrip               
 And  D.Scrip_Cd <= @ToScrip              
 And BDpId = @DpId And BCltDpId = @CltDpId           
 AND  c1.branch_cd like  (case when @statusid = 'branch'   then @statusname else '%' end)              
 AND  c1.sub_broker like  (case when @statusid = 'subbroker'  then @statusname else '%' end)              
 AND  c1.trader like   (case when @statusid = 'trader'   then @statusname else '%' end)              
 AND  c1.family like   (case when @statusid = 'family'   then @statusname else '%' end)              
 AND  c2.party_code like  (case when @statusid = 'client'   then @statusname else '%' end)               
 And  HolderName Not Like 'MARGIN%'              
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
  c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
  D.Scrip_Cd, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId , FILLER1, reason              
              
 Union All              
              
 Select  TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
  c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
  D.Scrip_Cd, Scrip_Name = D.Scrip_Cd+'( ' + CertNo + ')', CertNo, CQty = 0, DQty = Sum(Qty), SlipNo, DpId=dp.DpId, CltDpId=dp.dpcltno, TrType,               
  Reason = (Case When HolderName Like 'Margin%' Then 'Trans To Margin' Else 'Trans To Ben' End),              
   BDpId, BCltDpId, TransDate1 = TransDate,FLAG=1              
 from  #Del_TransStat D,               
  Client2 C2,               
  Client1 C1,               
  deliverydp dp              
 where  drcr = 'D'               
 And  ShareType <> 'AUCTION'               
 And  CertNo Like 'IN%'              
 and  Delivered = 'G'               
 And  Filler2 = 0               
 And  C2.Cl_Code = C1.Cl_Code               
 And  C2.Party_Code = D.Party_Code               
 And  TransDate >= @FromDate               
 And  TransDate <= @ToDate              
 And  d.Party_Code >= @FromParty               
 And  d.Party_Code <= @ToParty              
 And  D.Scrip_Cd >= @FromScrip               
 And  D.Scrip_Cd <= @ToScrip              
 And BDpId = @DpId And BCltDpId = @CltDpId           
 And Description not like '%POOL%'            
 and  (holdername like 'ben ' + Dp.DpCltNo               
  Or holdername like 'Margin ' + Dp.DpCltNo)              
 AND  c1.branch_cd like  (case when @statusid = 'branch'   then @statusname else '%' end)              
 AND  c1.sub_broker like  (case when @statusid = 'subbroker'  then @statusname else '%' end)              
 AND  c1.trader like   (case when @statusid = 'trader'   then @statusname else '%' end)              
 AND  c1.family like   (case when @statusid = 'family'   then @statusname else '%' end)              
 AND  c2.party_code like  (case when @statusid = 'client'   then @statusname else '%' end)               
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
  c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,             
  D.Scrip_Cd, CertNo, SlipNo, TrType, dp.dpid, dpcltno , ISett_No, ISett_Type, BDpId, BCltDpId, HolderName                
 Order By D.Party_Code, D.Scrip_Cd, CertNo, TransDate, Sett_No, Sett_Type,FLAG                
End              
Else              
begin              
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
 c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
 D.Scrip_Cd, Scrip_Name = D.Scrip_Cd+'( ' + CertNo + ')', CertNo, CQty = Sum(Qty), DQty = 0, SlipNo, DpId=BDpId, CltDpId=BCltDpID, TrType,               
 Reason = (Case When HolderName Like 'Margin%'               
                 Then 'Trans To Margin'               
                 Else 'Trans To Ben'               
           End),              
 BDpId, BCltDpId, TransDate1 = TransDate,FLAG=1                
 from #Del_TransStat D, Client2 C2, Client1 C1              
 where drcr = 'D' And ShareType <> 'AUCTION' And CertNo Like 'IN%'              
 and Delivered = 'G' And Filler2 = 0               
 And C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code               
 And TransDate >= @FromDate And TransDate <= @ToDate              
 And d.Party_Code >= @FromParty And d.Party_Code <= @ToParty              
 And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip              
 And HolderName Like '%' + RTrim(LTRim(@CltDpId)) + '%'              
 And HolderName Not Like 'MARGIN%'                  
 --And Sett_No <> '2000000'                  
 AND c1.branch_cd like (case when @statusid = 'branch' then @statusname else '%' end)              
 AND c1.sub_broker like (case when @statusid = 'subbroker' then @statusname else '%' end)              
 AND c1.trader like (case when @statusid = 'trader' then @statusname else '%' end)              
 AND c1.family like (case when @statusid = 'family' then @statusname else '%' end)              
 AND c2.party_code like (case when @statusid = 'client' then @statusname else '%' end)               
              
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
 c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
 D.Scrip_Cd, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId, HolderName               
 Union All              
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
 c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
 D.Scrip_Cd, Scrip_Name = D.Scrip_Cd+'( ' + CertNo + ')', CertNo, CQty = Sum(Qty), DQty = 0, SlipNo, DpId=DpId, CltDpId=CltDpID, TrType,               
 Reason , BDpId, BCltDpId, TransDate1 = TransDate,FLAG=2                
 from #Del_TransStat D, Client2 C2, Client1 C1              
 where drcr = 'C' And ShareType <> 'AUCTION' And CertNo Like 'IN%'              
 /*and Delivered = '0' */And Filler2 = 1               
 And C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code               
 And TransDate >= @FromDate And TransDate <= @ToDate              
 And d.Party_Code >= @FromParty And d.Party_Code <= @ToParty              
 And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip              
 And BDpId = @DpId And BCltDpId = @CltDpId           
 /*And Sett_No = '2000000' */ AND FILLER1 NOT IN ('SPLIT','BONUS')              
              
 AND c1.branch_cd like (case when @statusid = 'branch' then @statusname else '%' end)              
 AND c1.sub_broker like (case when @statusid = 'subbroker' then @statusname else '%' end)              
 AND c1.trader like (case when @statusid = 'trader' then @statusname else '%' end)              
 AND c1.family like (case when @statusid = 'family' then @statusname else '%' end)              
 AND c2.party_code like (case when @statusid = 'client' then @statusname else '%' end)               
              
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,           
 c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
 D.Scrip_Cd, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId ,Reason              
 Union All              
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
 c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
 D.Scrip_Cd, Scrip_Name = D.Scrip_Cd+'( ' + CertNo + ')', CertNo, CQty = Sum(Qty), DQty = 0, SlipNo=0, DpId='', CltDpId='', TrType,               
 Reason , BDpId, BCltDpId, TransDate1 = TransDate,FLAG=3                
 from #Del_TransStat D, Client2 C2, Client1 C1              
 where drcr = 'C' And ShareType <> 'AUCTION' And CertNo Like 'IN%'              
 and Delivered = '0' And Filler2 = 1               
 And C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code               
 And TransDate >= @FromDate And TransDate <= @ToDate              
 And d.Party_Code >= @FromParty And d.Party_Code <= @ToParty              
 And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip              
 And BDpId = @DpId And BCltDpId = @CltDpId           
 AND FILLER1 IN ('SPLIT','BONUS')              
              
 AND c1.branch_cd like (case when @statusid = 'branch' then @statusname else '%' end)              
 AND c1.sub_broker like (case when @statusid = 'subbroker' then @statusname else '%' end)              
 AND c1.trader like (case when @statusid = 'trader' then @statusname else '%' end)              
 AND c1.family like (case when @statusid = 'family' then @statusname else '%' end)              
 AND c2.party_code like (case when @statusid = 'client' then @statusname else '%' end)               
              
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
 c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
 D.Scrip_Cd, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId ,Reason              
 Union All              
 select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,              
 c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
 D.Scrip_Cd, Scrip_Name = D.Scrip_Cd+'( ' + CertNo + ')', CertNo, CQty = 0, DQty = Sum(Qty), SlipNo=(CASE WHEN FILLER1 = 'SPLIT' THEN 0 ELSE SLIPNO END),               
 DpId = (Case When TrType in (1000,907,908) then ''               
          When filler1 = 'split'  Then ''              
          when filler1 Like 'Change To%' Then ''              
          Else DpId end),               
 CltDpId = (Case When TrType in (1000,907,908) then ''               
   When filler1 = 'split'  Then ''               
                when filler1 Like 'Change To%' Then ''               
   else CltDpId end),TrType,               
 Reason = (Case When TrType in (1000,907,908)              
         Then 'Trans To Pool - ' + ISett_No + '-' + ISett_Type               
         Else (case when filler1 = 'split'               
              then 'CORPORATE ACTION'               
              when filler1 Like 'Change To%'              
              then Filler1                 
              /*when filler1 Like 'Change From%'              
              then 'Pay-Out'   */              
              Else (Case When Reason = 'DEMAT' Then 'Pay-Out' Else Reason End) end)              
           End), BDpId, BCltDpId, TransDate1 = TransDate,FLAG=4                
 from #Del_TransStat D, Client2 C2, Client1 C1              
 where filler2 = 1 and drcr = 'D' and Delivered <> '0'               
 And ShareType <> 'AUCTION' And CertNo Like 'IN%'              
 And C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code               
 And TransDate >= @FromDate And TransDate <= @ToDate              
 And d.Party_Code >= @FromParty And d.Party_Code <= @ToParty              
 And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip              
 And BDpId = @DpId And BCltDpId = @CltDpId                 
 AND c1.branch_cd like (case when @statusid = 'branch' then @statusname else '%' end)              
 AND c1.sub_broker like (case when @statusid = 'subbroker' then @statusname else '%' end)              
 AND c1.trader like (case when @statusid = 'trader' then @statusname else '%' end)              
 AND c1.family like (case when @statusid = 'family' then @statusname else '%' end)              
 AND c2.party_code like (case when @statusid = 'client' then @statusname else '%' end)               
 And HolderName Not Like 'MARGIN%'              
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
 c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
 D.Scrip_Cd, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId ,FILLER1, reason              
 Union All              
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
 c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
 D.Scrip_Cd, Scrip_Name = D.Scrip_Cd+'( ' + CertNo + ')', CertNo, CQty = 0, DQty = Sum(Qty), SlipNo, DpId=dp.DpId, CltDpId=dp.dpcltno, TrType,               
 Reason = (Case When HolderName Like 'Margin%'               
                 Then 'Trans To Margin'               
                 Else 'Trans To Ben'               
           End),              
 BDpId, BCltDpId, TransDate1 = TransDate,FLAG=1              
 from #Del_TransStat D, Client2 C2, Client1 C1, deliverydp dp              
 where drcr = 'D' And ShareType <> 'AUCTION' And CertNo Like 'IN%'              
 and Delivered = 'G' And Filler2 = 0               
 And C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code               
 And TransDate >= @FromDate And TransDate <= @ToDate              
 And d.Party_Code >= @FromParty And d.Party_Code <= @ToParty              
 And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip              
 And BDpId = @DpId And BCltDpId = @CltDpId           
 and ( holdername like 'ben ' + Dp.DpCltNo Or holdername like 'Margin ' + Dp.DpCltNo )              
 AND c1.branch_cd like (case when @statusid = 'branch' then @statusname else '%' end)              
 AND c1.sub_broker like (case when @statusid = 'subbroker' then @statusname else '%' end)              
 AND c1.trader like (case when @statusid = 'trader' then @statusname else '%' end)              
 AND c1.family like (case when @statusid = 'family' then @statusname else '%' end)              
 AND c2.party_code like (case when @statusid = 'client' then @statusname else '%' end)               
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code, C1.Long_Name,               
 c1.L_ADDRESS1, c1.L_ADDRESS2, c1.L_ADDRESS3, c1.l_city, c1.L_State, c1.L_ZIP, c1.Family,              
 D.Scrip_Cd, CertNo, SlipNo, TrType, dp.dpid, dpcltno , ISett_No, ISett_Type, BDpId, BCltDpId, HolderName              
 Order By D.Scrip_Cd, CertNo, TransDate, Sett_No, Sett_Type, D.Party_Code              
End              
            
Drop Table #Del_TransStat

GO
