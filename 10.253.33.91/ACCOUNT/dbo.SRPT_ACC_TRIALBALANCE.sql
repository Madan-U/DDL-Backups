-- Object: PROCEDURE dbo.SRPT_ACC_TRIALBALANCE
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE SRPT_ACC_TRIALBALANCE                              
                          
@VDT VARCHAR(11),               /* AS ON DATE ENTERED BY USER */                              
@FLAG VARCHAR(15),              /* SORT ORDER FOR REPORT - CODEWISE OR NAMEWISE */                              
@VIEWOPTION VARCHAR(10),        /* OPTIONS FOR ACCOUNTS SELECTION - ALL, GL, PARTY */                              
@BALANCE VARCHAR(10),           /* NORMAL OR WITHOPBAL */                              
@STDATE VARCHAR(11),            /* START DATE ENTERED BY USER */                              
@CURRYRSTDATE VARCHAR(11), /* START DATE OF FINANCIAL YEAR */                              
@OPENENTRYFLAG INT,                              
@OPENINGENTRYDATE VARCHAR(11),  /* O/P ENTRY DATE ( VTYP = 18 ) FROUND FROM LEDGER FOR VDT <= LAST DATE ENTERED BY USER */                              
@STATUSID VARCHAR(20),          /* AS BROKER/BRANCH/CLIENT ETC. */                              
@STATUSNAME VARCHAR(20),        /* IN CASE OF BRANCH LOGIN BRANCHCODE */                              
@SORTBYDATE VARCHAR(3)          /* WHETHER REPORT IS BASED ON VDT OR EDT */                              
                              
AS                              
                          
DECLARE                            
@@COSTCODE AS VARCHAR(3)                          
                          
                  
/* Dump series */                  
                  
                  
insert into sebiinsp_glgrp                  
select b.grpcode,a.cltcode,b.grpname from                   
(select * from acmast where cltcode like '21%' and cltcode not in (Select cltcode from sebiinsp_glgrp)) a,                  
(select top 1 grpcode,grpname from sebiinsp_glgrp where cltcode like '21%') b                  
                
insert into sebiinsp_glgrp                  
select b.grpcode,a.cltcode,b.grpname from                   
(select * from acmast where cltcode like '35%' and cltcode not in (Select cltcode from sebiinsp_glgrp)                
and isnumeric(substring(cltcode,3,10)) =0                
) a,                  
(select top 1 grpcode,grpname from sebiinsp_glgrp where cltcode like '35%') b                  
                
                
insert into sebiinsp_glgrp                  
select b.grpcode,a.cltcode,b.grpname from                   
(select * from acmast where cltcode like '30%' and cltcode not in (Select cltcode from sebiinsp_glgrp)                
and isnumeric(substring(cltcode,3,10)) =0                
) a,                  
(select top 1 grpcode,grpname from sebiinsp_glgrp where cltcode like '30%') b                  
                
                
insert into sebiinsp_glgrp                  
select b.grpcode,a.cltcode,b.grpname from                   
(select * from acmast where cltcode like '6%' and cltcode not in (Select cltcode from sebiinsp_glgrp)                
and isnumeric(substring(cltcode,2,10)) =0                
) a,                  
(select top 1 grpcode,grpname from sebiinsp_glgrp where cltcode like '6%') b                  
                
                
                
insert into sebiinsp_glgrp                  
select b.grpcode,a.cltcode,b.grpname from                   
(                
select * from acmast where cltcode like '7%' and cltcode not in (Select cltcode from sebiinsp_glgrp)                 
and isnumeric(substring(cltcode,2,10)) =0                
) a,                  
(select top 1 grpcode,grpname from sebiinsp_glgrp where cltcode like '7%') b                  
                
                
insert into sebiinsp_glgrp                  
select b.grpcode,a.cltcode,b.grpname from                   
(                
select * from acmast where cltcode like '17%' and cltcode not in (Select cltcode from sebiinsp_glgrp)                
and isnumeric(substring(cltcode,3,10)) =0                
) a,                  
(select top 1 grpcode,grpname from sebiinsp_glgrp where cltcode like '17%') b                  
                
   
insert into sebiinsp_glgrp                  
select b.grpcode,a.cltcode,b.grpname from                   
(select * from acmast where cltcode like '16%' and cltcode not in (Select cltcode from sebiinsp_glgrp)                
and isnumeric(substring(cltcode,3,10)) =0                
) a,       
(select top 1 grpcode,grpname from sebiinsp_glgrp where cltcode like '16%') b                  
                
                
insert into sebiinsp_glgrp                  
select b.grpcode,a.cltcode,b.grpname from                   
(select * from acmast where cltcode like '40%' and cltcode not in (Select cltcode from sebiinsp_glgrp)                
and isnumeric(substring(cltcode,3,10)) =0                
) a,                  
(select top 1 grpcode,grpname from sebiinsp_glgrp where cltcode like '40%') b                  
                
                
/*...... copy the above code and add as many series required .... */                  
                              
SELECT * INTO  #sacmast_view FROM sacmast_view WHERE 1 = 2                              
SELECT CLTCODE,VAMT DRTOT,VAMT CRTOT, VAMT AMOUNT INTO #TEMPLEDGER FROM LEDGER WHERE 1=2                              
SELECT CLTCODE,VAMT DRTOT,VAMT CRTOT, VAMT AMOUNT,ACNAME,VNO BRANCHCODE, LNO ACCAT  INTO #TEMPLEDGERFINAL FROM LEDGER WHERE 1=2                              
      
      
INSERT INTO #TEMPLEDGER SELECT L.CLTCODE , 0,0,                            
AMOUNT = SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE -VAMT END)                              
FROM LEDGER L WHERE (VDT >= @CURRYRSTDATE + ' 00:00:00' AND VDT <=  @VDT + ' 23:59:59'   )          
and  VDT   <  'Nov 01 2011' + ' 00:00:00'          
--FROM LEDGER L WHERE VDT >= 'Apr  1 2011' + ' 00:00:00' AND VDT <=  'Nov 30 2011' + ' 23:59:59'                                
GROUP BY L.CLTCODE                              
       
       
        
IF  @VIEWOPTION = 'GL'            
BEGIN                            
 INSERT INTO #TEMPLEDGERFINAL SELECT L.*,LEFT(ACNAME,45) ACNAME, BRANCHCODE,ACCAT                             
 FROM #TEMPLEDGER L, sacmast_view A WHERE L.CLTCODE =A.CLTCODE   AND ACCAT <> 4 AND ( DRTOT <> 0  OR CRTOT <> 0 OR  AMOUNT <> 0)                            
              
 INSERT INTO #TEMPLEDGERFINAL                            
 SELECT A.bgrpcode,SUM(DRTOT),SUM(CRTOT),SUM(AMOUNT),A.bgrpname,' ',4                      
 FROM #TEMPLEDGER L, sacmast_view A                      
 WHERE L.CLTCODE =A.CLTCODE  AND ACCAT = 4  AND ( DRTOT <> 0  OR CRTOT <> 0 OR  AMOUNT <> 0)                     
 GROUP BY A.BGRPCODE,A.BGRPNAME having SUM(AMOUNT) <> 0                    
END        
ELSE IF  @VIEWOPTION = 'PARTYWISE'           
BEGIN        
 INSERT INTO #TEMPLEDGERFINAL SELECT L.*,LEFT(ACNAME,45) ACNAME, BRANCHCODE,ACCAT                             
 FROM #TEMPLEDGER L, sacmast_view A WHERE L.CLTCODE =A.CLTCODE         
 --AND A.CLTCODE >='A000' AND A.CLTCODE <='ZZZ9999'         
 and a.cltcode in (select party_Code from anand1.msajag.dbo.client_Details with (nolock) where isnumeric(substring(party_code,1,1))=0 )      
 AND ( DRTOT <> 0  OR CRTOT <> 0 OR  AMOUNT <> 0)                            
END        
ELSE        
BEGIN        
      
 INSERT INTO #TEMPLEDGERFINAL SELECT L.*,LEFT(ACNAME,45) ACNAME, BRANCHCODE,ACCAT                             
 FROM #TEMPLEDGER L, sacmast_view A WHERE L.CLTCODE =A.CLTCODE   AND ACCAT <> 4 AND ( DRTOT <> 0  OR CRTOT <> 0 OR  AMOUNT <> 0)                            
      
 INSERT INTO #TEMPLEDGERFINAL SELECT L.*,LEFT(ACNAME,45) ACNAME, BRANCHCODE,ACCAT                             
 FROM #TEMPLEDGER L, sacmast_view A WHERE L.CLTCODE =A.CLTCODE         
 --AND (A.CLTCODE >='A000' AND A.CLTCODE <='ZZZ9999')       
 and a.cltcode in (select party_Code from anand1.msajag.dbo.client_Details with (nolock) where isnumeric(substring(party_code,1,1))=0 )      
 AND ( DRTOT <> 0  OR CRTOT <> 0 OR  AMOUNT <> 0)                            
      
 INSERT INTO #TEMPLEDGERFINAL                            
 SELECT A.bgrpcode,SUM(DRTOT),SUM(CRTOT),SUM(AMOUNT),A.bgrpname,' ',4                      
 FROM #TEMPLEDGER L, sacmast_view A                      
 WHERE L.CLTCODE =A.CLTCODE  AND ACCAT = 4  AND ( DRTOT <> 0  OR CRTOT <> 0 OR  AMOUNT <> 0)                     
 --AND NOT (A.CLTCODE >='A000' AND A.CLTCODE <='ZZZ9999')         
 and not a.cltcode in (select party_Code from anand1.msajag.dbo.client_Details with (nolock) where isnumeric(substring(party_code,1,1))=0 )      
 GROUP BY A.BGRPCODE,A.BGRPNAME having SUM(AMOUNT) <> 0                    
      
 /*      
 INSERT INTO #TEMPLEDGERFINAL SELECT L.*,LEFT(ACNAME,45) ACNAME, BRANCHCODE,ACCAT                             
 FROM #TEMPLEDGER L, sacmast_view A WHERE L.CLTCODE =A.CLTCODE   AND ( DRTOT <> 0  OR CRTOT <> 0 OR  AMOUNT <> 0)                            
 */      
END             
      
delete from #TEMPLEDGERFINAL where abs(amount) <= 0.001       
  
      
/* add this line to change SB Name */                
Update #TEMPLEDGERFINAL set cltcode=b.new_cltcode,acname=left(b.sbname,45) from sebiinsp_sbnameswap b where #TEMPLEDGERFINAL.cltcode=b.cltcode                      
  
--delete from #TEMPLEDGERFINAL where CLTCODE IN (select gl_code from angelfo.accountfo.dbo.SEBIINSP_NTS with (nolock))  
    
select cltcode,drtot=sum(drtot),crtot=sum(crtot),amount=sum(amount),acname=max(acname),branchcode=max(branchcode),accat=max(Accat)     
into #TEMPLEDGERFINALx from #TEMPLEDGERFINAL  group by cltcode    
    
IF @FLAG = 'CODEWISE'                              
 BEGIN                            
  SELECT * FROM #TEMPLEDGERFINALx ORDER BY  CLTCODE, ACNAME, BRANCHCODE                            
 END                            
ELSE                            
 BEGIN                            
  SELECT * FROM #TEMPLEDGERFINALx ORDER BY  ACNAME,CLTCODE, BRANCHCODE                            
 END

GO
