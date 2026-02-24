-- Object: PROCEDURE dbo.Usp_NBFC_OtherSegmentBal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE Proc [dbo].[Usp_NBFC_OtherSegmentBal]    
As    
BEGIN    
  
 truncate table NBFC_OtherSegmentBal  
    
 select (clientcode) as party_code  into #party from    
 ABVSCITRUS.nbfc.dbo.ANG_NBFCCLIENTS where ACCOUNTTYPE='POA' and  INACTIVEDATE > getdate()    
    
 Create index #p on  #party(party_code)    
    
 Declare @finyear datetime,@todate datetime    
    
 Select @finyear=Sdtcur from account.dbo.parameter  where getdate() between sdtcur and Ldtcur    
    
 Set @todate =getdate()    
    
    
 Select Cltcode,Vamt=Sum(Case when drcr='C' then vamt else vamt*-1 end),'NSECURFO' as exchange  INTO #Led_BAL    
 from angelfo.Accountcurfo.dbo.ledger l with(nolock),#party p with(nolock)    
 where Vdt >=@finyear and Vdt<=@todate and l.cltcode =p.party_code    
 group by Cltcode     
 having Sum(Case when drcr='C' then vamt else vamt*-1 end)  <>0    
      
 INSERT INTO #Led_BAL    
 Select Cltcode,Vamt=Sum(Case when drcr='C' then vamt else vamt*-1 end) ,'NSEFO' as exchange    
 from angelfo.Accountfo.dbo.ledger l with(nolock),#party p with(nolock)    
 where Vdt >=@finyear and Vdt<=@todate and l.cltcode =p.party_code    
 group by Cltcode     
 having Sum(Case when drcr='C' then vamt else vamt*-1 end)  <>0    
    
 INSERT INTO #Led_BAL     
 Select Cltcode,Vamt=Sum(Case when drcr='C' then vamt else vamt*-1 end) ,'MCX' as exchange    
 from angelcommodity.AccountMCDx.dbo.ledger l with(nolock),#party p with(nolock)    
 where Vdt >=@finyear and Vdt<=@todate and l.cltcode =p.party_code    
 group by Cltcode     
 having Sum(Case when drcr='C' then vamt else vamt*-1 end)  <>0    
    
 INSERT INTO #Led_BAL     
 Select Cltcode,Vamt=Sum(Case when drcr='C' then vamt else vamt*-1 end) ,'NCX' as exchange    
 from angelcommodity.AccountNCDx.dbo.ledger l with(nolock),#party p with(nolock)    
 where Vdt >=@finyear and Vdt<=@todate and l.cltcode =p.party_code    
 group by Cltcode     
 having Sum(Case when drcr='C' then vamt else vamt*-1 end)  <>0    
    
 INSERT INTO #Led_BAL     
 Select Cltcode,Vamt=Sum(Case when drcr='C' then vamt else vamt*-1 end) ,'MCDxCDS' as exchange    
 from angelcommodity.AccountMCDXCDS.dbo.ledger l with(nolock),#party p with(nolock)    
 where Vdt >=@finyear and Vdt<=@todate and l.cltcode =p.party_code    
 group by Cltcode     
 having Sum(Case when drcr='C' then vamt else vamt*-1 end)  <>0    
    
    
 INSERT INTO #Led_BAL     
 Select Cltcode,Vamt=Sum(Case when drcr='C' then vamt else vamt*-1 end) ,'BFO' as exchange    
 from angelcommodity.ACCOUNTBFO.dbo.ledger l with(nolock),#party p with(nolock)    
 where Vdt >=@finyear and Vdt<=@todate and l.cltcode =p.party_code    
 group by Cltcode     
 having Sum(Case when drcr='C' then vamt else vamt*-1 end)  <>0    
    
 INSERT INTO #Led_BAL     
 Select Cltcode,Vamt=Sum(Case when drcr='C' then vamt else vamt*-1 end) ,'BSECurfo' as exchange    
 from angelcommodity.ACCOUNTcurBFO.dbo.ledger l with(nolock),#party p with(nolock)    
 where Vdt >=@finyear and Vdt<=@todate and l.cltcode =p.party_code    
 group by Cltcode     
 having Sum(Case when drcr='C' then vamt else vamt*-1 end)  <>0    
    
 insert into NBFC_OtherSegmentBal  
 select cltcode,SUM(Vamt) as Vamt from #Led_BAL group by Cltcode     
 having  Sum (vamt)  <>0    
    
END

GO
