-- Object: PROCEDURE dbo.rpt_GrpCombineTrialBalance
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

   --EXEC rpt_GrpCombineTrialBalance 'Apr  1 2005', 'Dec 31 2005', 'NSEFO', ''  
CREATE  Proc [dbo].[rpt_GrpCombineTrialBalance]      
(      
@FromDate varchar(11),      
@ToDate varchar(11),      
@Segment Varchar(5)='ALL',      
@BranchCd Varchar(10)=''      
)      
      
as       
      
      
Declare @CodeStrip varchar(11)      
Declare @GrpName varchar(100)      
Declare @GrpCode varchar(15)      
Declare @TBCur Cursor        
      
      
   
CREATE   
    Table #TrialBalance   
 (   
  Segment varchar(5),   
  CltCode varchar(10),   
  ACName varchar(100),   
  GrpCode varchar(20),   
  GrpName varchar(100),   
  Amount money,   
  DrAmount money,   
  CrAmount money,   
  BranchCode varchar(20)   
 )       
 if @Segment = '' begin   
  SET @Segment = 'ALL'   
 END                               
 if @Segment = 'ALL' or @Segment = 'NSECM'      
  begin      
   
   SET transaction isolation level read uncommitted   
   INSERT   
   INTO #TrialBalance   
   SELECT   
    Segment,   
    CltCode,   
    AcName,   
    A.GrpCode,   
    B.GrpName,   
    Amount = VAmt,   
    DrAmount = (  
    CASE   
     WHEN Vamt >= 0   
     THEN abs(Vamt)   
     ELSE 0   
    END  
    ),   
    CrAmount = (  
    CASE   
     WHEN Vamt < 0   
     THEN Abs(Vamt)   
     ELSE 0   
    END  
    ),   
    ''   
   FROM   
    (   
    SELECT   
     Segment = 'NSECM',   
     GrpCode = A.grpcode,   
     CltCode = a.CltCode,   
     AcName = a.acname,   
     Vamt = sUM(  
     CASE   
      WHEN DRCR = 'D'   
      THEN Vamt   
      ELSE -vamt   
     END  
     )   
    FROM account.dbo.ledger l, --with(index(ledind),nolock),       
     account.dbo.acmast a --with(index(accat),nolock)                   
    WHERE l.cltcode = a.cltcode   
     AND vdt >= @FromDate + ' 00:00:00'   
     AND vdt <= @ToDate + ' 23:59:59'   
     AND accat not in (4,104,204)   
    GROUP BY a.GrpCode,  
     A.cltcode,   
     a.ACName   
    )   
    A,   
    Account.dbo.GrpMast b (nolock)   
   WHERE a.GrpCode = b.GrpCode                                                 
               
   
    SET transaction isolation level read uncommitted   
   INSERT   
   INTO #TrialBalance   
   SELECT   
    Segment,   
    CltCode,   
    AcName,   
    A.GrpCode,   
    B.GrpName,   
    Amount = VAmt,   
    DrAmount = (  
    CASE   
     WHEN Vamt >= 0   
     THEN abs(Vamt)   
     ELSE 0   
    END  
    ),   
    CrAmount = (  
    CASE   
     WHEN Vamt < 0   
     THEN Abs(Vamt)   
     ELSE 0   
    END  
    ),   
    ''   
   FROM   
    (   
    SELECT   
     Segment = 'NSECM',   
     GrpCode = A.grpcode,   
     CltCode = 'CLIENT A/C',   
     AcName = 'CLIENT A/C - SUNDRY DEBTORS',   
     Vamt = sUM(  
     CASE   
      WHEN DRCR = 'D'   
      THEN Vamt   
      ELSE -vamt   
     END  
     )   
    FROM account.dbo.ledger l, --with(index(ledind),nolock),       
     account.dbo.acmast a --with(index(accat),nolock)                   
    WHERE l.cltcode = a.cltcode   
     AND vdt >= @FromDate + ' 00:00:00'   
     AND vdt <= @ToDate + ' 23:59:59'   
     AND accat in (4,104,204)   
    GROUP BY a.GrpCode   
    )   
    A,   
    Account.dbo.GrpMast b (nolock)   
   WHERE a.GrpCode = b.GrpCode   
  End  
                              
                        --- now doing bse      
  if @Segment = 'ALL' or @Segment = 'BSECM'      
   begin      
    INSERT   
    INTO #TrialBalance   
    SELECT   
     Segment,   
     CltCode,   
     AcName,   
     A.GrpCode,   
     B.GrpName,   
     Amount = VAmt,   
     DrAmount = (  
     CASE   
      WHEN Vamt >= 0   
      THEN abs(Vamt)   
      ELSE 0   
     END  
     ),   
     CrAmount = (  
     CASE   
      WHEN Vamt < 0   
      THEN Abs(Vamt)   
      ELSE 0   
     END  
     ),   
     ''   
    FROM   
     (   
     SELECT   
      Segment = 'BSECM',   
      GrpCode = A.grpcode,   
      CltCode = a.CltCode,   
      AcName = a.acname,   
      Vamt = sUM(  
      CASE   
       WHEN DRCR = 'D'   
       THEN Vamt   
       ELSE -vamt   
      END  
      )   
     FROM [AngelBSECM].account_ab.dbo.ledger l, --with(index(ledind),nolock),       
      [AngelBSECM].account_ab.dbo.acmast a --with(index(accat),nolock)                   
     WHERE l.cltcode = a.cltcode   
      AND vdt >= @FromDate + ' 00:00:00'   
      AND vdt <= @ToDate + ' 23:59:59'   
      AND accat not in (4,104,204)   
     GROUP BY a.GrpCode,  
      A.cltcode,   
      a.ACName   
     )   
     A,   
     [AngelBSECM].account_ab.dbo.GrpMast b (nolock)   
    WHERE a.GrpCode = b.GrpCode   
    SET transaction isolation level read uncommitted   
    INSERT   
    INTO #TrialBalance   
    SELECT   
     Segment,   
     CltCode,   
     AcName,   
     A.GrpCode,   
     B.GrpName,   
     Amount = VAmt,   
     DrAmount = (  
     CASE   
      WHEN Vamt >= 0   
      THEN abs(Vamt)   
      ELSE 0   
     END  
     ),   
     CrAmount = (  
     CASE   
      WHEN Vamt < 0   
      THEN Abs(Vamt)   
      ELSE 0   
     END  
     ),   
     ''   
    FROM   
     (   
     SELECT   
      Segment = 'BSECM',   
      GrpCode = A.grpcode,   
      CltCode = 'CLIENT A/C',   
      AcName = 'CLIENT A/C - SUNDRY DEBTORS',   
      Vamt = sUM(  
      CASE   
       WHEN DRCR = 'D'   
       THEN Vamt   
       ELSE -vamt   
      END  
      )   
     FROM [AngelBSECM].account_ab.dbo.ledger l, --with(index(ledind),nolock),       
      [AngelBSECM].account_ab.dbo.acmast a --with(index(accat),nolock)                   
     WHERE l.cltcode = a.cltcode   
      AND vdt >= @FromDate + ' 00:00:00'   
      AND vdt <= @ToDate + ' 23:59:59'   
      AND accat in (4,104,204)   
     GROUP BY a.GrpCode   
     )   
     A,   
     [AngelBSECM].account_ab.dbo.GrpMast b (nolock)   
    WHERE a.GrpCode = b.GrpCode  
                              
                                    End      
                        --- now doing fo      
/*-----------------------------COMMENTED SPECIFICALLY FOR VERSION------------------------  
  if @Segment = 'ALL' or @Segment = 'NSEFO'      
   begin      
     SET transaction isolation level read uncommitted   
    INSERT   
    INTO #TrialBalance   
    SELECT   
     Segment,   
     CltCode,   
     AcName,   
     A.GrpCode,   
     B.GrpName,   
     Amount = VAmt,   
     DrAmount = (  
     CASE   
      WHEN Vamt >= 0   
      THEN abs(Vamt)   
      ELSE 0   
     END  
     ),   
     CrAmount = (  
     CASE   
      WHEN Vamt < 0   
      THEN Abs(Vamt)   
      ELSE 0   
     END  
     ),   
     ''   
    FROM   
     (   
     SELECT   
      Segment = 'NSEFO',   
      GrpCode = A.grpcode,   
      CltCode = a.CltCode,   
      AcName = a.acname,   
      Vamt = sUM(  
      CASE   
       WHEN DRCR = 'D'   
       THEN Vamt   
       ELSE -vamt   
      END  
      )   
     FROM accountFO.dbo.ledger l, --with(index(ledind),nolock),       
      accountFO.dbo.acmast a --with(index(accat),nolock)                   
     WHERE l.cltcode = a.cltcode   
      AND vdt >= @FromDate + ' 00:00:00'   
      AND vdt <= @ToDate + ' 23:59:59'   
      AND accat not in (4,104,204)   
     GROUP BY a.GrpCode,  
      A.cltcode,   
      a.ACName   
     )   
     A,   
     accountFO.dbo.GrpMast b (nolock)   
    WHERE a.GrpCode = b.GrpCode   
  
     SET transaction isolation level read uncommitted   
    INSERT   
    INTO #TrialBalance   
    SELECT   
     Segment,   
     CltCode,   
     AcName,   
     A.GrpCode,   
     B.GrpName,   
     Amount = VAmt,   
     DrAmount = (  
     CASE   
      WHEN Vamt >= 0   
      THEN abs(Vamt)   
      ELSE 0   
     END  
     ),   
     CrAmount = (  
     CASE   
      WHEN Vamt < 0   
      THEN Abs(Vamt)   
      ELSE 0   
     END  
     ),   
     ''   
    FROM   
     (   
     SELECT   
      Segment = 'NSEFO',   
      GrpCode = A.grpcode,   
      CltCode = 'CLIENT A/C',   
      AcName = 'CLIENT A/C - SUNDRY DEBTORS',   
      Vamt = sUM(  
      CASE   
       WHEN DRCR = 'D'   
       THEN Vamt   
       ELSE -vamt   
      END  
      )   
     FROM accountFO.dbo.ledger l, --with(index(ledind),nolock),       
      accountFO.dbo.acmast a --with(index(accat),nolock)                   
     WHERE l.cltcode = a.cltcode   
      AND vdt >= @FromDate + ' 00:00:00'   
      AND vdt <= @ToDate + ' 23:59:59'   
      AND accat in (4,104,204)   
     GROUP BY a.GrpCode   
     )   
     A,   
     accountFO.dbo.GrpMast b (nolock)   
    WHERE a.GrpCode = b.GrpCode  
   End      
*/  
-- NOW GETTING FORMATTED VALUES            
 CREATE   
  Table #TBOutput   
  (   
   SNO bigint identity(1,1),   
   Segment varchar(5),   
   LevelCode varchar(15),   
   CltCode varchar(20),   
   AcName varchar(100),   
   Amount money,   
   DrAmount money,   
   CrAmount money   
  )  
      
 SET @TBCur = Cursor for   
 SELECT   
  GrpCode,   
  GrpName,   
  CodeStrip   
 FROM   
  (   
  SELECT   
   grpcode,   
   grpname,   
   CodeStrip = replace(replace(replace(replace(replace(replace(replace(replace(Replace(grpcode,'0000000000',''),'000000000',''),'00000000',''),'0000000',''),'000000',''),'00000',''),'0000',''),'000',''),'00','')   
  FROM account.dbo.grpmast   
  UNION   
  SELECT   
   grpcode,   
   grpname,   
   CodeStrip = replace(replace(replace(replace(replace(replace(replace(replace(Replace(grpcode,'0000000000',''),'000000000',''),'00000000',''),'0000000',''),'000000',''),'00000',''),'0000',''),'000',''),'00','')   
  FROM [AngelBSECM].account_ab.dbo.grpmast   
/*  UNION   
  SELECT   
   grpcode,   
   grpname,   
   CodeStrip = replace(replace(replace(replace(replace(replace(replace(replace(Replace(grpcode,'0000000000',''),'000000000',''),'00000000',''),'0000000',''),'000000',''),'00000',''),'0000',''),'000',''),'00','')   
  FROM accountfo.dbo.grpmast */  
  )   
  A   
 ORDER BY GrpCode   
 Open @TBCur Fetch Next   
 FROM @TBCur   
 INTO @GrpCode, @GrpName, @CodeStrip  
 While @@Fetch_Status = 0  
  Begin   
   INSERT   
   INTO #TBOutput   
   SELECT   
    '',   
    @CodeStrip,   
    CltCode,   
    AcName = LEFT(AcName,90)+'~'+Segment,   
    Sum(Amount),   
    Sum(DrAmount),   
    Sum(CrAmount)   
   FROM #TrialBalance   
   WHERE GrpCode = @GrpCode   
   GROUP BY CltCode,   
    LEFT(AcName,90)+'~'+Segment Fetch Next   
   FROM @TBCur   
   INTO @GrpCode,   
    @GrpName,   
    @CodeStrip   
  END   
  Select * From #TbOutPut  
  Return      
  Close @TBCur        
  Deallocate @TBCur        
 Drop Table #TrialBalance      
 SELECT   
  SNo,   
  LevelCode,   
  CltCode,   
  AcName,   
  Amount,   
  DrAmount,   
  CrAmount   
 FROM #TBOutput   
 WHERE isnull(amount,0) <> 0   
  OR isnull(DrAmount,0) <> 0   
  OR isnull(CrAmount,0) <> 0   
 ORDER BY Sno

GO
