-- Object: PROCEDURE dbo.InsertToLedger2_12092014
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[InsertToLedger2_12092014]               
(            
      @sessionid varchar(15),              
      @vno varchar(12),              
      @branchflag tinyint,              
      @costcenterflag tinyint,              
      @costenable char(1),              
      @statusid as varchar(30),              
      @statusname as varchar(30)              
)             
            
As              
            
set nocount on            
            
declare              
      @@onlyall tinyint,              
      @@onebranch tinyint,              
      @@multibranch tinyint,              
      @@oneBranchAll tinyint,              
      @@MultiBranchall tinyint,              
      @@Allcount smallint,              
      @@Branchcount smallint,              
      @@OldBranch varchar(10),              
      @@vtype varchar(2),              
      @@party2 varchar(10),              
      @@costbreakup tinyint,              
      @@costcode1 int,              
              
/*=======================================================================================            
      Fields retrived from templedger2             
=======================================================================================*/            
      @@category varchar(20),              
      @@branch varchar(25),              
      @@amt    money,              
      @@vtyp varchar(2),              
      @@vno  varchar(12),              
      @@lno  int,              
      @@drcr char(1),              
      @@costcode smallint,              
      @@booktype varchar(2),              
      @@sessionid varchar(25),              
      @@party_code varchar(10),              
      @@mainbr as varchar(10),                 
      @@rcursor as cursor              
              
if @branchflag = 1 and @costcenterflag  = 1              
begin              
/*=======================================================================================            
      0 = True   1 = False                
=======================================================================================*/            
      select @@onlyall = 0               /* True */              
      select @@onebranch = 1             /* True */              
      select @@multibranch = 1           /* False */              
      select @@onebranchall = 1          /* False */              
      select @@Multibranchall = 1        /* False */              
                    
      select @@allcount = 0              
      select @@Branchcount = 0              
      select @@OldBranch = ''              
              
      SELECT @@mainbr =             
                  (            
                        SELECT             
                              BranchName             
                        FROM branchaccounts             
                        WHERE DefaultAc = 1            
                  )             
              
      SELECT @@vtype =             
                  (            
                        SELECT DISTINCT             
                              vtype             
                        FROM templedger2             
                        WHERE rtrim(sessionid) = rtrim(@sessionid)             
                              AND vno = @vno            
                  )             
                 
      SELECT @@costbreakup =             
                  (            
                        SELECT             
                              count(*)             
                        FROM templedger2             
                        WHERE rtrim(sessionid) = rtrim(@sessionid)             
                              AND category = 'BRANCH'             
                              AND vno = @vno             
                              AND costflag = 'C'            
                  )             
              
      /*=======================================================================================            
            if @@vtype = 8 and @@costbreakup > 0              
      =======================================================================================*/            
      if @@costbreakup > 0              
      begin              
            DELETE t2           
            FROM templedger2 t2            
            WHERE rtrim(sessionid) = rtrim(@sessionid)             
                  AND upper(rtrim(branch)) = 'ALL'             
                  AND vno = @vno             
                  AND costflag = 'A'             
                  AND exists             
                        (             
                              SELECT             
           party_code             
                              FROM templedger2 t1            
                              WHERE t1.party_code = t2.party_code and t1.lno = t2.lno and t1.costflag = 'C'            
        )             
            
            DELETE t2            
            FROM templedger2 t2            
            WHERE rtrim(sessionid) = rtrim(@sessionid)             
                  AND vno = @vno             
                  AND costflag = 'C'             
       AND exists             
                        (             
                              SELECT             
                                    party_code             
                              FROM templedger2 t1            
                              WHERE t1.party_code = t2.party_code and t1.lno = t2.lno and t1.costflag = 'A' and upper(rtrim(t1.branch)) <> 'ALL'            
                        )             
            
  end          
            
           UPDATE             
                  templedger2             
                  SET costflag = 'A'            
                  
            if @@vtype = 5 or @@vtype = 6 or @@vtype = 7 or @@vtype = 8 or @@vtype = 24              
            begin              
                  UPDATE             
                    templedger2             
                        SET branch = 'HO'             
                  WHERE upper(rtrim(branch)) = 'ALL'             
                        AND costflag = 'A'             
                          
      end              
        
              
      set @@rcursor = cursor for              
            SELECT             
                  category,            
                  branch,            
                  paidamt,            
                  vtype,            
                  vno,            
                  lno,            
                  drcr,            
                  costcode,            
                  booktype,            
                  sessionid,            
                  party_code             
            FROM templedger2             
            WHERE category = 'BRANCH'             
                  AND rtrim(sessionid) = rtrim(@sessionid)             
                  AND vno =@vno             
                  AND costflag = 'A'             
      open @@rcursor              
      fetch next from @@rcursor               
      into @@category, @@branch, @@amt, @@vtyp, @@vno, @@lno, @@drcr, @@costcode, @@booktype, @@sessionid , @@party_code               
              
      while @@fetch_status = 0              
      begin              
            if rtrim(@@branch) = 'ALL'              
            begin              
                  select @@Allcount = @@Allcount + 1              
            end              
            else               
            if rtrim(@@branch) = @@OldBranch              
            begin              
                  select @@OnlyAll = 1              
            end              
            else              
            if @@OldBranch = ''              
            begin              
                  select @@OnlyAll = 1              
                  select @@OldBranch = rtrim(@@branch)              
                  select @@Branchcount = @@Branchcount + 1              
            end              
            else               
            begin              
                  select @@OnlyAll = 1      
                  select @@Branchcount = @@Branchcount + 1              
                  select @@Multibranch = 0              
                  select @@OneBranch = 1                         
            end              
                        
            fetch next from @@rcursor               
            into @@category, @@branch, @@amt, @@vtyp, @@vno, @@lno, @@drcr, @@costcode, @@booktype, @@sessionid , @@party_code               
      end              
      close @@rcursor              
      deallocate @@rcursor     
          
                  
              
/*      select "AllCount = " + convert(varchar,@@Allcount)              
      select "BranchCount = " + convert(varchar,@@BranchCount)  */            
              
      if @@onlyall = 1              
      begin              
        if @@Allcount = 0              
            begin              
                  if @@branchcount = 1              
                  begin              
                        select @@onebranch = 0              
                        select @@multibranch = 1              
                        select @@oneBranchAll = 1              
                        select @@MultiBranchall = 1              
            end              
                  else              
                  begin              
                        select @@Multibranch = 0              
                        select @@onebranch = 1              
                        select @@oneBranchAll = 1              
                        select @@MultiBranchall = 1              
                  end              
            end              
            else              
            begin              
           if @@branchcount = 1              
                  begin              
                        select @@onebranchAll = 0              
                        select @@onebranch = 1              
                        select @@multibranch = 1              
                        select @@MultiBranchall = 1              
                  end              
                  else              
                  begin              
                        select @@MultibranchAll = 0              
          select @@onebranch = 1              
                        select @@multibranch = 1              
                        select @@onebranchAll = 1              
                  end              
            end              
      end       
          
                 
              
      if @@Onlyall = 0               
      begin              
            SELECT             
                  @@vtype =             
                        (            
                              SELECT DISTINCT             
                                    vtype             
                              FROM templedger2             
                              WHERE rtrim(sessionid) = rtrim(@sessionid)             
                                    AND vno = @vno            
        )             
                  SELECT             
                  @@party2 =             
                        (            
                              SELECT DISTINCT             
                                    party_code             
                              FROM templedger2             
                              WHERE rtrim(sessionid) = rtrim(@sessionid)             
                                    AND upper(rtrim(branch)) = 'ALL'             
                                    AND vno = @vno             
                                    AND costflag = 'A'             
                                    AND lno = 1            
                        )             
            SELECT             
                  @@costbreakup =             
                        (            
                              SELECT             
                                    count(*)             
                              FROM templedger2             
                              WHERE rtrim(sessionid) = rtrim(@sessionid)             
                                    AND category = 'BRANCH'             
                                    AND vno = @vno             
                                    AND costflag = 'C'            
                        )             
                  
            if @@costbreakup > 0 and (@@vtype = '3' or @@vtype = '4')               
            begin              
                  DELETE             
                  FROM templedger2             
    WHERE rtrim(sessionid) = rtrim(@sessionid)             
                        AND category = 'BRANCH'             
                        AND upper(branch) = 'ALL'             
                        AND vno = @vno             
                        AND costflag = 'A'             
                  
                  DELETE             
                  FROM templedger2             
                  WHERE rtrim(sessionid) = rtrim(@sessionid)             
                        AND category = 'BRANCH'             
                        AND upper(drcr) = 'C'             
                        AND vno = @vno             
                        AND costflag = 'C'             
                  
                  INSERT             
                  INTO templedger2             
                  SELECT             
                        category,             
                        branch,             
                        paidamt,             
                        vtype,             
                        vno,             
                        1,             
                        (             
                              CASE             
                                    WHEN drcr = 'D'             
                                    THEN 'C'             
                                    ELSE 'D'             
                              END            
                        ),             
                        costcode,             
                        booktype,             
                        sessionid,             
                        @@party2,             
                        costflag,             
                        1             
                  FROM templedger2             
                  WHERE rtrim(sessionid) = rtrim(@sessionid)             
                        AND category = 'BRANCH'             
                        AND vno = @vno             
            end       
                
                       
if @@costbreakup > 0 and (@@vtype = '1' or @@vtype = '2' )              
            begin              
                  DELETE             
                  FROM templedger2             
                  WHERE rtrim(sessionid) = rtrim(@sessionid)             
                        AND category = 'BRANCH'             
                        AND upper(branch) = 'ALL'             
                        AND vno = @vno             
                        AND costflag = 'A'             
                  
                  DELETE             
                  FROM templedger2             
                  WHERE rtrim(sessionid) = rtrim(@sessionid)             
                        AND category = 'BRANCH'             
        AND upper(drcr) = 'D'             
                        AND vno = @vno             
                        AND costflag = 'C'             
                  
                  INSERT             
                  INTO templedger2             
                  SELECT             
                        category,             
                        branch,             
                        paidamt,             
                        vtype,             
                        vno,             
                        1,             
                        (             
                              CASE             
                                    WHEN drcr = 'D'             
                                    THEN 'C'             
                           ELSE 'D'           
                              END            
                        ),             
                        costcode,             
                        booktype,             
                        sessionid,             
                        @@party2,             
                        costflag,             
                        1             
                  FROM templedger2             
                  WHERE rtrim(sessionid) = rtrim(@sessionid)             
                        AND category = 'BRANCH'             
                        AND vno = @vno             
            end              
      end       
          
     
              
              
      if @@Onlyall = 0               
      begin               
            if @statusid = 'BRANCH'               
            begin      
            PRINT 'SURESH'            
                  INSERT             
                  INTO ledger2             
                  SELECT             
                        vtype,             
                        vno,             
                        lno,             
                        drcr,             
                        paidamt,             
                        c.costcode,             
                        BookType,            
                        upper(party_code)             
                  FROM templedger2 t,             
                        costmast c             
                  WHERE rtrim(sessionid) = rtrim(@sessionid)             
                        AND rtrim(costname) = rtrim(@statusname)             
                        AND category = 'BRANCH'             
                        AND vno =@vno             
                        AND costflag = 'A'             
            end              
            else              
            begin     
                
            PRINT 'SURESH1'             
                  INSERT             
                  INTO ledger2             
                  SELECT             
                        vtype,             
                        vno,             
                        lno,             
                        drcr,             
                        paidamt,             
                        c.costcode,             
                        BookType,            
                        upper(party_code)             
                  FROM templedger2 t,             
                        Branchaccounts b,             
                        costmast c             
                  WHERE rtrim(sessionid) = rtrim(@sessionid)             
                        AND DefaultAc = 1             
                        AND rtrim(BranchName) = rtrim(costname)             
                        AND category = 'BRANCH'             
                        AND vno =@vno             
                        AND costflag = 'A'             
            end              
      end              
      else              
      if @@OneBranch = 0              
      begin      
      PRINT '121'            
            INSERT             
            INTO ledger2             
            SELECT             
                  vtype,             
                  vno,             
                  lno,             
                  drcr,             
                  paidamt,             
                  c.costcode,             
                  BookType,             
                  upper(party_code )             
            FROM templedger2 t,             
                  costmast c             
            WHERE rtrim(sessionid) = rtrim(@sessionid)             
                  AND rtrim(branch) = rtrim(costname)             
                  AND category = 'BRANCH'             
                  AND vno =@vno             
                  AND costflag = 'A'             
      end              
      else              
      if @@MultiBranch = 0              
      Begin     
          
      PRINT '141'             
            INSERT             
            INTO ledger2             
            SELECT             
                  vtype,             
                  vno,             
                  lno,             
                  drcr,             
                  paidamt,             
                  c.costcode,             
                  BookType,             
                  upper(party_code)             
            FROM templedger2 t,             
                  costmast c             
            WHERE rtrim(sessionid) = rtrim(@sessionid)             
                  AND rtrim(branch) = rtrim(costname)             
                  AND category = 'BRANCH'             
                  AND vno =@vno             
                  AND costflag = 'A'             
                  
            INSERT             
            INTO ledger2         
            SELECT             
                  vtype,             
                  vno,             
                  lno,             
                  drcr,             
                  paidamt,             
                  costcode=             
                        (             
                              SELECT             
                                    costcode             
                              FROM costmast c,             
 branchaccounts b             
                              WHERE DefaultAc = 1             
                                    AND rtrim(branchname) = rtrim(costname)            
                        ),             
                  BookType,             
                  upper(BrControlAc)             
            FROM templedger2 t,             
                  branchaccounts b             
            WHERE rtrim(sessionid) = rtrim(@sessionid)             
                  AND rtrim(branch) = rtrim(branchname)             
                  AND category = 'BRANCH'             
                  AND vno =@vno             
                  AND costflag = 'A'             
                  AND rtrim(branch) <> rtrim(@@mainbr)             
                  
            INSERT             
            INTO ledger2             
    SELECT             
                  vtype,             
                  vno,             
                  lno,             
                  (             
                        CASE             
                              WHEN drcr= 'd'             
                              OR drcr = 'D'             
                              THEN 'C'             
                              ELSE 'D'             
                        END            
                  ),             
                  paidamt,             
                  c.costcode,             
                  BookType,             
                  upper(MainControlAc)             
            FROM templedger2 t,             
                  costmast c,             
                  branchaccounts b             
            WHERE rtrim(sessionid) = rtrim(@sessionid)             
                  AND rtrim(branch) = rtrim(costname)             
                  AND rtrim(BranchName) = rtrim(branch)             
                  AND category = 'BRANCH'             
                  AND vno =@vno             
                  AND costflag = 'A'             
                  AND rtrim(branch) <> rtrim(@@mainbr)             
      end              
      else              
      if @@OneBranchAll = 0               
      begin              
      set @@rcursor = cursor for              
            SELECT             
                  branch             
            FROM templedger2             
            WHERE category = 'BRANCH'             
                  AND rtrim(sessionid) = rtrim(@sessionid)             
                  AND vno = @vno             
                  AND branch <> 'ALL'             
                  AND costflag = 'A'             
            ORDER BY branch             
            open @@rcursor              
            fetch next from @@rcursor into @@branch               
     while @@fetch_status = 0              
            begin              
            SELECT @@costcode1 =             
                        (             
                              SELECT             
                                    costcode             
                              FROM costmast             
                              WHERE rtrim(@@branch) = rtrim(costname)            
                        )             
                  fetch next from @@rcursor into @@branch               
                  end              
                  close @@rcursor              
                  deallocate @@rcursor              
                        
                  INSERT             
                  INTO ledger2             
                  SELECT             
                        vtype,             
                        vno,             
                        lno,             
                        drcr,             
                        paidamt,        
                        c.costcode,             
                        BookType,             
                        upper(party_code)             
                  FROM templedger2 t,             
                        costmast c             
                  WHERE rtrim(sessionid) = rtrim(@sessionid)             
                        AND rtrim(branch) = rtrim(costname)             
                        AND category = 'BRANCH'             
                        AND vno =@vno             
                        AND costflag = 'A'             
                        
                  INSERT             
                  INTO ledger2             
                  SELECT             
                        vtype,             
                        vno,             
                        lno,             
                        drcr,             
                        paidamt,             
                        @@costcode1,             
                        BookType,             
                        upper(party_code)             
                  FROM templedger2 t             
                  WHERE rtrim(sessionid) = rtrim(@sessionid)             
                        AND rtrim(branch) = 'ALL'             
                        AND category = 'BRANCH'             
                        AND vno =@vno             
                        AND costflag = 'A'             
            end              
      end              
              
      if @costcenterflag  = 1              
      begin              
            INSERT             
            INTO ledger2             
            SELECT             
                  vtype,             
                  @vno,             
                  lno,             
                  drcr,             
                  paidamt,             
                  costcode,             
                  BookType,            
                  upper(party_code )             
            FROM templedger2 t             
            WHERE rtrim(sessionid) = rtrim(@sessionid)             
                  AND vno = @vno             
                  AND costflag = 'C'             
      end

GO
