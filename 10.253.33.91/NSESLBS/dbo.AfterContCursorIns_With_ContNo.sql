-- Object: PROCEDURE dbo.AfterContCursorIns_With_ContNo
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE  PROCEDURE AfterContCurSorIns_With_ContNo(
               @orderno    VARCHAR(16),
               @tradeno    VARCHAR(20),
               @partycd    VARCHAR(10),
               @scripcd    VARCHAR(10),
               @tdate      VARCHAR(11),
               @mkrate     FLOAT,
               @sellbuy    VARCHAR(2),
               @sett_type  VARCHAR(2),
               @tmark      VARCHAR(2),
               @flag       INT,
               @Memcode    VARCHAR(15),
               @TerminalId AS VARCHAR(10),
               @ToParty    AS VARCHAR(10),
               @TQty       INT,
               @ContractNo VARCHAR(7),
               @StatusName VarChar(50) = 'BROKER',    
  	       @FromWhere VarChar(50) = 'NOLOG' )
AS
  DECLARE  @@ContractNo     VARCHAR(7),
           @@Cont           CURSOR,
           @@CNo            CURSOR,
           @@TNo            CURSOR,
           /* @@Ttrade_no Varchar(14), */
           
           @@trade_no       VARCHAR(20),
           @@Xtradeno       VARCHAR(20),
           @@tradeqty       INT,
           @@marketrate     MONEY,
           @@netrate        MONEY,
           @@TFlag          INT,
           @@Sett_no        VARCHAR(10),
           @@getStyle        AS CURSOR,
           @@Dcontno         AS INT,
           @@YContno         AS INT,
           @@Style           AS INT,
           @@ContStyle       AS VARCHAR(2),
           @@SameParty       AS CHAR(1),
           @@MemberCode      AS VARCHAR(10),
           @@Tempcontractno  AS INT,
           @@Myqty           AS INT,
           @@TTradeNo        AS VARCHAR(20),
           @net_rate        MONEY,
           @orig_mkt_rate   MONEY,
           @orig_qty        BIGINT,
           @qty             BIGINT/*,
@net_rate money*/
  SET NoCount  ON
  SELECT @qty = @TQty
  SELECT   DISTINCT @net_rate = NetRate,
                    @orig_mkt_rate = MarketRate
  FROM     IsettleMent
  WHERE    CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
  GROUP BY NetRate,
           MarketRate
  IF len(@Orderno) = 0
    BEGIN
      SELECT @orderno = '%'
    END
  SET @@MyQty = @Tqty
  SELECT @Tdate = Ltrim(Rtrim(@Tdate))
  IF len(@Tdate) = 10
    BEGIN
      SELECT @Tdate = Stuff(@Tdate,4,1,'  ')
    END
  IF @Partycd = @Toparty
    SELECT @@Sameparty = 'Y'
  ELSE
    SELECT @@Sameparty = 'N'
  SELECT Top 1  @@Sett_no = Sett_No
  FROM   IsettleMent
  WHERE  IsettleMent.Party_Code = @partycd
         AND sauda_Date LIKE @TDate + '%'
         AND Sett_Type LIKE @sett_type
         AND Scrip_cd LIKE @ScripCd
  SELECT @@ContStyle = InsCont
  FROM   Client1,
         Client2
  WHERE  Client2.Party_Code = @toparty
         AND Client1.cl_Code = Client2.cl_Code
  SELECT @@ContStyle
  SELECT @@Style = Style,
         @@MemberCode = MemberCode
  FROM   Owner
  SELECT @@ContractNo = (CASE 
                           WHEN Client1.cl_Type = 'PRO' THEN 'PRO'
                         END)
  FROM   Client2,
         Client1
  WHERE  Client2.Party_Code = @ToParty
         AND Client1.cl_Code = Client2.cl_Code
  IF @@Contractno = 'PRO'
    BEGIN
      SELECT @@Contractno = '0000000'
    END
  ELSE
    BEGIN
      IF (@@ContStyle = 'O')
         AND (@Flag < 3)
         AND (@@Sameparty = 'N')
        BEGIN
          SELECT @@contractno = CONVERT(BIGINT,ContractNo)
          FROM   IsettleMent
          WHERE  IsettleMent.Party_Code = @Toparty
                 AND sauda_Date LIKE @TDate + '%'
                 AND Sett_Type LIKE @sett_type
                 AND Sett_No = @@Sett_no
                 AND Order_No = @Orderno
                                --   /*ADDED BY SHYAM*/
                                --   and contractno = @ContractNo
                                --   /*END - ADDED BY SHYAM*/
          IF ((@@ContractNo IS NULL )
              AND (@@Contstyle = 'O'))
            BEGIN
              IF @@style = 0
                BEGIN
                  SELECT @@ContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
                  FROM   IsettleMent
                  WHERE  sauda_Date LIKE @TDate + '%'
                         AND Sett_Type LIKE @sett_type
                         AND Sett_No = @@Sett_no
                                       --           /*ADDED BY SHYAM*/
                                       --           and contractno = @ContractNo
                                       --           /*END - ADDED BY SHYAM*/
                  SELECT @@TempContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
                  FROM   IsettleMent
                  WHERE  sauda_Date LIKE @TDate + '%'
                         AND Sett_Type LIKE @sett_type
                         AND Sett_No = @@Sett_no
                                       /*ADDED BY SHYAM*/
                         AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                          /*END - ADDED BY SHYAM*/
                  IF @@TempContractno > @@Contractno
                    BEGIN
                      SET @@Contractno = @@TempContractno
                    END
                END
              ELSE
                IF @@Style = 1
                  BEGIN
                    SELECT @@ContractNo = CONVERT(BIGINT,ContractNo) + 1
                    FROM   Contgen
                    WHERE  @tdate + ' 00:00:01' >= Start_Date
                           AND @tdate + ' 00:00:01' <= End_Date
                                                       --            /*ADDED BY SHYAM*/
                                                       --            and contractno = @ContractNo
                                                       --            /*END - ADDED BY SHYAM*/
                  END
              IF @@ContractNo > 0
                BEGIN
                  UPDATE Contgen
                  SET    ContractNo = @@ContractNo
                  WHERE  @tdate + ' 00:00:01' >= Start_Date
                         AND @tdate + ' 00:00:01' <= End_Date
                                                     --            /*ADDED BY SHYAM*/
                                                     --            and contractno = @ContractNo
                                                     --            /*END - ADDED BY SHYAM*/
                END
            END
        END
      IF (@@ContStyle = 'N')
         AND (@Flag < 3)
         AND (@@Sameparty = 'N')
        BEGIN
        --               Print 'In contstyle = N'
          SELECT @@Contractno = CONVERT(BIGINT,ContractNo)
          FROM   IsettleMent
          WHERE  IsettleMent.Party_Code = @Toparty
                 AND sauda_Date LIKE @TDate + '%'
                 AND Sett_Type LIKE @sett_type
                 AND Sett_No = @@Sett_no
                               --       /*ADDED BY SHYAM*/
                               --       and contractno = @ContractNo
                               --       /*END - ADDED BY SHYAM*/
          IF ((@@ContractNo IS NULL )
              AND (@@ContStyle = 'N'))
            BEGIN
            --                         Print 'in contstyle = N and contractno is null'
              IF @@style = 0
                BEGIN
                  SELECT @@ContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
                  FROM   IsettleMent
                  WHERE  sauda_Date LIKE @TDate + '%'
                         AND Sett_Type LIKE @Sett_type
                         AND Sett_No = @@Sett_no
                                       --             /*ADDED BY SHYAM*/
                                       --             and contractno = @ContractNo
                                       --             /*END - ADDED BY SHYAM*/
                  SELECT @@TempContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
                  FROM   IsettleMent
                  WHERE  sauda_Date LIKE @TDate + '%'
                         AND Sett_Type LIKE @sett_type
                         AND Sett_No = @@Sett_no
                                       --             /*ADDED BY SHYAM*/
                                       --             and contractno = @ContractNo
                                       --             /*END - ADDED BY SHYAM*/
                  IF @@TempContractno > @@Contractno
                    BEGIN
                      SET @@Contractno = @@TempContractno
                    END
                END
              ELSE
                IF @@Style = 1
                  BEGIN
                    SELECT @@ContractNo = CONVERT(BIGINT,ContractNo) + 1
                    FROM   Contgen
                    WHERE  @tdate + ' 00:00:01' >= Start_Date
                           AND @tdate + ' 00:00:01' <= End_Date
                                                       --    /*ADDED BY SHYAM*/
                                                       --    and contractno = @ContractNo
                                                       --    /*END - ADDED BY SHYAM*/
                  END
              IF @@ContractNo > 0
                BEGIN
                --                              Print 'Going to update contgen in inscont = N and contractno = null'
                  UPDATE Contgen
                  SET    ContractNo = @@ContractNo
                  WHERE  @tdate + ' 00:00:01' >= Start_Date
                         AND @tdate + ' 00:00:01' <= End_Date
                                                     --            /*ADDED BY SHYAM*/
                                                     --            and contractno = @ContractNo
                                                     --            /*END - ADDED BY SHYAM*/
                END
            END
        END
      IF (@@Contstyle = 'S')
         AND (@Flag < 3)
         AND (@@Sameparty = 'N')
        BEGIN
          SELECT @@ContractNo = CONVERT(BIGINT,ContractNo)
          FROM   IsettleMent
          WHERE  IsettleMent.Party_Code = @Toparty
                 AND sauda_Date LIKE @TDate + '%'
                 AND Sett_Type LIKE @sett_type
                 AND Sett_No = @@Sett_no
                 AND Scrip_cd = @scripcd
                                --       /*ADDED BY SHYAM*/
                                --       and contractno = @ContractNo
                                --       /*END - ADDED BY SHYAM*/
          IF (@@ContractNo IS NULL )
             AND (@@Contstyle = 'S')
            BEGIN
              IF @@style = 0
                BEGIN
                  SELECT @@ContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
                  FROM   IsettleMent
                  WHERE  sauda_Date LIKE @TDate + '%'
                         AND Sett_Type LIKE @sett_type
                         AND Sett_No = @@Sett_no
                                       --              /*ADDED BY SHYAM*/
                                       --              and contractno = @ContractNo
                                       --              /*END - ADDED BY SHYAM*/
                  SELECT @@TempContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
                  FROM   IsettleMent
                  WHERE  sauda_Date LIKE @TDate + '%'
                         AND Sett_Type LIKE @sett_type
                         AND Sett_No = @@Sett_no
                                       --              /*ADDED BY SHYAM*/
                                       --              and contractno = @ContractNo
                                       --              /*END - ADDED BY SHYAM*/
                  IF @@TempContractno > @@Contractno
                    BEGIN
                      SET @@Contractno = @@TempContractno
                    END
                END
              ELSE
                IF @@Style = 1
                  BEGIN
                    SELECT @@ContractNo = CONVERT(BIGINT,ContractNo) + 1
                    FROM   Contgen
                    WHERE  @tdate + ' 00:00:01' >= Start_Date
                           AND @tdate + ' 00:00:01' <= End_Date
                                                       --     /*ADDED BY SHYAM*/
                                                       --     and contractno = @ContractNo
                                                       --     /*END - ADDED BY SHYAM*/
                  END
              IF @@ContractNo > 0
                BEGIN
                  UPDATE Contgen
                  SET    ContractNo = @@ContractNo
                  WHERE  @tdate + ' 00:00:01' >= Start_Date
                         AND @tdate + ' 00:00:01' <= End_Date
                                                     --            /*ADDED BY SHYAM*/
                                                     --            and contractno = @ContractNo
                                                     --            /*END - ADDED BY SHYAM*/
                END
            END
        END
      IF ((@@SameParty = 'Y')
          AND (@Flag < 3))
        BEGIN
          IF @@Style = 0
            BEGIN
              SELECT @@ContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
              FROM   IsettleMent
              WHERE  sauda_Date LIKE @TDate + '%'
                     AND Sett_Type LIKE @sett_type
                     AND Sett_No = @@Sett_no
                                   --      /*ADDED BY SHYAM*/
                                   --      and contractno = @ContractNo
                                   --      /*END - ADDED BY SHYAM*/
              SELECT @@TempContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
              FROM   IsettleMent
              WHERE  sauda_Date LIKE @TDate + '%'
                     AND Sett_Type LIKE @sett_type
                     AND Sett_No = @@Sett_no
                                   --      /*ADDED BY SHYAM*/
                                   --      and contractno = @ContractNo
                                   --      /*END - ADDED BY SHYAM*/
              IF @@TempContractno > @@Contractno
                BEGIN
                  SET @@Contractno = @@TempContractno
                END
            END
          ELSE
            IF @@Style = 1
              BEGIN
                SELECT @@ContractNo = CONVERT(BIGINT,ContractNo) + 1
                FROM   Contgen
                WHERE  @tdate + ' 00:00:01' >= Start_Date
                       AND @tdate + ' 00:00:01' <= End_Date
                                                   --  /*ADDED BY SHYAM*/
                                                   --  and contractno = @ContractNo
                                                   --  /*END - ADDED BY SHYAM*/
              END
          IF @@ContractNo > 0
            BEGIN
              UPDATE Contgen
              SET    ContractNo = @@ContractNo
              WHERE  @tdate + ' 00:00:01' >= Start_Date
                     AND @tdate + ' 00:00:01' <= End_Date
                                                 --            /*ADDED BY SHYAM*/
                                                 --            and contractno = @ContractNo
                                                 --            /*END - ADDED BY SHYAM*/
            END
        END
        /*  I have added  the following for making sure that I am doing the consolidation transfer  */
      IF @@ERROR < > 0
        INSERT INTO ErrorLog
        VALUES     (Getdate(),
                    'In AfterContcursorins   Error Occured in section Institutional Trade Transfer  ',
                    @OrderNo + '     ' + @Tradeno + '   ' + @Partycd + '      ' + @Scripcd + '   ' + @Tdate + '   ' + CONVERT(VARCHAR,@Mkrate) + '    ' + @Sellbuy + '   ' + @Sett_type + '   ' + @@Sett_no,
                    ' ' + CONVERT(VARCHAR,@Flag) + '     ' + @Memcode + '   ' + @ToParty + '    ' + CONVERT(VARCHAR,@Tqty),
                    '  ')
      IF ((@@SameParty = 'N')
          AND (@Flag = 12)
          AND (@Tradeno = '%'))
        BEGIN
          IF @@Style = 0
            BEGIN
              SELECT @@ContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
              FROM   IsettleMent
              WHERE  sauda_Date LIKE @TDate + '%'
                     AND Sett_Type LIKE @sett_type
                     AND Sett_No = @@Sett_no
                                   --      /*ADDED BY SHYAM*/
                                   --      and contractno = @ContractNo
                                   --      /*END - ADDED BY SHYAM*/
              SELECT @@TempContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
              FROM   IsettleMent
              WHERE  sauda_Date LIKE @TDate + '%'
                     AND Sett_Type LIKE @sett_type
                     AND Sett_No = @@Sett_no
                                   --      /*ADDED BY SHYAM*/
                                   --      and contractno = @ContractNo
                                   --      /*END - ADDED BY SHYAM*/
              IF @@TempContractno > @@Contractno
                BEGIN
                  SET @@Contractno = @@TempContractno
                END
            END
          ELSE
            IF @@Style = 1
              BEGIN
                SELECT @@ContractNo = CONVERT(BIGINT,ContractNo) + 1
                FROM   Contgen
                WHERE  @tdate + ' 00:00:01' >= Start_Date
                       AND @tdate + ' 00:00:01' <= End_Date
                                                   --  /*ADDED BY SHYAM*/
                                                   --  and contractno = @ContractNo
                                                   --  /*END - ADDED BY SHYAM*/
              END
          IF @@ContractNo > 0
            BEGIN
              UPDATE Contgen
              SET    ContractNo = @@ContractNo
              WHERE  @tdate + ' 00:00:01' >= Start_Date
                     AND @tdate + ' 00:00:01' <= End_Date
                                                 --      /*ADDED BY SHYAM*/
                                                 --      and contractno = @ContractNo
                                                 --      /*END - ADDED BY SHYAM*/
            END
        END
      IF ((@@SameParty = 'Y')
          AND (@Flag = 12))
        BEGIN
          IF @@style = 0
            BEGIN
              SELECT @@ContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
              FROM   IsettleMent
              WHERE  sauda_Date LIKE @TDate + '%'
                     AND Sett_Type LIKE @sett_type
                     AND Sett_No = @@Sett_no
                                   --       /*ADDED BY SHYAM*/
                                   --       and contractno = @ContractNo
                                   --       /*END - ADDED BY SHYAM*/
              SELECT @@TempContractNo = Isnull(MAX(CONVERT(BIGINT,ContractNo)) + 1,'0000001')
              FROM   IsettleMent
              WHERE  sauda_Date LIKE @TDate + '%'
                     AND Sett_Type LIKE @sett_type
                     AND Sett_No = @@Sett_no
                                   --        /*ADDED BY SHYAM*/
                                   --        and contractno = @ContractNo
                                   --        /*END - ADDED BY SHYAM*/
              IF @@TempContractno > @@Contractno
                BEGIN
                  SET @@Contractno = @@TempContractno
                END
            END
          ELSE
            IF @@Style = 1
              BEGIN
                SELECT @@ContractNo = CONVERT(BIGINT,ContractNo) + 1
                FROM   Contgen
                WHERE  @tdate + ' 00:00:01' >= Start_Date
                       AND @tdate + ' 00:00:01' <= End_Date
                                                   --        /*ADDED BY SHYAM*/
                                                   --        and contractno = @ContractNo
                                                   --        /*END - ADDED BY SHYAM*/
              END
          IF @@ContractNo > 0
            BEGIN
              UPDATE Contgen
              SET    ContractNo = @@ContractNo
              WHERE  @tdate + ' 00:00:01' >= Start_Date
                     AND @tdate + ' 00:00:01' <= End_Date
                                                 --        /*ADDED BY SHYAM*/
                                                 --        and contractno = @ContractNo
                                                 --        /*END - ADDED BY SHYAM*/
            END
        END
        --If @@ContractNo > 0
        --Begin
        --          Update ContGen set ContractNo = @@ContractNo where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date
        --   /*ADDED BY SHYAM*/
        --   and contractno = @ContractNo
        --   /*END - ADDED BY SHYAM*/
        --End
        /*  Print 'Contractno is ' + convert(varchar,@@Contractno)      */
      SELECT @@Contractno = Stuff('0000000',8 - Len(@@Contractno),Len(@@Contractno),
                                  @@Contractno)
    END
    /*  Print @@Contractno */
  IF @@ERROR < > 0
    INSERT INTO ErrorLog
    VALUES     (Getdate(),
                '  In AfterContcursorins   Error Occured in section Consolidation ',
                @OrderNo + '     ' + @Tradeno + '   ' + @Partycd + '      ' + @Scripcd + '   ' + @Tdate + '   ' + CONVERT(VARCHAR,@Mkrate) + '    ' + @Sellbuy + '


 ' + @Sett_type + '   ' + @@Sett_no,
                ' ' + CONVERT(VARCHAR,@Flag) + '     ' + @Memcode + '   ' + @ToParty + '    ' + CONVERT(VARCHAR,@Tqty),
                '  ')
  IF @FLAG = 1
    BEGIN
    /* Print 'Flag 1'  */
      SET @@Cont = CURSOR FOR SELECT   Trade_No,
                                       Tradeqty,
                                       MarketRate,
                                       NetRate
                              FROM     IsettleMent
                              WHERE  /* billno = 0  */
                               Sett_No = @@Sett_no
                                       AND Party_Code LIKE @partycd
                                       AND Scrip_cd LIKE @scripcd
                                       AND sauda_Date LIKE @TDate + '%'
                                       AND MarketRate = @mkrate
                                       AND Sell_Buy LIKE @sellbuy
                                       AND Tradeqty > 0
                                       AND Sett_Type LIKE @sett_type
                                       AND Trade_No LIKE @tradeno
                                       AND Order_No LIKE @orderno
                                       AND PartiPantCode = @Memcode
                                       AND User_Id LIKE @TerminalId
                                       AND Trade_No NOT LIKE 'C%'
                                                             /*ADDED BY SHYAM*/
                                       AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                                        /*END - ADDED BY SHYAM*/
                              ORDER BY Order_No,
                                       Tradeqty DESC
    END
  ELSE
    IF ((@Flag = 2)
         OR (@Flag = 12))
      BEGIN
      -- Print 'Flag = 12 '
      -- Select @@Sett_no,@Partycd,@Scripcd,@Tdate,@Sellbuy,@sett_type,@tradeno,@orderno,@tmark,@memcode,@terminalid
        SET @@Cont = CURSOR FOR SELECT   Trade_No,
                                         Tradeqty,
                                         MarketRate,
                                         NetRate
                                FROM     IsettleMent
                                WHERE  /* billno = 0   */
                                 Sett_No = @@Sett_no
                                         AND Party_Code LIKE @partycd
                                         AND Scrip_cd LIKE @scripcd
                                         AND sauda_Date LIKE @TDate + '%'
                                         AND Sell_Buy = @sellbuy
                                         AND Sett_Type LIKE @sett_type
                                         AND Trade_No LIKE @tradeno
                                         AND Order_No LIKE @orderno
                                         AND Tradeqty > 0
                                         AND PartiPantCode = @Memcode
                                         AND User_Id LIKE @TerminalId
                                         AND Trade_No NOT LIKE 'C%'
                                                               /*ADDED BY SHYAM*/
                                         AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                                          /*END - ADDED BY SHYAM*/
                                ORDER BY Order_No,
                                         Tradeqty DESC
      END
    ELSE
      IF @Flag = 3
        BEGIN
        /* Print 'Flag = 3 '
   Select @Partycd,@Scripcd,@Tdate,@Sellbuy,@sett_type,@tradeno,@orderno,@tmark,@memcode,@terminalid */
          SET @@Cont = CURSOR FOR SELECT   Trade_No,
                                           Tradeqty,
                                           MarketRate,
                                           NetRate
                                  FROM     IsettleMent
                                  WHERE    Sett_No = @@Sett_no
                                           AND Party_Code LIKE @partycd
                                           AND Scrip_cd LIKE @scripcd
                                           AND sauda_Date LIKE @TDate + '%'
                                           AND Sell_Buy = @sellbuy
                                           AND Sett_Type LIKE @sett_type
                                           AND Trade_No LIKE @tradeno
                                           AND Order_No LIKE @orderno
                                           AND Tradeqty > 0
                                           AND PartiPantCode = @Memcode
                                           AND User_Id LIKE @TerminalId
                                                            /*ADDED BY SHYAM*/
                                           AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                                            /*END - ADDED BY SHYAM*/
                                  ORDER BY Order_No,
                                           Tradeqty DESC
        END
  IF @Flag = 4
    BEGIN
    --Print 'Flag   =  4'
    /*   Select @Partycd,@Scripcd,@Tdate,@Sellbuy,@sett_type,@tradeno,@orderno,@tmark,@memcode,@terminalid */
      SET @@Cont = CURSOR FOR SELECT   Trade_No,
                                       Tradeqty,
                                       MarketRate,
                                       NetRate
                              FROM     IsettleMent
                              WHERE    Sett_No = @@Sett_no
                                       AND Party_Code LIKE @partycd
                                       AND Scrip_cd LIKE @scripcd
                                       AND sauda_Date LIKE @TDate + '%'
                                       AND Sell_Buy = @sellbuy
                                       AND Sett_Type LIKE @sett_type
                                       AND Trade_No LIKE @tradeno
                                       AND Order_No LIKE @orderno
                                       AND Tradeqty > 0
                                       AND PartiPantCode = @Memcode
                                       AND User_Id LIKE @TerminalId
                                                        /*ADDED BY SHYAM*/
                                       AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                                        /*END - ADDED BY SHYAM*/
                              ORDER BY Order_No,
                                       Tradeqty DESC
    END
  OPEN @@Cont
  FETCH NEXT FROM @@Cont
  INTO @@trade_no,
       @@tradeqty,
       @@marketrate,
       @@netrate
  SELECT @@trade_no,
         @@tradeqty,
         @@marketrate,
         @@netrate,
         'ANI'
         /* Party TO Party for Institutional Clients  */
  WHILE ((@@FETCH_STATUS = 0)
         AND (@Tqty > 0)
         AND ((@Flag < 3)
               OR (@Flag = 12)))
    BEGIN
      IF @@TradeQty > @TQty
        BEGIN
          SELECT @@TTradeNo = 'R' + @@trade_no
          SELECT @@TFlag = 1
          SELECT @@XTradeNo = '0'
          WHILE @@TFlag = 1
            BEGIN
              SET @@TNo = CURSOR FOR SELECT Trade_No
                                     FROM   IsettleMent
                                     WHERE  Trade_No LIKE @@ttradeno
                                            AND sauda_Date LIKE @TDate + '%'
                                            AND Scrip_cd = @scripcd
                                            AND Sell_Buy = @sellbuy  /* and party_code = @partycd */ 
                                            AND Sett_Type LIKE @sett_type  /* and participantcode = @Memcode */
                                            AND Sett_No = @@Sett_no /* and Tradeqty =  @@tradeqty */
                                                          /*ADDED BY SHYAM*/
                                            AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                                             /*END - ADDED BY SHYAM*/
              OPEN @@TNo
              FETCH NEXT FROM @@Tno
              INTO @@XTradeNo
              IF @@FETCH_STATUS = 0
                 AND @@XTradeNo <> '0'
                BEGIN
                  SELECT @@TTRadeno = 'R' + @@XTradeNo
                  SELECT @@TFlag = 1
                END
              ELSE
                SELECT @@TFlag = 0
            END
        END
      ELSE
        SELECT @@TTradeNo = @@trade_no
      IF @@TradeQty = @TQty
        BEGIN
        --print '1-@@contractno:' + convert(varchar, @@contractno)
          UPDATE IsettleMent
          SET    Party_Code = @ToParty,
                 Trade_No = @@TTradeNo,
                 --	Contractno = @@contractno
                 ContractNo = Stuff('0000000',8 - Len(@@Contractno),Len(@@Contractno),
                                    @@Contractno)
          WHERE  Sett_Type = @sett_type
                 AND Trade_No = @@trade_no
                 AND Scrip_cd = @scripcd
                 AND sauda_Date LIKE @TDate + '%'
                 AND Sell_Buy = @sellbuy
                 AND Party_Code = @partycd
                 AND NetRate = @@NetRate
                 AND tMark LIKE @tmark
                 AND PartiPantCode = @Memcode
                 AND Sett_No = @@Sett_no
                 AND Tradeqty = @@tradeqty
                                /*ADDED BY SHYAM*/
                 AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                  /*END - ADDED BY SHYAM*/
          SELECT @TQty = 0
        END
      ELSE
        IF @@TradeQty > @TQty
          BEGIN
            INSERT INTO IsettleMent
            SELECT
            --@@contractno,
             ContractNo = Stuff('0000000',8 - Len(@@Contractno),Len(@@Contractno),
                                @@Contractno),
             0,
             @@ttradeno,
             @toparty,
             Scrip_cd,
             User_Id,
             @tqty,
             AuctionPart,
             MarketType,
             Series,
             Order_No,
             @@MarketRate,
             sauda_Date,
             Table_No,
             Line_No,
             val_Perc,
             Normal,
             Day_puc,
             Day_Sales,
             Sett_purch,
             Sett_Sales,
             Sell_Buy,
             SettFlag,
             brOkApplied,
             NetRate,
             Amount = (@Tqty *@@NetRate),
             Ins_chrg,
             Turn_Tax,
             Other_chrg,
             sebi_Tax,
             Broker_chrg,
             Service_Tax,
             Trade_Amount = (@tqty * @@MarketRate),
             BillFlag,
             Sett_No,
             nbrOkapp,
             nserTax,
             n_NetRate,
             Sett_Type,
             PartiPantCode,
             Status,
             Pro_cli,
             cPid,
             Instrument,
             BookType,
             Branch_Id,
             tMark,
             Scheme,
             Dummy1,
             Dummy2
            FROM   IsettleMent
            WHERE  Sett_Type = @sett_type
                   AND Trade_No = @@trade_no
                   AND Scrip_cd = @scripcd
                   AND sauda_Date LIKE @TDate + '%'
                   AND Sell_Buy = @sellbuy
                   AND Party_Code = @partycd
                   AND NetRate = @@NetRate
                   AND PartiPantCode = @Memcode
                   AND Sett_No = @@Sett_no
                   AND Tradeqty = @@tradeqty
                                  /*ADDED BY SHYAM*/
                   AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                    /*END - ADDED BY SHYAM*/
                                                    --print '2-@@contractno:' + convert(varchar, @@contractno)
            UPDATE IsettleMent
            SET    Tradeqty = @@TradeQty - @TQty,
                   Amount = (@@TradeQty - @TQty) * MarketRate
            WHERE  Sett_Type = @sett_type
                   AND Trade_No = @@trade_no
                   AND Scrip_cd = @scripcd
                   AND sauda_Date LIKE @TDate + '%'
                   AND Sell_Buy = @sellbuy
                   AND Party_Code = @partycd
                   AND NetRate = @@NetRate
                   AND PartiPantCode = @Memcode
                   AND Sett_No = @@Sett_no
                   AND Tradeqty = @@tradeqty
                                  /*ADDED BY SHYAM*/
                   AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                    /*END - ADDED BY SHYAM*/
            SELECT @TQty = 0
          END
        ELSE
          IF @@TradeQty < @TQty
            BEGIN
            --print '3-@@contractno:' + convert(varchar, @@contractno)
              UPDATE IsettleMent
              SET    Party_Code = @ToParty,
                     Trade_No = @@TTradeNo,
                     --	Contractno = @@contractno
                     ContractNo = Stuff('0000000',8 - Len(@@Contractno),Len(@@Contractno),
                                        @@Contractno)
              WHERE  Sett_Type = @sett_type
                     AND Trade_No = @@trade_no
                     AND Scrip_cd = @scripcd
                     AND sauda_Date LIKE @TDate + '%'
                     AND Sell_Buy = @sellbuy
                     AND Party_Code = @partycd
                     AND NetRate = @@NetRate
                     AND tMark LIKE @tmark
                     AND PartiPantCode = @Memcode
                     AND Sett_No = @@Sett_no
                     AND Tradeqty = @@tradeqty
                                    /*ADDED BY SHYAM*/
                     AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                      /*END - ADDED BY SHYAM*/
              SELECT @TQty = @TQty - @@TradeQty
            END
      FETCH NEXT FROM @@Cont
      INTO @@trade_no,
           @@tradeqty,
           @@marketrate,
           @@netrate
    END
  IF (((@Flag = 12)
        OR (@Flag = 2)
        OR (@Flag = 1))
      AND (@MkRate > 0))
    BEGIN
    --print '4-@@contractno:' + convert(varchar, @@contractno)
      UPDATE IsettleMent
      SET    MarketRate = @Mkrate,
             Trade_Amount = (Tradeqty * @Mkrate),
             Dummy2 = 1
      WHERE  Party_Code = @Toparty
             AND Sett_Type = @Sett_type
             AND Scrip_cd LIKE @scripcd
             AND sauda_Date LIKE @TDate + '%'
             AND Sell_Buy = @sellbuy
             AND Sett_No = @@Sett_no
             AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@@Contractno)
                                              --print 'Update ISettlement set MArketrate = @Mkrate,Trade_amount = (Tradeqty * @Mkrate) ,Dummy2 = 1  where'
                                              --print 'Party_code = ''' + @Toparty + ''''
                                              --print 'And'
                                              --print 'Sett_type = ''' + @Sett_type + ''''
                                              --print 'and scrip_cd like  ''' + @scripcd + ''''
                                              --print 'and sauda_date like ''' + @TDate + '%'
                                              --print 'and sell_buy = ''' + @sellbuy + ''''
                                              --print 'And Sett_no = ''' + @@Sett_no + ''''
                                              --print 'And convert(bigint, COntractno) = convert(bigint, ''' + @@Contractno + ''')'
                                              --    /*ADDED BY SHYAM*/
                                              --    and contractno = @ContractNo
                                              --    /*END - ADDED BY SHYAM*/
    END
    /*    Following Routine does the partial rejection of Orders  Flag =  3       */
  WHILE @@FETCH_STATUS = 0
        AND @TQty > 0
        AND @Flag = 3
    BEGIN
      SELECT @@TTradeNo = 'R' + @@trade_no
      SELECT @@TFlag = 1
      SELECT @@XTradeNo = '0'
      WHILE @@TFlag = 1
        BEGIN
          SET @@TNo = CURSOR FOR SELECT Trade_No
                                 FROM   IsettleMent
                                 WHERE  Trade_No LIKE @@ttradeno
                                        AND sauda_Date LIKE @TDate + '%'
                                        AND Scrip_cd = @scripcd
                                        AND Sell_Buy = @sellbuy
                                        AND Party_Code = @partycd
                                        AND Sett_Type LIKE @sett_type
                                        AND PartiPantCode = @Memcode
                                                            /*ADDED BY SHYAM*/
                                        AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                                         /*END - ADDED BY SHYAM*/
          OPEN @@TNo
          FETCH NEXT FROM @@Tno
          INTO @@XTradeNo
          IF @@FETCH_STATUS = 0
             AND @@XTradeNo <> '0'
            BEGIN
              SELECT @@TTRadeno = 'R' + @@XTradeNo
              SELECT @@TFlag = 1
            END
          ELSE
            SELECT @@TFlag = 0
        END
      IF @@TradeQty = @TQty
        BEGIN
        /*                       Print ' In Tradeqty = Tqty'  */
          INSERT INTO IsettleMent
          SELECT @@contractno,
                 0,
                 @@ttradeno,
                 @toparty,
                 Scrip_cd,
                 User_Id,
                 @@TradeQty,
                 AuctionPart,
                 MarketType,
                 Series,
                 Order_No,
                 MarketRate,
                 sauda_Date,
                 Table_No,
                 Line_No,
                 val_Perc,
                 Normal,
                 Day_puc,
                 Day_Sales,
                 Sett_purch,
                 Sett_Sales,
                 Sell_Buy,
                 SettFlag,
                 brOkApplied,
                 NetRate,
                 Amount = (@Tqty *@@NetRate),
                 Ins_chrg,
                 Turn_Tax,
                 Other_chrg,
                 sebi_Tax,
                 Broker_chrg,
                 Service_Tax,
                 Trade_Amount = (@tqty * @@MarketRate),
                 BillFlag,
                 Sett_No,
                 nbrOkapp,
                 nserTax,
                 n_NetRate,
                 Sett_Type,
                 @@Membercode,
                 Status,
                 Pro_cli,
                 cPid,
                 Instrument,
                 BookType,
                 Branch_Id,
                 tMark,
                 Scheme,
                 Dummy1,
                 Dummy2
          FROM   IsettleMent
          WHERE  Sett_Type = @sett_type
                 AND Trade_No = @@trade_no
                 AND Scrip_cd = @scripcd
                 AND sauda_Date LIKE @TDate + '%'
                 AND Sell_Buy = @sellbuy
                 AND Party_Code = @partycd
                 AND NetRate = @@NetRate
                 AND PartiPantCode = @Memcode
                 AND Sett_No = @@Sett_no
                               /*ADDED BY SHYAM*/
                 AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                  /*END - ADDED BY SHYAM*/
                                                  --print '5-@@contractno:' + convert(varchar, @@contractno)
          UPDATE IsettleMent
          SET    Tradeqty = 0,
                 Normal = 0,
                 Day_puc = 0,
                 Day_Sales = 0,
                 Sett_purch = 0,
                 Sett_Sales = 0,
                 MarketRate = 0,
                 brOkApplied = 0,
                 NetRate = 0,
                 Amount = 0,
                 Ins_chrg = 0,
                 Turn_Tax = 0,
                 Other_chrg = 0,
                 sebi_Tax = 0,
                 Broker_chrg = 0,
                 Service_Tax = 0,
                 Trade_Amount = 0,
                 nbrOkapp = 0,
                 nserTax = 0,
                 n_NetRate = 0
          WHERE  Sett_Type = @sett_type
                 AND Trade_No = @@trade_no
                 AND Scrip_cd = @scripcd
                 AND sauda_Date LIKE @TDate + '%'
                 AND Sell_Buy = @sellbuy
                 AND Party_Code = @partycd
                 AND NetRate = @@NetRate
                 AND PartiPantCode = @Memcode
                 AND Sett_No = @@Sett_no
                               /*ADDED BY SHYAM*/
                 AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                  /*END - ADDED BY SHYAM*/
          SELECT @TQty = 0
        END
      ELSE
        IF @@TradeQty > @TQty
          BEGIN
          /*      Print ' In Tradeqty > Tqty'  */
            INSERT INTO IsettleMent
            SELECT @@contractno,
                   0,
                   @@ttradeno,
                   @toparty,
                   Scrip_cd,
                   User_Id,
                   @tqty,
                   AuctionPart,
                   MarketType,
                   Series,
                   Order_No,
                   MarketRate,
                   sauda_Date,
                   Table_No,
                   Line_No,
                   val_Perc,
                   Normal,
                   Day_puc,
                   Day_Sales,
                   Sett_purch,
                   Sett_Sales,
                   Sell_Buy,
                   SettFlag,
                   brOkApplied,
                   NetRate,
                   Amount = (@Tqty *@@NetRate),
                   Ins_chrg,
                   Turn_Tax,
                   Other_chrg,
                   sebi_Tax,
                   Broker_chrg,
                   Service_Tax,
                   Trade_Amount = (@tqty * @@MarketRate),
                   BillFlag,
                   Sett_No,
                   nbrOkapp,
                   nserTax,
                   n_NetRate,
                   Sett_Type,
                   @@Membercode,
                   Status,
                   Pro_cli,
                   cPid,
                   Instrument,
                   BookType,
                   Branch_Id,
                   tMark,
                   Scheme,
                   Dummy1,
                   Dummy2
            FROM   IsettleMent
            WHERE  Sett_Type = @sett_type
                   AND Trade_No = @@trade_no
                   AND Scrip_cd = @scripcd
                   AND sauda_Date LIKE @TDate + '%'
                   AND Sell_Buy = @sellbuy
                   AND Party_Code = @partycd
                   AND NetRate = @@NetRate
                   AND PartiPantCode = @Memcode
                   AND Sett_No = @@Sett_no
                                 /*ADDED BY SHYAM*/
                   AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                    /*END - ADDED BY SHYAM*/
                                                    --print '6-@@contractno:' + convert(varchar, @@contractno)
            UPDATE IsettleMent
            SET    Tradeqty = @@TradeQty - @TQty,
                   Amount = (@@TradeQty - @TQty) * MarketRate
            WHERE  Sett_Type = @sett_type
                   AND Trade_No = @@trade_no
                   AND Scrip_cd = @scripcd
                   AND sauda_Date LIKE @TDate + '%'
                   AND Sell_Buy = @sellbuy
                   AND Party_Code = @partycd
                   AND NetRate = @@NetRate
                   AND PartiPantCode = @Memcode
                   AND Sett_No = @@Sett_no
                                 /*ADDED BY SHYAM*/
                   AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                    /*END - ADDED BY SHYAM*/
            SELECT @TQty = 0
          END
        ELSE
          IF @@TradeQty < @TQty
            BEGIN
            /* Print ' In Tradeqty < Tqty'  */
              INSERT INTO IsettleMent
              SELECT @@contractno,
                     0,
                     @@ttradeno,
                     @toparty,
                     Scrip_cd,
                     User_Id,
                     @@TradeQty,
                     AuctionPart,
                     MarketType,
                     Series,
                     Order_No,
                     MarketRate,
                     sauda_Date,
                     Table_No,
                     Line_No,
                     val_Perc,
                     Normal,
                     Day_puc,
                     Day_Sales,
                     Sett_purch,
                     Sett_Sales,
                     Sell_Buy,
                     SettFlag,
                     brOkApplied,
                     NetRate,
                     Amount = (@@Tradeqty *@@NetRate),
                     Ins_chrg,
                     Turn_Tax,
                     Other_chrg,
                     sebi_Tax,
                     Broker_chrg,
                     Service_Tax,
                     Trade_Amount = (@tqty * @@MarketRate),
                     BillFlag,
                     Sett_No,
                     nbrOkapp,
                     nserTax,
                     n_NetRate,
                     Sett_Type,
                     @@MemberCode,
                     Status,
                     Pro_cli,
                     cPid,
                     Instrument,
                     BookType,
                     Branch_Id,
                     tMark,
                     Scheme,
                     Dummy1,
                     Dummy2
              FROM   IsettleMent
              WHERE  Sett_Type = @sett_type
                     AND Trade_No = @@trade_no
                     AND Scrip_cd = @scripcd
                     AND sauda_Date LIKE @TDate + '%'
                     AND Sell_Buy = @sellbuy
                     AND Party_Code = @partycd
                     AND NetRate = @@NetRate
                     AND PartiPantCode = @Memcode
                     AND Sett_No = @@Sett_no
                                   /*ADDED BY SHYAM*/
                     AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                      /*END - ADDED BY SHYAM*/
                                                      --print '7-@@contractno:' + convert(varchar, @@contractno)
              UPDATE IsettleMent
              SET    Tradeqty = 0,
                     Normal = 0,
                     Day_puc = 0,
                     Day_Sales = 0,
                     Sett_purch = 0,
                     Sett_Sales = 0,
                     MarketRate = 0,
                     brOkApplied = 0,
                     NetRate = 0,
                     Amount = 0,
                     Ins_chrg = 0,
                     Turn_Tax = 0,
                     Other_chrg = 0,
                     sebi_Tax = 0,
                     Broker_chrg = 0,
                     Service_Tax = 0,
                     Trade_Amount = 0,
                     nbrOkapp = 0,
                     nserTax = 0,
                     n_NetRate = 0
              WHERE  Sett_Type = @sett_type
                     AND Trade_No = @@trade_no
                     AND Scrip_cd = @scripcd
                     AND sauda_Date LIKE @TDate + '%'
                     AND Sell_Buy = @sellbuy
                     AND Party_Code = @partycd
                     AND NetRate = @@NetRate
                     AND PartiPantCode = @Memcode
                     AND Sett_No = @@Sett_no
                                   /*ADDED BY SHYAM*/
                     AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                      /*END - ADDED BY SHYAM*/
              SELECT @TQty = @TQty - @@TradeQty
            END
      FETCH NEXT FROM @@Cont
      INTO @@trade_no,
           @@tradeqty,
           @@marketrate,
           @@netrate
    END
    /*    We will do now ISettlement To ISettlement Transefer   */
  WHILE @@FETCH_STATUS = 0
        AND @TQty > 0
        AND @Flag = 4
    BEGIN
      SELECT @@TTradeNo = 'R' + @@trade_no
      SELECT @@TFlag = 1
      SELECT @@XTradeNo = '0'
      WHILE @@TFlag = 1
        BEGIN
          SET @@TNo = CURSOR FOR SELECT Trade_No
                                 FROM   IsettleMent
                                 WHERE  Trade_No LIKE @@ttradeno
                                        AND sauda_Date LIKE @TDate + '%'
                                        AND Scrip_cd = @scripcd
                                        AND Sell_Buy = @sellbuy
                                        AND Party_Code = @partycd
                                        AND Sett_Type LIKE @sett_type
                                        AND PartiPantCode = @Memcode
                                                            /*ADDED BY SHYAM*/
                                        AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                                         /*END - ADDED BY SHYAM*/
          OPEN @@TNo
          FETCH NEXT FROM @@Tno
          INTO @@XTradeNo
          IF @@FETCH_STATUS = 0
             AND @@XTradeNo <> '0'
            BEGIN
              SELECT @@TTRadeno = 'R' + @@XTradeNo
              SELECT @@TFlag = 1
            END
          ELSE
            SELECT @@TFlag = 0
        END
      IF @@TradeQty = @TQty
        BEGIN
        /*                                      Print ' In Tradeqty = Tqty'  */
          INSERT INTO IsettleMent
          SELECT @@contractno,
                 0,
                 @@ttradeno,
                 @toparty,
                 Scrip_cd,
                 User_Id,
                 @@TradeQty,
                 AuctionPart,
                 MarketType,
                 Series,
                 Order_No,
                 MarketRate,
                 sauda_Date,
                 Table_No,
                 Line_No,
                 val_Perc,
                 Normal,
                 Day_puc,
                 Day_Sales,
                 Sett_purch,
                 Sett_Sales,
                 Sell_Buy,
                 SettFlag,
                 brOkApplied,
                 NetRate,
                 Amount = (@Tqty *@@NetRate),
                 Ins_chrg,
                 Turn_Tax,
                 Other_chrg,
                 sebi_Tax,
                 Broker_chrg,
                 Service_Tax,
                 Trade_Amount = (@tqty * @@MarketRate),
                 BillFlag,
                 Sett_No,
                 nbrOkapp,
                 nserTax,
                 n_NetRate,
                 Sett_Type,
                 PartiPantCode,
                 Status,
                 Pro_cli,
                 cPid,
                 Instrument,
                 BookType,
                 Branch_Id,
                 tMark,
                 Scheme,
                 Dummy1,
                 Dummy2
          FROM   IsettleMent
          WHERE  Sett_Type = @sett_type
                 AND Trade_No = @@trade_no
                 AND Scrip_cd = @scripcd
                 AND sauda_Date LIKE @TDate + '%'
                 AND Sell_Buy = @sellbuy
                 AND Party_Code = @partycd
                 AND NetRate = @@NetRate
                 AND PartiPantCode = @Memcode
                 AND Sett_No = @@Sett_no
                               /*ADDED BY SHYAM*/
                 AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                  /*END - ADDED BY SHYAM*/
                                                  --print '8-@@contractno:' + convert(varchar, @@contractno)
          UPDATE IsettleMent
          SET    Tradeqty = 0,
                 Normal = 0,
                 Day_puc = 0,
                 Day_Sales = 0,
                 Sett_purch = 0,
                 Sett_Sales = 0,
                 MarketRate = 0,
                 brOkApplied = 0,
                 NetRate = 0,
                 Amount = 0,
                 Ins_chrg = 0,
                 Turn_Tax = 0,
                 Other_chrg = 0,
                 sebi_Tax = 0,
                 Broker_chrg = 0,
                 Service_Tax = 0,
                 Trade_Amount = 0,
                 nbrOkapp = 0,
                 nserTax = 0,
                 n_NetRate = 0
          WHERE  Sett_Type = @sett_type
                 AND Trade_No = @@trade_no
                 AND Scrip_cd = @scripcd
                 AND sauda_Date LIKE @TDate + '%'
                 AND Sell_Buy = @sellbuy
                 AND Party_Code = @partycd
                 AND NetRate = @@NetRate
                 AND PartiPantCode = @Memcode
                 AND Sett_No = @@Sett_no
                               /*ADDED BY SHYAM*/
                 AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                  /*END - ADDED BY SHYAM*/
          SELECT @TQty = 0
        END
      ELSE
        IF @@TradeQty > @TQty
          BEGIN
          /*      Print ' In Tradeqty > Tqty'  */
            INSERT INTO IsettleMent
            SELECT @@contractno,
                   0,
                   @@ttradeno,
                   @toparty,
                   Scrip_cd,
                   User_Id,
                   @tqty,
                   AuctionPart,
                   MarketType,
                   Series,
                   Order_No,
                   MarketRate,
                   sauda_Date,
                   Table_No,
                   Line_No,
                   val_Perc,
                   Normal,
                   Day_puc,
                   Day_Sales,
                   Sett_purch,
                   Sett_Sales,
                   Sell_Buy,
                   SettFlag,
                   brOkApplied,
                   NetRate,
                   Amount = (@Tqty *@@NetRate),
                   Ins_chrg,
                   Turn_Tax,
                   Other_chrg,
                   sebi_Tax,
                   Broker_chrg,
                   Service_Tax,
                   Trade_Amount = (@tqty * @@MarketRate),
                   BillFlag,
                   Sett_No,
                   nbrOkapp,
                   nserTax,
                   n_NetRate,
                   Sett_Type,
                   PartiPantCode,
                   Status,
                   Pro_cli,
                   cPid,
                   Instrument,
                   BookType,
                   Branch_Id,
                   tMark,
                   Scheme,
                   Dummy1,
                   Dummy2
            FROM   IsettleMent
            WHERE  Sett_Type = @sett_type
                   AND Trade_No = @@trade_no
                   AND Scrip_cd = @scripcd
                   AND sauda_Date LIKE @TDate + '%'
                   AND Sell_Buy = @sellbuy
                   AND Party_Code = @partycd
                   AND NetRate = @@NetRate
                   AND PartiPantCode = @Memcode
                   AND Sett_No = @@Sett_no
                                 /*ADDED BY SHYAM*/
                   AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                    /*END - ADDED BY SHYAM*/
                                                    --print '9-@@contractno:' + convert(varchar, @@contractno)
            UPDATE IsettleMent
            SET    Tradeqty = @@TradeQty - @TQty,
                   Amount = (@@TradeQty - @TQty) * MarketRate
            WHERE  Sett_Type = @sett_type
                   AND Trade_No = @@trade_no
                   AND Scrip_cd = @scripcd
                   AND sauda_Date LIKE @TDate + '%'
                   AND Sell_Buy = @sellbuy
                   AND Party_Code = @partycd
                   AND NetRate = @@NetRate
                   AND PartiPantCode = @Memcode
                   AND Sett_No = @@Sett_no
                                 /*ADDED BY SHYAM*/
                   AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                    /*END - ADDED BY SHYAM*/
            SELECT @TQty = 0
          END
        ELSE
          IF @@TradeQty < @TQty
            BEGIN
            /*      Print ' In Tradeqty < Tqty'  */
              INSERT INTO IsettleMent
              SELECT @@contractno,
                     0,
                     @@ttradeno,
                     @toparty,
                     Scrip_cd,
                     User_Id,
                     @@TradeQty,
                     AuctionPart,
                     MarketType,
                     Series,
                     Order_No,
                     MarketRate,
                     sauda_Date,
                     Table_No,
                     Line_No,
                     val_Perc,
                     Normal,
                     Day_puc,
                     Day_Sales,
                     Sett_purch,
                     Sett_Sales,
                     Sell_Buy,
                     SettFlag,
                     brOkApplied,
                     NetRate,
                     Amount = (@@Tradeqty *@@NetRate),
                     Ins_chrg,
                     Turn_Tax,
                     Other_chrg,
                     sebi_Tax,
                     Broker_chrg,
                     Service_Tax,
                     Trade_Amount = (@tqty * @@MarketRate),
                     BillFlag,
                     Sett_No,
                     nbrOkapp,
                     nserTax,
                     n_NetRate,
                     Sett_Type,
                     PartiPantCode,
                     Status,
                     Pro_cli,
                     cPid,
                     Instrument,
                     BookType,
                     Branch_Id,
                     tMark,
                     Scheme,
                     Dummy1,
                     Dummy2
              FROM   IsettleMent
              WHERE  Sett_Type = @sett_type
                     AND Trade_No = @@trade_no
                     AND Scrip_cd = @scripcd
                     AND sauda_Date LIKE @TDate + '%'
                     AND Sell_Buy = @sellbuy
                     AND Party_Code = @partycd
                     AND NetRate = @@NetRate
                     AND PartiPantCode = @Memcode
                     AND Sett_No = @@Sett_no
                                   /*ADDED BY SHYAM*/
                     AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                      /*END - ADDED BY SHYAM*/
                                                      --print '10-@@contractno:' + convert(varchar, @@contractno)
              UPDATE IsettleMent
              SET    Tradeqty = 0,
                     Normal = 0,
                     Day_puc = 0,
                     Day_Sales = 0,
                     Sett_purch = 0,
                     Sett_Sales = 0,
                     MarketRate = 0,
                     brOkApplied = 0,
                     NetRate = 0,
                     Amount = 0,
                     Ins_chrg = 0,
                     Turn_Tax = 0,
                     Other_chrg = 0,
                     sebi_Tax = 0,
                     Broker_chrg = 0,
                     Service_Tax = 0,
                     Trade_Amount = 0,
                     nbrOkapp = 0,
                     nserTax = 0,
                     n_NetRate = 0
              WHERE  Sett_Type = @sett_type
                     AND Trade_No = @@trade_no
                     AND Scrip_cd = @scripcd
                     AND sauda_Date LIKE @TDate + '%'
                     AND Sell_Buy = @sellbuy
                     AND Party_Code = @partycd
                     AND NetRate = @@NetRate
                     AND PartiPantCode = @Memcode
                     AND Sett_No = @@Sett_no
                                   /*ADDED BY SHYAM*/
                     AND CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@ContractNo)
                                                      /*END - ADDED BY SHYAM*/
              SELECT @TQty = @TQty - @@TradeQty
            END
      FETCH NEXT FROM @@Cont
      INTO @@trade_no,
           @@tradeqty,
           @@marketrate,
           @@netrate
    END
  IF @@ERROR < > 0
    INSERT INTO ErrorLog
    VALUES     (Getdate(),
                '  In AfterContcursorins   Error Occured in section Actual Transfer  ',
                @OrderNo + '     ' + @Tradeno + '   ' + @Partycd + '      ' + @Scripcd + '   ' + @Tdate + '   ' + CONVERT(VARCHAR,@Mkrate) + '    ' + @Sellbuy + '   ' + @Sett_type + '   ' + @@Sett_no,
                ' ' + CONVERT(VARCHAR,@Flag) + '     ' + @Memcode + '   ' + @ToParty + '    ' + CONVERT(VARCHAR,@Tqty),
                '  ')
  SELECT @orig_qty = Isnull(SUM(Tradeqty),0)
  FROM   IsettleMent
  WHERE  CONVERT(BIGINT,ContractNo) = CONVERT(BIGINT,@contractno)
  IF @@ERROR = 0
    BEGIN
    --            Insert into contlogin values( 'SA',  @Partycd,@ToParty,@Scripcd, 'EQ', @@MyQty,@SellBuy, @Tdate,@@ContractNo, Getdate(), 0,@@TTradeNo)
      IF @@Sameparty = 'N'
        BEGIN
          INSERT INTO Details
          VALUES     (LEFT(CONVERT(VARCHAR,@Tdate,109),11),
                      @@Sett_no,
                      @sett_type,
                      @ToParty,
                      'IS')
        END
      INSERT INTO Inst_Log
      VALUES     (Ltrim(Rtrim(@partycd)),	/*party_code*/
                  Ltrim(Rtrim(@ToParty)),	/*new_party_code*/
                  CONVERT(DATETIME,Ltrim(Rtrim(@tdate))),	 /*sauda_date*/
                  Ltrim(Rtrim('')),	 /*sett_no*/
                  Ltrim(Rtrim(@sett_type)),	 /*sett_type*/
                  Ltrim(Rtrim(@scripcd)),	/*scrip_cd*/
                  Ltrim(Rtrim('NSE')),	/*series*/
                  Ltrim(Rtrim(@orderno)),	 /*order_no*/
                  Ltrim(Rtrim(@tradeno)),	 /*trade_no*/
                  Ltrim(Rtrim(@sellbuy)),	/*sell_buy*/
                  Ltrim(Rtrim(@ContractNo)),	/*contract_no*/
                  Ltrim(Rtrim(@@ContractNo)),	/*new_contract_no*/
                  0,		/*brokerage*/
                  0,		/*new_brokerage*/
                  @orig_mkt_rate,		/*market_rate*/
                  @mkrate,		/*new_market_rate*/
                  @net_rate,		/*net_rate*/
                  @net_rate,		/*new_net_rate*/
                  @orig_qty,		/*qty*/
                  @qty,		/*new_qty*/
                  Ltrim(Rtrim(@Memcode)),	 /*participant_code*/
                  Ltrim(Rtrim(@Memcode)),	 /*new_participant_code*/
                  Ltrim(Rtrim(@StatusName)),	 /*username*/
                  Ltrim((@FromWhere)),	 /*module*/
                  'AfterContCursorIns_With_ContNo',	/*called_from*/
                  Getdate(),	/*timestamp*/
                  Ltrim(Rtrim('')),	/*extrafield3*/
                  Ltrim(Rtrim('')),	/*extrafield4*/
                  Ltrim(Rtrim(''))	 /*extrafield5*/
                  )
    END

GO
