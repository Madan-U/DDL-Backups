-- Object: FUNCTION citrus_usr.fn_dp57_stuff
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_dp57_stuff](@pa_action varchar(100)        
,@pa_para1 varchar(1000)        
,@pa_para2 varchar(1000)        
,@pa_para3 varchar(1000)       
--,@pa_para4 varchar(1000)     
--,@pa_para5 varchar(1000)    
--,@pa_para6 varchar(1000)    
)        
returns varchar(1000)        
as         
begin         
        
declare @l_ret_value varchar(1000)        
        
if @pa_action = 'desc'        
begin         
        
set @l_ret_value  = case when @pa_para1 = '1' then 'BO OBLIGATION CONFIRMATION'        
      when @pa_para1 = '2' then  'TXN WITHIN SAME CDSL DP (BO TO BO)'        
      when @pa_para1 = '3' then  'TXN WITHIN DIFFERENT CDSL DPS (BO TO BO)'        
      when @pa_para1 = '4' then  'EARLY PAY-IN'        
      when @pa_para1 = '5' then  'TRANSACTION OUTSIDE CDSL (BO TO BO)'        
      when @pa_para1 = '6' then  'DEMAT'        
      when @pa_para1 = '7' then  'REMAT'        
      when @pa_para1 = '8' then  'PLEDGE'        
      when @pa_para1 = '9' then  'UNPLEDGE'        
      when @pa_para1 = '10' then 'AUTO PLEDGE'        
      when @pa_para1 = '11' then 'CONFISCATE'        
      when @pa_para1 = '12' then 'FREEZE / UNFREEZE'        
      when @pa_para1 = '14' then 'BSE PAY-OUT'        
      when @pa_para1 = '15' then 'NSE PAY-IN'        
      when @pa_para1 = '16' then 'NSE PAYOUT'        
      when @pa_para1 = '17' then 'TRANSMISSION ONE-TO-MANY'        
      when @pa_para1 = '18' then 'TRANSMISSION – ONE TO ONE'        
      when @pa_para1 = '20' then 'IPO'        
      when @pa_para1 = '21' then 'FILE CA'        
      when @pa_para1 = '22' then 'AUTO CA'        
      when @pa_para1 = '23' then 'LOCK IN RELEASE'        
      when @pa_para1 = '24' then 'CH ESCROW RELEASE'        
      when @pa_para1 = '25' then ''        
      when @pa_para1 = '26' then 'NSE-SLB PAY-IN'        
      when @pa_para1 = '27' then 'NSE SLB PAYOUT'        
      when @pa_para1 = '28' then 'BSE 2ND STAGE PAYOUT'        
      when @pa_para1 = '29' then 'WITHHELD RELEASE'        
      when @pa_para1 = '30' then 'PAY-IN FROM BO'        
      when @pa_para1 = '31' then 'CISA TRANSFER'                                        
      end         
        
        
end         
if @pa_action = 'settmid'        
begin         
        
select @l_ret_value = convert(varchar(25),settm_id) from  settlement_type_mstr where SETTM_TYPE_CDSL =  @pa_para1 and settm_deleted_ind = 1        
        
        
end         
if @pa_action = 'excmid'        
begin         
        
select @l_ret_value = isnull (convert(varchar(25),SETTM_EXCM_ID),'') from  settlement_type_mstr where SETTM_TYPE_CDSL =  @pa_para1 and settm_deleted_ind = 1        
        
        
end        
ELSE if @pa_action = 'TRANS_CD'        
begin         
        
  set @l_ret_value  = case when @pa_para1 = '1' then 'Normal payin'--'BO OBLIGATION CONFIRMATION'        
           
      when @pa_para1 = '2' AND  @pa_para2 = 'B' and @pa_para3 = '' then  'OF-CR'-- 'TXN WITHIN SAME CDSL DP (BO TO BO)'          
      when @pa_para1 = '2' AND  @pa_para2 = 'S' and @pa_para3 = '' then  'OF-DR'-- 'TXN WITHIN SAME CDSL DP (BO TO BO)'          
      when @pa_para1 = '3' AND  @pa_para2 = 'B' and @pa_para3 = '' then  'OF-CR'--'TXN WITHIN DIFFERENT CDSL DPS (BO TO BO)'          
      when @pa_para1 = '3' AND  @pa_para2 = 'S' and @pa_para3 = '' then  'OF-DR'--'TXN WITHIN DIFFERENT CDSL DPS (BO TO BO)'          
            
      when @pa_para1 = '2' AND  @pa_para2 = 'B' and @pa_para3 <> '' then  'ON-CR'-- 'TXN WITHIN SAME CDSL DP (BO TO BO)'          
      when @pa_para1 = '2' AND  @pa_para2 = 'S' and @pa_para3 <> '' then  'ON-DR'-- 'TXN WITHIN SAME CDSL DP (BO TO BO)'          
      when @pa_para1 = '3' AND  @pa_para2 = 'B' and @pa_para3 <> '' then  'ON-CR'--'TXN WITHIN DIFFERENT CDSL DPS (BO TO BO)'          
      when @pa_para1 = '3' AND  @pa_para2 = 'S' and @pa_para3 <> '' then  'ON-DR'--'TXN WITHIN DIFFERENT CDSL DPS (BO TO BO)'          
           
           
      when @pa_para1 = '4' AND  @pa_para2 = 'B' then  'EP-CR'--'EARLY PAY-IN'        
      when @pa_para1 = '4' AND  @pa_para2 = 'S' then  'EP-DR'--'EARLY PAY-IN'        
      when @pa_para1 = '5' AND  @pa_para2 = 'B' then   'INTDEP-CR'-- 'TRANSACTION OUTSIDE CDSL (BO TO BO)'        
      when @pa_para1 = '5' AND  @pa_para2 = 'S' THEN   'INTDEP-DR'-- 'TRANSACTION OUTSIDE CDSL (BO TO BO)'        
      when @pa_para1 = '6' then  'DEMAT'         
      when @pa_para1 = '7' then  'REMAT'        
      when @pa_para1 = '8' then  'PLEDGE'        
      when @pa_para1 = '9' then  'UNPLEDGE'        
      when @pa_para1 = '10' then 'AUTO PLEDGE'        
      when @pa_para1 = '11' then 'CONFISCATE'        
      when @pa_para1 = '12' then 'FREEZE / UNFREEZE'        
      when @pa_para1 = '14' then 'BSECH-CR'        
      when @pa_para1 = '15' then 'NSCCL-CR'        
      when @pa_para1 = '16' then 'NSCCL-DR'        
      when @pa_para1 = '17' then 'TRANSMISSION'        
      when @pa_para1 = '18' then 'TRANSMISSION'        
      when @pa_para1 = '20' then 'INITIALPUBLIC OFFERING'        
      when @pa_para1 = '21' then 'FILE CA'        
      when @pa_para1 = '22' then 'AUTO CA'        
      when @pa_para1 = '23' then 'LOCK IN RELEASE'        
      when @pa_para1 = '24' then 'CH ESCROW RELEASE'        
      when @pa_para1 = '26' then 'NSE-SLB PAY-IN'        
      when @pa_para1 = '27' then 'NSE SLB PAYOUT'        
      when @pa_para1 = '28' then 'BSE 2ND STAGE PAYOUT'        
      when @pa_para1 = '29' then 'WITHHELD RELEASE'        
      when @pa_para1 = '30' then 'PAY-IN FROM BO'        
      when @pa_para1 = '31' then 'CISA TRANSFER'                                        
  when @pa_para1 = '32' then 'DEMAT'              
  when @pa_para1 = '33' then 'REMAT'              
        
      end         
        
        
        
END        
    
      
else if @pa_action = 'maindesc'        
begin         
        
set @l_ret_value  =  case when  @pa_para1 = 101 then 'BO OBLIGATON CONFIRMATION SET UP'        
when  @pa_para1 = 101 then 'AUTO PAY-IN SETUP'        
when  @pa_para1 = 102 then 'EARMARKED'        
when  @pa_para1 = 103 then 'FAILED FOR PAY-IN'        
when  @pa_para1 = 105 then 'PARTIALLY TRANSFERRED TO CM'        
when  @pa_para1 = 107 then 'SUCCESSFUL BO DEBIT'        
when  @pa_para1 = 109 then 'CLOSED AND SETTLED'        
when  @pa_para1 = 110 then 'DELETED'        
when  @pa_para1 = 111 then 'REVERSE EARMARKED DUE TO PAY-OUT'        
when  @pa_para1 = 301 then 'SETUP'        
when  @pa_para1 = 302 then 'SETUP (SYSTEM GENERATED)'        
when  @pa_para1 = 303 then 'OVERDUE'        
when  @pa_para1 = 304 then 'DELETE'        
when  @pa_para1 = 305 then 'CLOSED AND SETTLED'        
when  @pa_para1 = 306 then 'PENDING'        
when  @pa_para1 = 307 then 'FAILED (CANCELLED IN EOD)'        
when  @pa_para1 = 308 then 'TRADE CANCELLED BY BUYER'        
when  @pa_para1 = 309 then 'TRADE CANCELLED BY SELLER'        
when  @pa_para1 = 310 then 'CLEARING HOUSE MUTUAL FUND FAILED BUY TXN'        
when  @pa_para1 = 401 then 'SETUP'        
when  @pa_para1 = 402 then 'EARMARKED (CH DP)'        
when  @pa_para1 = 403 then 'FAILED FOR PAY-IN (CH DP)'        
when  @pa_para1 = 408 then 'CLOSED AND SETTLED IN PAY-IN (CH DP)'        
when  @pa_para1 = 409 then 'DEBIT / CREDIT SUCCESS'        
when  @pa_para1 = 411 then 'REVERSE EARMARKED OF EARLY PAY-IN (CH DP)'        
when  @pa_para1 = 511 then 'CLOSE AND PROCESSED'        
when  @pa_para1 = 512 then 'CLOSE AND UNPROCESSED'        
when  @pa_para1 = 520 then 'TO BE VERIFIED'        
when  @pa_para1 = 521 then 'CONFIRMED BY OTHER DEPOSITORY'        
when  @pa_para1 = 523 then 'REJECTED BY OTHER DEPOSITORY'        
when  @pa_para1 = 525 then 'PENDING'        
when  @pa_para1 = 528 then 'EARMARK SUCCESSFUL'        
when  @pa_para1 = 529 then 'EARMARK FAILED'        
when  @pa_para1 = 533 then 'RECONCILED'        
when  @pa_para1 = 536 then 'ACK GENERATED'        
when  @pa_para1 = 537 then 'REVERSE EARMARK'        
when  @pa_para1 = 601 then 'SETUP'        
when  @pa_para1 = 602 then 'VERIFIED (DEBIT DEMAT PENDING VERIFICATION)'        
when  @pa_para1 = 603 then 'VERIFIED (CREDIT DEMAT PENDING CONFORMATION)'        
when  @pa_para1 = 604 then 'CONFIRMED (DEBIT DEMAT PENDING CONFIRMATION)'        
when  @pa_para1 = 605 then 'CONFIRMED (CREDIT CURRENT BALANCE)'        
when  @pa_para1 = 606 then 'CONFIRMED (CREDIT LOCK IN BALANCE, DEMAT SET UP FOR LOCK IN SHARES)'        
when  @pa_para1 = 607 then 'DELETED'        
when  @pa_para1 = 608 then 'REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)'        
when  @pa_para1 = 609 then 'CANCELLED DUE TO AUTO CA (DEBIT DEMAT PENDING VERIFICATION)'        
when  @pa_para1 = 610 then 'CANCELLED DUE TO AUTO CA (DEBIT DEMAT PENDING CONFIRMATION)'        
when  @pa_para1 = 701 then 'SETUP'        
when  @pa_para1 = 702 then 'RECEIVED'        
when  @pa_para1 = 703 then 'REJECTED WITHOUT RECEIVING'       
when  @pa_para1 = 704 then 'PENDING WITH RTA'        
when  @pa_para1 = 705 then 'PARTIAL REMAT'        
when  @pa_para1 = 706 then 'REMAT CANCELLED DUE TO AUTO CA'        
when  @pa_para1 = 707 then 'CLOSED (PARTIAL QUANTITY)'        
when  @pa_para1 = 709 then 'DELETED'        
when  @pa_para1 = 801 then 'SETUP INITIATED BY PLEDGOR MAKER'        
when  @pa_para1 = 802 then 'SETUP APPROVED BY PLEDGOR CHECKER'        
when  @pa_para1 = 804 then 'SETUP CANCELLED BY PLEDGOR'        
when  @pa_para1 = 805 then 'SETUP ACCEPTED BY PLEDGEE MAKER'        
when  @pa_para1 = 806 then 'SETUP REJECTED BY PLEDGEE MAKER'        
when  @pa_para1 = 807 then 'SETUP REJECTED BY PLEDGEE CHECKER'        
when  @pa_para1 = 809 then 'SETUP ACCEPTED BY PLEDGEE CHECKER (CREDIT PLEDGE BALANCE PLEDGOR)'        
when  @pa_para1 = 810 then 'SETUP ACCEPTED BY PLEDGEE CHECKER (DEBIT LOCKIN BALANCE)'        
when  @pa_para1 = 811 then 'REVERSAL BY PLEDGEE'        
when  @pa_para1 = 812 then 'CANCELLED DUE TO AUTO CA'        
when  @pa_para1 = 813 then 'TRANSFERRED DUE TO AUTO CA (DEBIT PLEDGE BALANCE)'        
when  @pa_para1 = 814 then 'CLOSED DUE TO AUTO CA (DEBIT PLEDGE BALANCE)'        
when  @pa_para1 = 901 then 'SETUP INITIATED BY PLEDGOR MAKER'        
when  @pa_para1 = 902 then 'SETUP APPROVED BY PLEDGOR CHECKER'        
when  @pa_para1 = 903 then 'SETUP CANCELLED BY PLEDGOR'        
when  @pa_para1 = 904 then 'SETUP ACCEPTED BY PLEDGEE MAKER'        
when  @pa_para1 = 905 then 'SETUP ACCEPTED BY PLEDGEE CHECKER (DEBIT PLEDGE BALANCE - PLEDGOR)'        
when  @pa_para1 = 905 then 'SETUP APPROVED BY PLEDGEE CHECKER (CREDIT LOCKIN BALANCE)'        
when  @pa_para1 = 906 then 'SETUP REJECTED BY PLEDGEE MAKER'        
when  @pa_para1 = 907 then 'SETUP REJECTED BY PLEDGEE CHECKER'        
when  @pa_para1 = 908 then 'REVERSAL BY PLEDGEE'        
when  @pa_para1 = 909 then 'CANCELLED DUE TO AUTO CA'        
when  @pa_para1 = 1001 then  'AUTO UNPLEDGE MAKER'        
when  @pa_para1 = 1002 then  'AUTO UNPLEDGE CHECKER (DEBIT PLEDGE BALANCE PLEDGOR)'        
when  @pa_para1 = 1002 then  'AUTO UNPLEDGE CHECKER (IF LOCK IN FLAG = L,CREDIT LOCK IN BALANCE)'        
when  @pa_para1 = 1003 then  'AUTO UNPLEDGE REVERSAL'        
when  @pa_para1 = 1004 then  'CANCELLED DUE TO AUTO CA'        
when  @pa_para1 = 1101 then  'SETUP INITIATED BY PLEDGEE MAKER'        
when  @pa_para1 = 1102 then  'SETUP APPROVED BY PLEDGEE CHECKER (DEBIT PLEDGE BALANCE PLEDGOR)'        
when  @pa_para1 = 1103 then  'SETUP APPROVED BY PLEDGEE CHECKER (DEBIT CURRENT BALANCE PLEDGOR)'        
when  @pa_para1 = 1104 then  'SETUP APPROVED BY PLEDGEE CHECKER (CREDIT CURRENT BALANCE PLEDGEE)'        
when  @pa_para1 = 1105 then  'REVERSAL BY PLEDGEE'        
when  @pa_para1 = 1106 then  'CANCELLED DUE TO AUTO CA'        
when  @pa_para1 = 1201 then  'FREEZE SETUP'        
when  @pa_para1 = 1203 then  'UNFREEZE'        
when  @pa_para1 = 1204 then  'FREEZE CANCEL'        
when  @pa_para1 = 1205 then  'FREEZE ACTIVATED AT SOD'        
when  @pa_para1 = 1206 then  'FREEZE EXPIRED AT EOD'        
when  @pa_para1 = 1207 then  'CANCELLED DUE TO AUTO CA'        
when  @pa_para1 = 1208 then  'TRANSFERRED DUE TO AUTO CA'        
when  @pa_para1 = 1209 then  'CLOSED DUE TO AUTO CA'        
when  @pa_para1 = 1401 then  'PAYOUT RECEIVED'        
when  @pa_para1 = 1402 then  'PAYOUT FAILED'        
when  @pa_para1 = 1503 then  'DEBIT CREDIT SUCCESS (PAY-IN)'        
when  @pa_para1 = 1504 then  'DEBIT ERROR (PAY-IN)'        
when  @pa_para1 = 1505 then  'CREDIT ERROR (PAY-IN)'        
when  @pa_para1 = 1506 then  'PROC ERROR (PAY-IN)'        
when  @pa_para1 = 1603 then  'DEBIT CREDIT SUCCESS'        
when  @pa_para1 = 1604 then  'DEBIT ERROR'        
when  @pa_para1 = 1605 then  'CREDIT ERROR'        
when  @pa_para1 = 1606 then  'PROCESSING ERROR'        
when  @pa_para1 = 1701 then  'CURRENT BALANCE DEBIT'        
when  @pa_para1 = 1702 then  'CURRENT BALANCE CREDIT'        
when  @pa_para1 = 1801 then  'CURRENT BALANCE DEBIT'        
when  @pa_para1 = 1802 then  'CURRENT BALANCE CREDIT'        
when  @pa_para1 = 2001 then  'IPO CURRENT BALANCE CREDIT'        
when  @pa_para1 = 2002 then  'IPO LOCK IN BALANCE CREDIT'        
when  @pa_para1 = 2101 then  'CA CURRENT BALANCE DEBIT'        
when  @pa_para1 = 2102 then  'CA LOCK IN BALANCE DEBIT'        
when  @pa_para1 = 2103 then  'CA CURRENT BALANCE CREDIT'        
when  @pa_para1 = 2104 then  'CA LOCK IN BALANCE CREDIT'        
when  @pa_para1 = 2201 then  'AUTO CA CURRENT BALANCE DEBIT'        
when  @pa_para1 = 2202 then  'AUTO CA CURRENT BALANCE CREDIT'        
when  @pa_para1 = 2203 then  'LOCK IN TRANSFERRED DUE TO AUTO CA'        
when  @pa_para1 = 2204 then  'AUTO CA LOCK IN BALANCE CREDIT'        
when  @pa_para1 = 2205 then  'LOCK IN CLOSED DUE TO AUTO CA'        
when  @pa_para1 = 2301 then  'LOCK IN RELEASE FOR PLEDGE ON FULL QUANTITY'        
when  @pa_para1 = 2302 then  'LOCK IN RELEASE FULL FOR NO PLEDGE NO REMAT /PARTIAL QUANTITY IN PLEDGE'        
when  @pa_para1 = 2303 then  'LOCK IN RELEASE PARTIAL FOR REMAT SETUP ON PARTIAL QUANTITY'        
when  @pa_para1 = 2401 then  'ESCROW RELEASE PENDING'        
when  @pa_para1 = 2402 then  'ESCROW RELEASE DONE'        
when  @pa_para1 = 2603 then  'DEBIT CREDIT SUCCESS (PAY-IN)'        
when  @pa_para1 = 2604 then  'DEBIT ERROR (PAY-IN)'        
when  @pa_para1 = 2605 then  'CREDIT ERROR (PAY-IN)'        
when  @pa_para1 = 2606 then  'PROCESSING ERROR (PAY-IN)'        
when  @pa_para1 = 2609 then  'SUCCESS FOR CM CREDIT'        
when  @pa_para1 = 2703 then  'DEBIT CREDIT SUCCESS'        
when  @pa_para1 = 2704 then  'DEBIT ERROR'        
when  @pa_para1 = 2705 then  'CREDIT ERROR'        
when  @pa_para1 = 2706 then  'PROCESSING ERROR'        
when  @pa_para1 = 2803 then  'DEBIT CREDIT SUCCESS'        
when  @pa_para1 = 2804 then  'DEBIT ERROR'        
when  @pa_para1 = 2805 then  'CREDIT ERROR'        
when  @pa_para1 = 2806 then  'PROCESSING ERROR'        
when  @pa_para1 = 2903 then  'DEBIT / CREDIT SUCCESSFUL'        
when  @pa_para1 = 2904 then  'ERROR WHILE DEBIT'        
when  @pa_para1 = 2905 then  'ERROR WHILE CREDIT'        
when  @pa_para1 = 2906 then  'ERROR WHILE PROCESSING'        
when  @pa_para1 = 3001 then  'CM CREDIT RECEIVED'        
when  @pa_para1 = 3101 then  'SUCCESSFUL DEBIT / CREDIT'    

when  @pa_para1 = 3207 then  'CONFIRMED (CREDIT CURRENT BALANCE)'    
end                                                                                              
        
        
end         
else if @pa_action = 'CRDR'        
begin         
        
set @l_ret_value  = case when @pa_para1 = '2246' then 'CR' -- CONFIRM (CREDIT CURRENT BALANCE – 605) - CR        
   when @pa_para1 = '2277' then 'DR' -- CONFIRMED BY RTA (DEBIT CURRENT BALANCE – 705) - DR         
   when @pa_para1 = '2201' then 'CR' -- SETUP (CREDIT DEMAT PENDING VERIFICATION – 601) - CR        
   when @pa_para1 = '2202' then 'CR'-- VERIFY (CREDIT DEMAT PENDING CONFIRMATION – 603) - CR        
   when @pa_para1 = '2212' then 'CR'-- CONFIRM, IF LOCK IN FLAG = 'Y' (CREDIT LOCK IN BALANCE – 606) - CR        
   when @pa_para1 = '2251' then 'DR'-- DELETE (DEBIT DEMAT PENDING VERIFICATION – 607) - DR        
   when @pa_para1 = '2252' then 'DR'-- CONFIRM (DEBIT DEMAT PENDING CONFIRMATION – 604) - DR        
   when @pa_para1 = '2205' then 'CR'-- SETUP (701) - CR        
   when @pa_para1 = '2255' then 'CR' -- CONFIRMED BY RTA (DEBIT REMAT PENDING CONFIRMATION BALANCE – 705) - CR        
   when @pa_para1 = '2230' then 'CR'-- SETUP ACCEPTED BY PLEDGEE CHECKER (CREDIT PLEDGE BALANCE – PLEDGOR – 809) - CR        
   when @pa_para1 = '2262' then 'DR'-- SETUP ACCEPTED BY PLEDGEE CHECKER (IF LOCKIN FLAG = Y DEBIT LOCKIN BALANCE – 810) -DR        
   when @pa_para1 = '2280'then 'DR' -- TRANSFERRED DUE TO AUTO CA (DEBIT PLEDGE BALANCE – 813) - DR        
   when @pa_para1 = '2212'then 'CR' -- SETUP ACCEPTED BY PLEDGEE CHECKER (IF LOCKIN FLAG = L, CREDIT LOCKIN BALANCE) - CR        
   when @pa_para1 = '2280'then 'DR' -- SETUP APPROVED BY PLEDGEE CHECKER (DEBIT PLEDGE BALANCE – PLEDGOR – 1102) - DR        
   when @pa_para1 = '2211' then 'CR'-- FREEZE SETUP (IF BO-ISIN LEVEL AND PARTIAL FREEZE,CREDIT SAFE KEEP BALANCE – 1201) - CR        
   when @pa_para1 = '2261' then 'DR'-- UNFREEZE (IF BO-ISIN LEVEL AND PARTIAL FREEZE, DEBIT SAFE KEEP BALANCE – 1203)- DR        
   when @pa_para1 = '2277' then 'DR'-- CURRENT BALANCE DEBIT (1801) - DR        
   when @pa_para1 = '2212' then 'CR'-- IPO LOCK IN BALANCE CREDIT (2002) - CR        
   when @pa_para1 = '2262' then 'DR'-- CA LOCK IN BALANCE DEBIT (2102) - DR        
   when @pa_para1 = '2215' then 'CR'-- CA LOCK IN BALANCE DEBIT (2102) - DR        
   when @pa_para1 = '2265' then 'DR'-- CA LOCK IN BALANCE DEBIT (2102) - DR        
   when @pa_para1 = '2270' then 'CR'-- pledge reject  
 when @pa_para1 = '2225' then 'CR' -- pledge new added on 21 m,ar 2013  
 when @pa_para1 = '4456' then 'CR' 
end         
        
end        
        
        
        
        
return  @l_ret_value        
        
end

GO
