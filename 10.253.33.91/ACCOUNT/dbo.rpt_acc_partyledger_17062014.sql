-- Object: PROCEDURE dbo.rpt_acc_partyledger_17062014
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--Exec rpt_acc_partyledger 'Nov  1 2005','Nov 14 2005','zzzzzz','zzzzzz','ACCODE','vdt','broker','broker',''        
        
/*---------------------------------------------------------------------                                  
 proc name rpt_acc_partyledger                                  
 parameters fdate - from date                                  
            tdate - date to                                  
            fcode - ac code from                                  
            tcode - ac code to                                  
            strorder - printing order,  possible vaues  ACCODE ,  ACNAME                                  
            selectby - report selection by ,  possible values vdt,  edt                                  
            statusid - possiblevalues 'BROKER', 'CLIENT', 'FAMILY', 'SUBBORKER', 'FAMILY', 'BRANCH'                                  
                                  
 last modified : Sep 28 2004 eff wise opbal                                   
*/---------------------------------------------------------------------                                  
          
                                  
CREATE procedure rpt_acc_partyledger_17062014        
(                                   
      @fdate varchar(11),             /* As mmm dd yyyy */                                  
      @tdate varchar(11),             /* As mmm dd yyyy */                                  
      @fcode varchar(10),                                   
      @tcode varchar(10),                                   
      @strorder varchar(6),                                   
      @selectby varchar(3),                                   
      @statusid varchar(15),                                   
      @statusname varchar(15),                                   
      @strbranch varchar(10)                                  
)                    
                    
As                                  
                          
Set Nocount On                          
                               
Declare @@opendate   as varchar(11)                                  
                                  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                  
        
        
/*        
        
Exec uppili_rpt_acc_partyledger 'Aug 1 2005','Aug 16 2005','11100105','11100105','ACCODE','vdt','broker','broker',''                  
        
Exec rpt_acc_partyledger 'Apr  1 2004', 'Sep 17 2004', 'KOLK41737', 'KOLK41737', 'edt', 'edt', 'branch', 'retailkolh', ''                      
Exec  rpt_acc_partyledger 'Apr 1 2005','Aug 16 2005','11100237','11100237','ACCODE','vdt','broker','broker',''                  
Exec rpt_acc_partyledger 'Apr 1 2005','Aug 15 2005','W2600730','w2600730','ACCODE','vdt','branch','bi00',''        
Exec rpt_acc_partyledger 'Apr  1 2005','Aug 16 2005','000','zzzz','ACCODE','vdt','broker','broker',''                
        
*/        
        
        
/*---------------------------------------------------------------------          
Getting last opening date           
        
To Use Start Date (SDTCUR) From Parameter Table Where @fdate Is Between Start Date (SDTCUR) And End Date (LDTCUR)         
*/---------------------------------------------------------------------          
        
/*        
        
if upper(@selectby) = 'VDT'                                  
begin                                  
      Select           
            @@opendate =           
                  (          
                        Select           
                              left(convert(varchar, isnull(max(vdt), 0), 109), 11)           
                        from           
                              ledger (nolock)           
                        where           
                              vtyp = 18           
                              and vdt <= @fdate           
                  )                                  
end                                  
else                                  
begin        
      Select         
            @@opendate =         
                  (         
                        Select         
  left(convert(varchar, isnull(max(edt), 0), 109), 11)         
                        from         
                              ledger  (nolock)         
           where         
                              vtyp = 18         
                              and edt <= @fdate         
                  )        
end                            */        
        
select @@OpenDate = left(convert(varchar,sdtcur,109),11) from parameter where @fdate between sdtcur and ldtcur        
        
          
            
        
          
          
          
/*---------------------------------------------------------------------          
Getting client list          
*/---------------------------------------------------------------------          
        
        
/*CREATE TABLE [#LedgerClients] (        
 [Party_code] [varchar] (10) ,        
    [AcName]     [varchar] (100),        
 [Bank_Name] [varchar] (50) ,        
 [L_Address1] [varchar] (40) ,        
 [L_Address2] [varchar] (40) ,        
 [L_Address3] [varchar] (40),        
 [L_city] [varchar] (40),        
 [L_zip] [varchar] (10) ,        
 [Res_Phone1] [varchar] (15),        
 [Branch_cd] [varchar] (10),        
 [Family] [varchar] (10) ,        
 [Sub_Broker] [varchar] (10) ,        
 [trader] [varchar] (20),        
 [Cl_type] [varchar] (3) ,        
 [Cltdpid] [varchar] (16)         
) ON [PRIMARY]  */      
      
select * into #LedgerClients from LedgerClients_Test      
        
        
        
if @statusid <> 'BROKER'        
begin          
      if @strBranch = ''         
      begin        
            set transaction isolation level read uncommitted        
            insert into #LedgerClients        
            Select           
                  c2.Party_code,         
                  c1.Long_name,          
                  Bank_Name =isnull(PB.bank_name, ''),                                   
                  L_Address1,           
                  L_Address2,           
                  L_Address3,           
                  L_city,           
                  L_zip,           
                  Res_Phone1,           
                  c1.Branch_cd,                                   
                  Family,           
                  c1.Sub_Broker,           
                  trader,           
                  Cl_type,           
                  Cltdpid =isnull(Cltdpid, '')                                
            from                                  
                  msajag.dbo.client1 c1 (nolock),           
                  msajag.dbo.client2 c2  (nolock)           
                  left outer join msajag.dbo.client4  c4          
--WITH(INDEX(client4ind),nolock)          
                              Left Outer Join msajag.Dbo.PoBank PB (nolock)        
                                    on         
                                    (        
                                           ltrim(rtrim(cast(c4.bankid  as char))) =  ltrim(rtrim(cast(pb.bankid  as char)))          
                                    )        
                  on                                  
                  (          
                        c2.party_code=c4.party_code            
                        and  Depository NOT IN ('NSDL', 'CDSL')            
                        and  DefDp=1          
                  )         
        
                                                         
            Where           
                  c1.cl_code=c2.cl_code                                  
                  And c1.Branch_Cd Like (Case When @statusid = 'branch' then @statusname else  '%' end)                                  
                  And sub_broker Like (Case When @statusid = 'subbroker' then @statusname else  '%' end)                                  
                  And Trader Like (Case When @statusid = 'trader' then @statusname else  '%' end)              
                  And C1.Family Like (Case When @statusid = 'family' then @statusname else  '%' end)                                  
                  And C1.Area Like (Case When @statusid = 'Area' then @statusname else  '%' end)                                  
                  And C1.Region Like (Case When @statusid = 'Region' then @statusname else  '%' end)                                  
                  And C2.Party_Code Like (Case When @statusid = 'client' then @statusname else  '%' end)                                                          
                  and c2.Party_code >= @fcode           
        And c2.Party_code <= @tcode                                   
      End        
      ELSE        
      BEGIN        
                  set transaction isolation level read uncommitted        
                  insert into #LedgerClients        
                  Select           
  c2.Party_code,         
  c1.Long_name,          
  Bank_Name =isnull(PB.bank_name, ''),                                   
  L_Address1,           
  L_Address2,           
  L_Address3,         
  L_city,           
  L_zip,           
  Res_Phone1,           
  c1.Branch_cd,                                   
  Family,           
  c1.Sub_Broker,           
  trader,           
  Cl_type,           
  Cltdpid =isnull(Cltdpid, '')                     
                  from                                  
                        msajag.dbo.client1 c1 (nolock),           
                        msajag.dbo.client2 c2  (nolock)           
                        left outer join msajag.dbo.client4  c4          
--with(index(client4ind),nolock)        
                                    Left Outer Join msajag.Dbo.PoBank PB (nolock)        
                                          on         
                                          (        
                                                 ltrim(rtrim(cast(c4.bankid  as char))) =  ltrim(rtrim(cast(pb.bankid  as char)))          
                                          )        
                        on                                  
                        (          
                              c2.party_code=c4.party_code            
                              and  Depository NOT IN ('NSDL', 'CDSL')            
                              and  DefDp=1          
                        )         
              
                                                               
                  Where           
                        c1.cl_code=c2.cl_code                                  
                        And c1.Branch_Cd Like (Case When @statusid = 'branch' then @statusname else  '%' end)                                  
                        And sub_broker Like (Case When @statusid = 'subbroker' then @statusname else  '%' end)                                  
                        And Trader Like (Case When @statusid = 'trader' then @statusname else  '%' end)                                  
                        And C1.Family Like (Case When @statusid = 'family' then @statusname else  '%' end)                                  
                        And C1.Area Like (Case When @statusid = 'Area' then @statusname else  '%' end)                                  
                        And C1.Region Like (Case When @statusid = 'Region' then @statusname else  '%' end)                                  
                        And C2.Party_Code Like (Case When @statusid = 'client' then @statusname else  '%' end)                                  
                        and c1.Branch_Cd = @strbranch        
                        and c2.Party_code >= @fcode           
                        And c2.Party_code <= @tcode                                   
      END        
End        
else        
begin        
      if @strBranch = ''        
      begin        
        
                  set transaction isolation level read uncommitted        
        
                  insert into #LedgerClients   
                  Select           
                        c2.Party_code,           
                        c1.Long_Name,        
                        Bank_Name =isnull(PB.bank_name, ''),                                    
                        L_Address1,           
                        L_Address2,           
                        L_Address3,           
                        L_city,           
                        L_zip,           
              Res_Phone1,           
                        c1.Branch_cd,                                   
                        Family,           
                        c1.Sub_Broker,           
                        trader,           
                        Cl_type,           
                        Cltdpid =isnull(Cltdpid, '')                                
                  from                                  
                        msajag.dbo.client1 c1 (nolock),           
                        msajag.dbo.client2 c2  (nolock)           
                        left outer join msajag.dbo.client4  c4         
--with(index(client4ind),nolock)        
                                          Left Outer Join msajag.Dbo.PoBank PB (nolock)        
                                                on         
                                                (        
               ltrim(rtrim(cast(c4.bankid  as char))) =  ltrim(rtrim(cast(pb.bankid  as char)))          
                                                )        
                        on                    
                        (          
                              c2.party_code=c4.party_code            
                              and  Depository NOT IN ('NSDL', 'CDSL')            
                              and  DefDp=1          
                        )                                  
                  Where           
                        c1.cl_code=c2.cl_code                                                           
                        and c2.Party_code >= @fcode           
                        And c2.Party_code <= @tcode                                   
      end        
      else        
      begin        
                  set transaction isolation level read uncommitted        
                  insert into #LedgerClients        
                  Select           
                        c2.Party_code,           
                        c1.Long_Name,        
                        Bank_Name =isnull(PB.bank_name, ''),                                    
                        L_Address1,           
                        L_Address2,           
                        L_Address3,           
                        L_city,           
                        L_zip,           
                        Res_Phone1,           
                        c1.Branch_cd,                                   
                        Family,           
                        c1.Sub_Broker,           
                        trader,           
                        Cl_type,           
                        Cltdpid =isnull(Cltdpid, '')                                
                  from                                  
                        msajag.dbo.client1 c1 (nolock),           
                        msajag.dbo.client2 c2  (nolock)           
                        left outer join msajag.dbo.client4  c4         
--with(index(client4ind),nolock)        
                                          Left Outer Join msajag.Dbo.PoBank PB (nolock)        
                                                on         
                                                (        
                                                       ltrim(rtrim(cast(c4.bankid  as char))) =  ltrim(rtrim(cast(pb.bankid  as char)))          
                                                )        
                        on                                  
                        (          
                              c2.party_code=c4.party_code            
                          and  Depository NOT IN ('NSDL', 'CDSL')            
                              and  DefDp=1          
                        )                                  
                  Where           
                        c1.cl_code=c2.cl_code                                  
                        and c1.Branch_Cd = @strbranch        
                        and c2.Party_code >= @fcode           
                        And c2.Party_code <= @tcode                                   
      end        
end                        
        
          
        
Create Index PartyIdx on #LedgerClients (Party_code)        
        
if @statusid='broker'        
 begin        
        
  --including remissor also at report        
  Insert into #LedgerClients        
          
  Select Sub_Broker Party_code,Sub_Broker Long_name,' ' Bank_Name ,                
  Address1 L_Address1,Address2 L_Address2,' ' L_Address3,City L_city,Zip L_zip,        
  Phone1 Res_Phone1,Branch_Code Branch_cd,' ' Family,' 'Sub_Broker,' ' trader,' ' Cl_type,' ' Cltdpid        
  From msajag.dbo.SubBrokers         
  Where        
  Sub_broker >= @fcode        
                      and Sub_broker  <= @tcode        
  and Sub_Broker not in (Select Party_Code From #LedgerClients )        
        
 end        
        
        
/*---------------------------------------------------------------------          
Creating blank table for opening balance          
*/---------------------------------------------------------------------          
        
          
Select           
      CltCode,           
      oppbal=Vamt           
into           
      #OppBalance           
From           
      Ledger  (nolock)           
where           
      1=2                                  
          
        
          
          
/*---------------------------------------------------------------------          
Getting Voucher Date Wise opening balance          
        
Status Check is not done here.         
      Even for Branch Login's Etc. data is populated for All Clients.        
      It will work well for Single Client Report Only.        
Like Condition for Date Check to be removed and replaced with Equal To Condition         
*/---------------------------------------------------------------------          
          
if @selectby = 'vdt'                                  
begin                                  
      if @@opendate = @fdate                                   
      begin                                  
                  set transaction isolation level read uncommitted        
            Insert into #OppBalance                                            
                  select Cltcode, oppbal = IsNull(sum( case when upper(led.drcr) = 'D' then led.vamt else -led.Vamt end), 0)          
                  from        
                  (        
                              select                   
                                    a.CltCode, a.Drcr, sum(a.vamt) Vamt        
                  --                  oppbal = IsNull(sum( case when upper(a.drcr) = 'D' then a.vamt else -a.vamt end), 0)                                  
                              from                   
                                    ledger a  ,        
--with(index(ledind),nolock),        
                                    #LedgerClients LC                             
                              where                   
                                    a.cltcode >= @FCode                   
                                    And a.CltCode <=@TCode                   
                                    and a.CltCode = LC.Party_code        
                                    and  a.vdt like @fdate + '%'                       
                                    and vtyp = 18                                   
                              Group By                   
                                    a.CltCode,a.DrcR          
                  ) led        
                  Group by led.Cltcode        
            
      end                                  
      else                                  
      begin                 
        
/*                         
            Insert into            
                  #OppBalance                                   
            select           
                  CltCode,           
                  oppbal = IsNull(sum( case when upper(b.drcr) = 'D' then b.vamt else -b.vamt end), 0)                                    
            from           
                  ledger b        (nolock)                             
            where           
                  b.cltcode >=@FCode           
                  And B.CltCode <= @TCode            
                  and  b.vdt >=  @@opendate + ' 00:00:00'           
        and vdt < @fdate                                   
            Group By           
                  CltCode                                  
*/        
        
                  set transaction isolation level read uncommitted        
                  Insert into #OppBalance                                            
                  select led.Cltcode, oppbal = IsNull(sum( case when upper(led.drcr) = 'D' then led.vamt else -led.Vamt end), 0)          
                  from        
                  (        
                              select                   
                                    a.CltCode, a.Drcr, sum(a.vamt) Vamt        
                  --                  oppbal = IsNull(sum( case when upper(a.drcr) = 'D' then a.vamt else -a.vamt end), 0)       
                              from                   
                                    ledger a  ,        
--with(index(ledind),nolock),        
                                    #LedgerClients LC                      
                              where                   
                                    a.cltcode >= @FCode                   
                                    And a.CltCode <=@TCode            
                                    and a.CltCode = LC.Party_code               
                                    and  a.vdt >=  @@opendate + ' 00:00:00'           
                                    and a.vdt < @fdate                                   
                              Group By                   
                                    a.CltCode,a.DrcR          
                  ) led        
                  Group by led.Cltcode        
            
      end                                  
end                                   
          
          
          
          
/*---------------------------------------------------------------------          
Getting Effective Date Wise opening balance          
        
Status Check is not done here.         
      Even for Branch Login's Etc. data is populated for All Clients.        
      It will work well for Single Client Report Only.        
Like Condition for Date Check to be removed and replaced with Equal To Condition         
*/---------------------------------------------------------------------          
        
if @selectby = 'edt'                                  
begin                                   
      if @@opendate = @fdate                                   
      begin                
            set transaction isolation level read uncommitted                        
            Insert into            
                  #OppBalance                                
            select           
                  cltcode,            
                  opbal=sum(opbal)                                
            from                                
                  (                               
                  Select           
                              cltcode,            
                              opbal = IsNull(sum( case when upper(drcr) = 'D' then vamt else -vamt end), 0)                                    
                        from           
                              ledger      (nolock)                             
               where           
       cltcode >= @FCode                   
       and CltCode <=@TCode                   
       and edt like @@opendate + '%'           
       and vtyp = 18                                
                        group by           
                              cltcode                                
                        union all                                
                        Select           
                              CltCode,           
                              oppbal = IsNull(sum( case when upper(b.drcr) = 'C' then b.vamt else -b.vamt end), 0)                                    
                        from           
                              ledger b      (nolock)                               
                        where           
                              b.cltcode >=@FCode           
                              And B.CltCode <= @TCode       
                              and  b.edt >=  @@opendate + ' 00:00:00'           
                              and vdt < @@opendate                                
                        group By           
                              CltCode                               
                  ) t                                
            Group By           
                  CltCode                                  
      end                                
      else                                
      begin                
            set transaction isolation level read uncommitted                        
            Insert into            
                  #OppBalance                                  
            select           
                  cltcode,            
                  opbal=sum(opbal)                                
            from                                
                  (                                 
               Select           
                              cltcode,            
                              opbal = IsNull(sum( case when upper(drcr) = 'D' then vamt else -vamt end), 0)                                    
                        from           
                              ledger    (nolock)                               
                        where           
       cltcode >= @FCode                   
       and CltCode <=@TCode                   
       and edt like @@opendate + '%'           
       and vtyp = 18                                
                        group by           
                              cltcode                                
                        union all                                
                        Select           
                              cltcode,            
                              opbal = sum( case when upper(drcr) = 'D' then vamt else -vamt end)                                
                        from           
                              ledger          (nolock)                         
                        where           
       cltcode >= @FCode             
       and CltCode <=@TCode                   
       and edt >= @@opendate + ' 00:00:00'           
       and edt < @fdate           
       and vtyp <> 18                                
                       group by           
                              cltcode                                 
                        union all             
                        Select           
                              CltCode,           
                              oppbal = IsNull(sum( case when upper(b.drcr) = 'C' then b.vamt else -b.vamt end), 0)                                    
                        from           
                              ledger b            (nolock)                         
                        where           
                              b.cltcode >=@FCode           
                              And B.CltCode <= @TCode            
                              and  b.edt >=  @@opendate + ' 00:00:00'           
and vdt < @@opendate                   
                        group By           
                              CltCode                                 
                  ) t                                
            group by           
                  cltcode                                
      end                                
end                                  
          
          
          
          
          
          
          
          
          
          
/*---------------------------------------------------------------------          
Generating blank structure for filtered Ledger           
*/---------------------------------------------------------------------          
          
Select           
      l.*,           
      shortdesc=space(35)           
into           
      #LedgerData           
from           
      Ledger l           
where           
      1 = 2                                  
          
          
          
        
          
/*---------------------------------------------------------------------          
Getting fiiltered ledger          
*/---------------------------------------------------------------------          
          
if @selectby = 'vdt'                                  
begin                       
      set transaction isolation level read uncommitted        
      Insert into           
            #LedgerData           
      Select           
            l.*,             
            isnull(v.shortdesc, '') shortdesc           
      from           
            Ledger l ,        
--with(index(ledind),nolock) ,            
            vMast v,         
            #LedgerClients LC           
      where           
            vdt >= @fdate + ' 00:00:00'                                  
            and l.vtyp = v.vtype            
            and l.vdt <= @tdate +' 23:59:59'           
            and l.CltCode >= @fcode           
            And l.CltCode <= @tcode        
            and l.CltCode = LC.party_code                                  
end                                   
else                                  
begin                                  
      set transaction isolation level read uncommitted        
      Insert into           
            #LedgerData           
      Select            
           l.*,            
            isnull(v.shortdesc, '') shortdesc           
      from           
            Ledger l ,        
--with(index(ledind), nolock) ,            
            vMast v,         
            #LedgerClients LC            
      where           
            edt >= @fdate + ' 00:00:00'                                   
            and l.vtyp = v.vtype            
            and edt <= @tdate +' 23:59:59'           
            and l.CltCode >= @fcode           
            And l.CltCode <= @tcode        
            and l.CltCode = LC.party_code                                  
end                                  
          
          
          
          
          
          
          
        
          
          
          
/*---------------------------------------------------------------------          
Getting lddger entries          
*/---------------------------------------------------------------------          
        
set transaction isolation level read uncommitted        
Select           
      BookType = l.booktype,            
      voudt=l.vdt,            
      effdt=l.edt,            
      ShortDesc = l.shortdesc,                                    
      dramt=(case when upper(l.drcr) = 'D' then l.vamt else 0 end),                                     
      cramt=(case when upper(l.drcr) = 'C' then l.vamt else 0 end),                                   
      Vno = l.vno,            
      ddno= l1.ddno,            
      Narration = l.Narration,            
      CltCode = c.Party_code,           
      Vtyp = l.vtyp,            
      Vdt = convert(varchar, l.vdt, 103),                                    
      Edt = convert(varchar, l.edt, 103),            
      Acname = c.AcName ,         
      opbal = cast(isnull(OB.OppBal,0) as Money),        
      L_Address1 = c.L_Address1,           
 L_Address2 = c.L_Address2,           
      L_Address3 = c.L_Address3,           
      L_City = c.L_city,           
      L_Zip = c.L_zip,           
      Res_Phone1 = c.Res_Phone1,           
      Branch_Cd = c.Branch_cd,            
      CrosAc = l.cltcode,                                   
      ediff=datediff(d, l.edt, getdate()),            
      Family = c.Family,           
      Sub_Broker = c.Sub_Broker,           
      Trader = c.trader,           
      Cl_Type = c.Cl_type,                                   
      Bank_Name = Cast(left(isnull(c.Bank_Name,''),50) as varchar(50)),           
      CltDpID = c.Cltdpid,            
      LNo = L.LNo,   
      PDT =L.Pdt                                  
into            
      #tmpLedger                                   
from            
      #LedgerClients c        
      Left Outer Join #LedgerData l (nolock)        
            left Outer Join Ledger1 L1 (nolock)        
            on         
            (        
                        l.vno = l1.vno        
                  and l.vtyp = l1.vtyp        
                  and l.booktype = l1.booktype        
                  and l.lno = l1.lno        
            )        
      on           
      (     
            l.cltcode=c.party_code          
      )                                  
      Left Outer Join #OppBalance OB        
      on           
      (          
            c.party_code=ob.Cltcode          
      )                                  
              
        
        
          
        
/*---------------------------------------------------------------------          
Updating cheque number          
*/---------------------------------------------------------------------          
        
/*        
          
Update           
      #TmpLedger           
Set           
      ddno = l1.ddno           
From           
      Ledger1 L1  (nolock)                                  
Where           
      l1.vno=#TmpLedger.vno           
      and l1.vtyp=#TmpLedger.vtyp           
      and l1.booktype=#TmpLedger.booktype           
      and l1.lno = #TmpLedger.lno                                   
*/          
          
          
          
          
          
          
          
          
          
/*---------------------------------------------------------------------          
Updating cross account code          
*/---------------------------------------------------------------------          
        
        
update           
      #tmpLedger           
set           
      #tmpLedger.crosac=b.cltcode           
from        
      ledger b  ,        
--with(index(LEDIND),nolock) ,            
      acmast v    (nolock)                                    
Where        
  b.cltcode = v.cltcode        
      and #tmpLedger.vno=b.vno        
      and #tmpLedger.vtyp=b.vtyp        
      And #tmpLedger.booktype=b.booktype        
      and v.accat=2        
      And ltrim(rtrim(#tmpLedger.vtyp)) in ('01', '1', '02', '2', '03', '3', '04', '4', '05', '5', '16', '17', '19', '20', '22', '23')         
        
          
          
          
          
/*---------------------------------------------------------------------          
Updating bank name          
*/---------------------------------------------------------------------          
          
/*        
        
update            
      #tmpLedger           
set           
      #tmpLedger.bank_name= b.bank_name            
from                                  
      msajag.dbo.pobank  b   (nolock)           
where           
      ltrim(rtrim(cast(b.bankid  as char))) = ltrim(rtrim(#tmpLedger.bank_name))                                  
*/                              
        
                          
/*        
update            
      #tmpLedger           
set           
      #tmpLedger.acname= a.acname            
from                                  
      acmast a   (nolock)           
where           
      ltrim(rtrim(a.cltcode)) = ltrim(rtrim(#tmpLedger.cltcode))                                  
          
*/        
          
          
          
          
          
drop table #LedgerClients        
drop table #LedgerData           
Drop Table #OppBalance          
          
          
/*---------------------------------------------------------------------          
Final Select Query          
*/---------------------------------------------------------------------          
          
if @strorder = 'ACCODE'                                  
begin                                  
      if @selectby = 'vdt'                                  
      begin                                   
            select           
                  l.booktype,        
                  l.voudt,        
                  l.effdt,        
                  l.shortdesc,        
        l.dramt,        
     l.cramt,        
                  l.vno,        
                  l.ddno,        
                  l.Narration,        
                  l.CltCode,        
                  l.vtyp,        
                  l.vdt,        
                  l.edt,        
                  l.Acname,        
                  l.opbal,        
                  l.L_Address1,        
                  l.L_Address2,        
                  l.L_Address3,        
                  l.L_city,        
                  l.L_zip,        
                  l.Res_Phone1,        
                  l.Branch_cd,        
                  l.CrosAc,        
                  l.ediff,        
                  l.Family,        
                  l.Sub_Broker,        
                  l.trader,        
                  l.Cl_type,        
                  l.Bank_Name,        
                  l.Cltdpid,        
                  l.LNo,  
                  l.pdt        
            from           
                  #tmpLedger l        
            order by           
                  l.cltcode, voudt                                  
      end                                  
      else                                  
      begin                                  
            select           
                  l.booktype,        
                  l.voudt,        
                  l.effdt,        
                  l.shortdesc,        
                  l.dramt,        
                  l.cramt,        
                  l.vno,        
                  l.ddno,        
                  l.Narration,        
                  l.CltCode,        
                  l.vtyp,        
                  l.vdt,        
                  l.edt,        
                  l.Acname,        
                  l.opbal,        
                  l.L_Address1,        
                  l.L_Address2,        
                  l.L_Address3,        
                  l.L_city,        
                  l.L_zip,        
                  l.Res_Phone1,        
                  l.Branch_cd,        
                  l.CrosAc,        
                  l.ediff,        
                  l.Family,        
                  l.Sub_Broker,        
                  l.trader,        
                  l.Cl_type,        
                  l.Bank_Name,        
                  l.Cltdpid,        
                  l.LNo,  
                  l.pdt        
            from           
                  #tmpLedger l        
            order by           
                  l.cltcode, effdt                                  
      end                                  
end                                  
else                                  
begin                                  
      if @selectby = 'vdt'                                  
      begin                                   
            select           
                  l.booktype,        
                  l.voudt,        
                  l.effdt,        
                  l.shortdesc,        
                  l.dramt,        
                  l.cramt,        
                  l.vno,        
                  l.ddno,        
         l.Narration,        
                  l.CltCode,        
                  l.vtyp,        
                  l.vdt,        
                  l.edt,        
                  l.Acname,        
                  l.opbal,        
                  l.L_Address1,        
                  l.L_Address2,        
                  l.L_Address3,        
                  l.L_city,        
                  l.L_zip,        
                  l.Res_Phone1,        
                  l.Branch_cd,        
                  l.CrosAc,        
                  l.ediff,        
                  l.Family,        
                  l.Sub_Broker,        
                  l.trader,        
                  l.Cl_type,        
                  l.Bank_Name,        
                  l.Cltdpid,        
                  l.LNo ,  
                  l.pdt       
            from           
                  #tmpLedger l        
            order by           
                  l.Acname, voudt                                  
      end                                  
      else                                  
      begin                                  
            select           
                  l.booktype,        
                  l.voudt,        
                  l.effdt,        
                  l.shortdesc,        
                  l.dramt,        
                  l.cramt,        
                  l.vno,        
                  l.ddno,        
                  l.Narration,        
                  l.CltCode,        
                  l.vtyp,        
                  l.vdt,        
                  l.edt,        
                  l.Acname,        
                  l.opbal,        
                  l.L_Address1,        
              l.L_Address2,        
                  l.L_Address3,        
                  l.L_city,        
                  l.L_zip,        
                  l.Res_Phone1,        
           l.Branch_cd,        
                  l.CrosAc,        
                  l.ediff,        
                  l.Family,        
                  l.Sub_Broker,        
                  l.trader,        
                  l.Cl_type,        
                  l.Bank_Name,        
                  l.Cltdpid,        
                  l.LNo,  
                  l.pdt        
            from           
                  #tmpLedger l        
            order by           
                  l.Acname, effdt                                  
      end                                  
end                                  
                                  
/*  ------------------------------   End Of the Proc  -------------------------------------*/

GO
