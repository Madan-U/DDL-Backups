-- Object: PROCEDURE dbo.Rpt_acc_partyledger_ccpl
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--Exec rpt_acc_partyledger_all 'Aug  1 2007','Aug  8 2007','0000','zzzz','ACCODE','vdt','broker','broker','', 'N','N'      
      
      
      
--Exec rpt_acc_partyledger 'Jan  1 2007','Jan 25 2007','051','051','ACCODE','vdt','broker','broker',''            
            
CREATE Procedure [dbo].[Rpt_acc_partyledger_ccpl]            
(              
 @Fdate Varchar(11),            /* As Mmm Dd Yyyy */                    
 @Tdate Varchar(11),            /* As Mmm Dd Yyyy */                    
 @Fcode Varchar(10),                    
 @Tcode Varchar(10),                    
 @Strorder Varchar(6),                    
 @Selectby Varchar(3),                    
 @Statusid Varchar(15),                    
 @Statusname Varchar(15),                    
 @Strbranch Varchar(10)                    
)              
              
As                    
                    
/*========================================================================              
      Exec rpt_acc_partyledger_all               
            'Nov  1 2005',              
            'Dec 31 2005',              
            'a',              
            'zzz',              
            'ACCODE',              
            'vdt',              
            'broker',              
            'undefined',              
            ''              
========================================================================*/              
              
Declare               
 @@Opendate   As Varchar(11)                    
                    
Set Transaction Isolation Level Read Uncommitted                    
                    
                    
/*getting Last Opening Date */                    
      If Upper(@Selectby) = 'Vdt'                    
      Begin                    
            SELECT               
                  @@Opendate =               
                  (               
                        SELECT               
                              Left(Convert(Varchar, Isnull(Max(Vdt), 0), 109), 11)               
                        FROM Ledger WITH(NoLock)               
                        WHERE Vtyp = 18               
                              AND Vdt < = @Fdate               
                  )               
      End                    
      Else                    
      Begin                    
            SELECT               
                  @@Opendate =               
                  (               
                        SELECT               
                              Left(Convert(Varchar, Isnull(Max(Edt), 0), 109), 11)               
                        FROM Ledger WITH(NoLock)               
                        WHERE Vtyp = 18               
                              AND Edt < = @Fdate               
                  )               
      End                    
                          
                    
      /*creating Blank Table For Opening Balance*/                    
            SELECT               
                  Cltcode,               
                  Oppbal = Vamt               
            INTO #oppbalance               
            FROM Ledger WITH(NoLock)               
            WHERE 1 = 2               
                          
                    
      /*getting Opening Balance*/                    
      If @Selectby = 'Vdt'                    
      Begin                    
            If @@Opendate = @Fdate                     
            Begin                    
                  INSERT               
                  INTO #oppbalance               
                  SELECT               
                        Cltcode,               
                        Oppbal = Isnull(Sum(               
                        CASE               
                              WHEN Upper(B.Drcr) = 'D'               
                              THEN B.Vamt               
                              ELSE -b.Vamt               
                        END              
                        ), 0)               
                  FROM Ledger B WITH(NoLock)               
                  WHERE B.Cltcode > = @Fcode               
                        AND B.Cltcode < = @Tcode               
                        AND B.Vdt Like @Fdate + '%'               
                        AND Vtyp = 18               
                  GROUP BY Cltcode               
            End                    
            Else                    
            Begin                    
                  INSERT               
                  INTO #oppbalance               
                  SELECT          
                        Cltcode,               
                        Oppbal = Isnull(Sum(               
                        CASE               
                              WHEN Upper(B.Drcr) = 'D'               
                       THEN B.Vamt               
                              ELSE -b.Vamt               
                        END              
                        ), 0)               
                  FROM Ledger B WITH(NoLock)                         WHERE B.Cltcode > = @Fcode               
                        AND B.Cltcode < = @Tcode               
                        AND B.Vdt > = @@Opendate + ' 00:00:00'               
                        AND Vdt < @Fdate               
               GROUP BY Cltcode               
            End                    
      End                     
      Else                    
      Begin                     
            If @@Opendate = @Fdate                     
            Begin                  
                  INSERT               
                  INTO #oppbalance               
                  SELECT               
                        Cltcode,               
Opbal = Sum(Opbal)               
                  FROM               
                        (               
                              SELECT               
                                    Cltcode,               
                                    Opbal = Isnull(Sum(               
                                    CASE               
                                          WHEN Upper(Drcr) = 'D'               
                                          THEN Vamt               
                                          ELSE -vamt               
                                    END              
                                    ), 0)               
                              FROM Ledger WITH(NoLock)               
                              WHERE Cltcode = @Fcode               
                                    AND Edt Like @@Opendate + '%'               
                                    AND Vtyp = 18               
                              GROUP BY Cltcode               
                              UNION ALL               
                              SELECT               
                                    Cltcode,               
                                    Oppbal = Isnull(Sum(               
                                    CASE               
                                          WHEN Upper(B.Drcr) = 'C'               
                                          THEN B.Vamt               
                                          ELSE -b.Vamt               
                                    END              
                                    ), 0)               
                              FROM Ledger B WITH(NoLock)               
                              WHERE B.Cltcode > = @Fcode               
                                    AND B.Cltcode < = @Tcode               
                                    AND B.Vdt < @@Opendate              
                                    AND Edt >= @@Opendate               
                              GROUP BY Cltcode               
                        )               
                        T               
                  GROUP BY Cltcode               
            End                  
            Else                  
            Begin                  
                  INSERT         
                  INTO #oppbalance               
                  SELECT               
                        Cltcode,               
                        Opbal = Sum(Opbal)               
                  FROM               
                        (               
                              SELECT               
                Cltcode,               
                                    Opbal = Isnull(Sum(               
                                    CASE               
                                          WHEN Upper(Drcr) = 'D'               
                                          THEN Vamt               
                                          ELSE -vamt         
                                    END              
                                    ), 0)               
               FROM Ledger WITH(NoLock)               
                              WHERE Cltcode = @Fcode               
                                    AND Edt Like @@Opendate + '%'               
                                    AND Vtyp = 18               
                              GROUP BY Cltcode               
                              UNION ALL               
                   SELECT               
                                    Cltcode,               
                                    Opbal = Sum(               
                                    CASE               
                                          WHEN Upper(Drcr) = 'D'               
                                          THEN Vamt               
                                          ELSE -vamt             
                                    END              
                                    )               
                              FROM Ledger WITH(NoLock)               
                              WHERE Cltcode = @Fcode               
                                    AND Edt > = @@Opendate + ' 00:00:00'               
                                    AND Edt < @Fdate               
                                    AND Vtyp <> 18               
                              GROUP BY Cltcode               
                              UNION ALL               
                              SELECT               
                                    Cltcode,               
                                    Oppbal = Isnull(Sum(               
                                    CASE               
                                          WHEN Upper(B.Drcr) = 'C'               
                                          THEN B.Vamt               
      ELSE -b.Vamt               
                                    END              
                                    ), 0)               
                              FROM Ledger B WITH(NoLock)               
                              WHERE B.Cltcode > = @Fcode               
                                    AND B.Cltcode < = @Tcode               
                                    AND B.Vdt < @@Opendate               
                                    AND Edt >= @@Opendate               
                              GROUP BY Cltcode               
                        )               
                        T               
                  GROUP BY Cltcode               
            End                  
      End                    
                          
                    
      /*generating Blank Structure For Filtered Ledger */                    
            SELECT               
                  Vtyp,Vno,Edt,Lno,Acname,Drcr,Vamt,Vdt,Vno1,Refno,Balamt,Nodays,Cdt,Cltcode,Booktype,Enteredby,Pdt,Checkedby,Actnodays,L.Narration,               
                  Shortdesc = Space(35)               
            INTO #ledgerdata               
            FROM Ledger L WITH(NoLock)               
            WHERE 1 = 2               
      
                         
                    
                    
      /*getting Fiiltered Ledger*/                    
      If @Selectby = 'Vdt'         
      Begin                    
            INSERT               
            INTO #ledgerdata               
            SELECT               
                  Vtyp,Vno,Edt,Lno,Acname,Drcr,Vamt,Vdt,Vno1,Refno,Balamt,Nodays,Cdt,Cltcode,Booktype,Enteredby,Pdt,Checkedby,Actnodays,L.Narration,               
                  Isnull(V.Shortdesc, '') Shortdesc               
            FROM Ledger L WITH(NoLock),               
                  Vmast V WITH(NoLock)             
            WHERE Vdt > = @Fdate + ' 00:00:00'               
                  AND L.Vtyp = V.Vtype               
                  AND Vdt < = @Tdate +' 23:59:59'               
                  AND Cltcode > = @Fcode               
                  AND Cltcode < = @Tcode               
      End                     
      Else                    
      Begin                    
            INSERT               
            INTO #ledgerdata               
            SELECT               
                  Vtyp,Vno,Edt,Lno,Acname,Drcr,Vamt,Vdt,Vno1,Refno,Balamt,Nodays,Cdt,Cltcode,Booktype,Enteredby,Pdt,Checkedby,Actnodays,L.Narration,               
                  Isnull(V.Shortdesc, '') Shortdesc               
            FROM Ledger L WITH(NoLock),               
                  Vmast V WITH(NoLock)               
            WHERE Edt > = @Fdate + ' 00:00:00'               
                  AND L.Vtyp = V.Vtype               
                  AND Edt < = @Tdate +' 23:59:59'               
                  AND Cltcode > = @Fcode               
                  AND Cltcode < = @Tcode               
      End                    
                    
              
              
/*getting Client List*/                    
      SELECT               
            C2.Party_code,              
   C1.Long_Name,              
            Bank_name = Isnull(C4.Bankid, ''),               
            L_address1,               
            L_address2,               
            L_address3,               
            L_city,               
            L_zip,               
            Res_phone1,               
            C1.Branch_cd,               
           Family,               
            C1.Sub_broker,               
            Trader,               
            Cl_type,               
            Cltdpid = Isnull(Cltdpid, '')               
      INTO #ledgerclients               
      FROM Msajag.Dbo.Client1 C1 WITH(NoLock),               
    Msajag.Dbo.Client5 C5 WITH(NoLock),               
          Msajag.Dbo.Client2 C2 WITH(NoLock)               
          LEFT OUTER JOIN               
            Msajag.Dbo.Client4 C4 WITH(NoLock)               
            ON               
            (              
                  C2.Party_code = C4.Party_code               
                  AND Depository Not In ('Nsdl', 'Cdsl')               
-- AND Defdp = 1              
                  AND Defdp = 0          
            )               
      WHERE C1.Cl_code = C2.Cl_code               
        AND C1.CL_CODE = C5.CL_CODE  
     AND INACTIVEFROM >= GETDATE()   
            AND C1.Branch_cd Like (              
            CASE               
                  WHEN @Statusid = 'Branch'               
                  THEN @Statusname               
                  ELSE '%'               
            END              
            )               
            AND Sub_broker Like (              
            CASE               
                  WHEN @Statusid = 'Sub_broker'               
                  THEN @Statusname               
                  ELSE '%'               
            END              
            )               
     AND Sub_broker Like (              
            CASE               
                  WHEN @Statusid = 'Subbroker'               
                  THEN @Statusname               
                  ELSE '%'               
            END              
            )               
            AND Trader Like (              
            CASE               
WHEN @Statusid = 'Trader'               
                  THEN @Statusname               
                  ELSE '%'               
            END              
            )               
            AND Area Like (              
            CASE               
                  WHEN @Statusid = 'Area'               
                  THEN @Statusname               
                  ELSE '%'               
            END              
            )         
            AND Region Like (              
            CASE               
                  WHEN @Statusid = 'Region'               
                  THEN @Statusname               
                  ELSE '%'               
            END              
            )              
            AND C1.Family Like (              
            CASE               
                  WHEN @Statusid = 'Family'               
                  THEN @Statusname               
                  ELSE '%'               
            END              
            )               
            AND C2.Party_code Like (              
            CASE               
                  WHEN @Statusid = 'Client'               
                  THEN @Statusname               
                  ELSE '%'               
            END              
         )               
            AND C1.Branch_cd Like @Strbranch +'%'               
            AND C2.Party_code > = @Fcode               
            AND C2.Party_code < = @Tcode               
              
              
      CREATE TABLE [#tmpledger] (              
       [Booktype] [char] (2)  NULL ,              
       [Voudt] [datetime] NULL ,              
       [Effdt] [datetime] NULL ,              
       [Shortdesc] [varchar] (35)  NULL ,              
       [Dramt] [money] NULL ,              
       [Cramt] [money] NULL ,              
       [Vno] [varchar] (12)  NULL ,              
       [Ddno] [varchar] (15)  NULL ,              
       [Narration] [varchar] (234)  NULL ,              
       [Cltcode] [varchar] (10)  NOT NULL ,              
       [Vtyp] [smallint] NULL ,              
      [Vdt] [varchar] (30)  NULL ,              
       [Edt] [varchar] (30)  NULL ,              
       [Acname] [varchar] (100)  NULL ,              
       [Opbal] [money] NULL ,              
       [L_address1] [varchar] (40)  NOT NULL ,              
       [L_address2] [varchar] (40)  NULL ,              
       [L_address3] [varchar] (40)  NULL ,              
       [L_city] [varchar] (40)  NULL ,              
       [L_zip] [varchar] (10)  NULL ,              
       [Res_phone1] [varchar] (15)  NULL ,              
       [Branch_cd] [varchar] (10)  NOT NULL ,              
       [Crosac] [varchar] (10)  NULL ,              
       [Ediff] [int] NULL ,              
       [Family] [varchar] (10)  NOT NULL ,              
       [Sub_broker] [varchar] (10)  NOT NULL ,              
       [Trader] [varchar] (20)  NOT NULL ,              
       [Cl_type] [varchar] (3)  NOT NULL ,              
       [Bank_name] [varchar] (50)  NOT NULL ,              
       [Cltdpid] [varchar] (16)  NOT NULL ,              
       [Lno] [int] NULL,            
       [Pdt] [datetime] NULL            
      ) ON [PRIMARY]              
              
                    
/*getting Lddger Entries*/                    
      INSERT               
            INTO #tmpledger               
      SELECT               
            L.Booktype,               
 Voudt = L.Vdt,               
            Effdt = L.Edt,               
            L.Shortdesc,               
            Dramt = (              
            CASE               
                  WHEN Upper(L.Drcr) = 'D'               
                  THEN L.Vamt               
                  ELSE 0               
            END              
            ),               
            Cramt = (              
            CASE               
                  WHEN Upper(L.Drcr) = 'C'               
                  THEN L.Vamt               
                  ELSE 0             
            END              
            ),               
            L.Vno,               
            Ddno = Space(15),               
            L.Narration,               
            C.Party_code Cltcode,               
            L.Vtyp,               
            Convert(Varchar, L.Vdt, 103) Vdt,               
            Convert(Varchar, L.Edt, 103) Edt,               
--            L.Acname ,               
            C.Long_Name,              
            Opbal = Vamt,               
            C.L_address1,               
            C.L_address2,               
            C.L_address3,               
            C.L_city,               
            C.L_zip,               
            C.Res_phone1,               
            C.Branch_cd,               
            L.Cltcode Crosac ,               
            Ediff = Datediff(D, L.Edt, Getdate()),               
            C.Family,               
            C.Sub_broker,               
            C.Trader,        
            C.Cl_type,               
            C.Bank_name,               
            C.Cltdpid,               
            L.Lno,            
  L.Pdt               
      FROM #ledgerdata L WITH(NoLock)               
      RIGHT OUTER JOIN               
            #ledgerclients C WITH(NoLock)               
            ON               
            (              
                  L.Cltcode = C.Party_code              
            )               
              
              
                    
/*updating Opening Blanace*/                    
      UPDATE               
            #tmpledger               
            SET Opbal = 0               
              
      UPDATE               
            #tmpledger               
            SET Opbal = T.Oppbal               
      FROM #tmpledger L WITH(NoLock),               
            #oppbalance T WITH(NoLock)               
      WHERE L.Cltcode = T.Cltcode               
                    
              
              
/*updating Cheque Number*/                    
      UPDATE               
            #tmpledger               
            SET Ddno = L1.Ddno               
      FROM Ledger1 L1 WITH(NoLock)               
      WHERE L1.Vno = #tmpledger.Vno               
            AND L1.Vtyp = #tmpledger.Vtyp               
            AND L1.Booktype = #tmpledger.Booktype               
            AND L1.Lno = #tmpledger.Lno               
                    
              
              
/*updating Cross Account Code*/                    
      UPDATE               
       #tmpledger               
            SET #tmpledger.Crosac = B.Cltcode               
      FROM Ledger B WITH(NoLock),               
            Acmast V WITH(NoLock)               
      WHERE B.Cltcode = V.Cltcode               
            AND V.Accat = 2               
            AND #tmpledger.Booktype = B.Booktype               
            AND #tmpledger.Vno = B.Vno               
            AND #tmpledger.Vtyp = B.Vtyp               
            AND Ltrim(Rtrim(#tmpledger.Vtyp)) In ('01', '1', '02', '2', '03', '3', '04', '4', '05', '5', '16', '17', '19', '20', '22', '23')               
                    
              
              
/*updating Bank Name*/                                   
      UPDATE               
            #tmpledger               
            SET #tmpledger.Bank_name = B.Bank_name               
      FROM Msajag.Dbo.Pobank B WITH(NoLock)               
      WHERE Ltrim(Rtrim(Cast(B.Bankid AS Char))) = Ltrim(Rtrim(#tmpledger.Bank_name))               
              
                    
      If @Strorder = 'Accode'                    
      Begin                    
            If @Selectby = 'Vdt'                    
            Begin                     
                  SELECT               
                        L.*               
                  FROM #tmpledger L WITH(NoLock),               
                        Acmast A WITH(NoLock)               
                  WHERE L.Cltcode = A.Cltcode               
         AND Accat In ('4', '104')               
    AND (cramt <> 0 or dramt <> 0 or opbal <> 0)              
                  ORDER BY L.Cltcode,            
                        Voudt, Pdt            
            End                    
            Else                    
            Begin                    
                  SELECT               
                        L.*               
                  FROM #tmpledger L WITH(NoLock),               
                        Acmast A WITH(NoLock)               
                  WHERE L.Cltcode = A.Cltcode               
                        AND Accat In ('4', '104')               
                  ORDER BY L.Cltcode,              
                        Effdt, Pdt            
            End                    
      End                    
      Else                    
      Begin                    
            If @Selectby = 'Vdt'                    
            Begin                     
                  SELECT               
                        L.*               
                  FROM #tmpledger L WITH(NoLock),               
                        Acmast A WITH(NoLock)               
                  WHERE L.Cltcode = A.Cltcode               
                        AND Accat In ('4', '104')           
                  ORDER BY L.Acname,             
                        Voudt, Pdt               
            End                    
            Else                    
            Begin                    
                  SELECT               
                        L.*               
                  FROM #tmpledger L WITH(NoLock),               
                        Acmast A WITH(NoLock)               
                  WHERE L.Cltcode = A.Cltcode               
                        AND Accat In ('4', '104')               
                  ORDER BY L.Acname,              
                        Effdt, Pdt            
            End                    
      End                    
                    
/*  ------------------------------   End Of The Proc  -------------------------------------*/

GO
