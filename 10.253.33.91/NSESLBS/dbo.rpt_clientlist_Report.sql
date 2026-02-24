-- Object: PROCEDURE dbo.rpt_clientlist_Report
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--Exec rpt_clientlist_Report 'Apr  4 2008','Jun 11 2009','','broker','broker','','','BRANCH','','','%','a' 
CREATE Procedure  [dbo].[rpt_clientlist_Report]  
(                
 @fromdate as varchar(11),  
 @todate as varchar(11),  
 @order_by as varchar(16),  
 @statusid varchar(15),  
 @statusname varchar(25),  
 @FromParty varchar(10),  
 @ToParty varchar(10),  
 @FilterValue varchar(10),  
 @FromCode varchar(10),  
 @ToCode varchar(10),  
 @FieldInput Varchar(15),
 @cltstatus char(2)  
)  
AS  
  
Declare   
 @RegionCodeFrom varchar(10) ,  
 @RegionCodeTo varchar(10) ,  
 @AreaCodeFrom varchar(10) ,  
 @AreaCodeTo varchar(10) ,  
 @BranchFrom varchar(10) ,  
 @BranchTo varchar(10) ,  
 @SubBrokerFrom varchar(10) ,  
 @SubBrokerTo varchar(10) ,  
 @TraderFrom varchar(10) ,  
 @TraderTo varchar(10),  
 @SBUFrom varchar(10),  
 @SBUTo varchar(10),
 @ActInactDt varchar(10),
 @fldname varchar(20)   
  
Set @RegionCodeFrom =''  
Set @AreaCodeFrom =''  
Set @BranchFrom =''  
Set @SubBrokerFrom =''  
Set @TraderFrom =''  
Set @SBUFrom =''  
  
Set @RegionCodeTo =  'zzzzzzzzzzzz'  
Set @AreaCodeTo = 'zzzzzzzzzzzzz'  
Set @BranchTo = 'zzzzzzzzzzzzz'  
Set @SubBrokerTo = 'zzzzzzzzzzzzz'  
Set @TraderTo = 'zzzzzzzzzzzzz'  
Set @SBUTo = 'zzzzzzzzzzzzzz'  
  
if @filtervalue = 'REGION' AND @ToCode <> ''                  
 begin                  
  Set @RegionCodeFrom = @FromCode  
  Set @RegionCodeTo = @ToCode                 
 end                  
if @filtervalue = 'AREA'    AND @ToCode <> ''                   
 begin                  
  Set @AreaCodeFrom = @FromCode  
  Set @AreaCodeTo = @ToCode                 
 end   
if @filtervalue = 'SUBBROKER'  AND @ToCode <> ''                     
 begin                  
  Set @SubBrokerFrom = @FromCode  
  Set @SubBrokerTo = @ToCode                 
 end               
if @filtervalue = 'BRANCH'  AND @ToCode <> ''                     
 begin                  
  Set @BranchFrom = @FromCode  
  Set @BranchTo = @ToCode                 
 end              
if @filtervalue = 'TRADER'   AND @ToCode <> ''                    
 begin                  
  Set @TraderFrom = @FromCode  
  Set @TraderTo = @ToCode                 
 end           
  
if @filtervalue = 'SBU' AND @ToCode <> ''                    
 begin                  
  Set @SBUFrom = @FromCode  
  Set @SBUTo = @ToCode                 
 end           
          
If @ToParty = ''                  
Begin                  
 set @ToParty = 'zzzzzzzzzzzzz'                  
End  

if @cltstatus = 'A'
 begin 
  set @fldname  = 'Activefrom'
 end 

if @cltstatus = 'IN'
 begin 
  set @fldname  = 'Inactivefrom'
 end 

                   
set transaction isolation level read uncommitted                  
    
SELECT     
  
OrderBy = (      
    CASE       
        WHEN @order_by = 'Branch'       
        THEN c1.branch_cd       
        ELSE       
        CASE       
            WHEN @order_by = 'SubBroker'       
            THEN c1.sub_broker       
            ELSE       
            CASE       
                WHEN @order_by = 'PartyCode'       
                THEN c2.party_code       
                ELSE       
                CASE       
                    WHEN @order_by = 'Client'       
                    THEN c1.short_name       
                    ELSE       
                    CASE       
                        WHEN @order_by = 'Family'       
                        THEN c1.family       
                        ELSE       
                        CASE       
                            WHEN @order_by = 'Active'       
                            THEN convert(varchar(11),ActiveFrom)       
                            ELSE       
                            CASE       
                                WHEN @order_by = 'InActive'       
                                THEN convert(varchar(11),InactiveFrom)       
                            END       
                        END       
                    END       
                END       
            END       
        END       
    END       
    )    ,  
    c1.short_name,     
    c1.long_name,     
    isnull(c1.res_phone1,'-') AS res_phone1,     
    isnull(c1.off_phone1,'-') AS off_phone1,     
    c1.cl_code,     
    isnull(c1.email,'-') AS email,     
    isnull(c1.branch_cd,'-') AS branch_cd,     
    isnull(c1.family,'-') AS family,     
    isnull(c1.sub_broker,'-') AS sub_broker,     
	isnull(c1.trader,'-') AS trader,     
    c2.party_code,     
    c2.turnover_tax,     
    c2.sebi_turn_tax,     
    insurance_chrg,    
    brokernote,     
    other_chrg,     
    isnull(c3.branch,'-') AS branch,     
    c4.short_name AS trader_name,     
    c5.name,    
    c5.com_perc,     
	isnull(c1.pan_gir_no,'-') AS pan_gir_no,     
    isnull(convert(varchar(11),ActiveFrom),'-') AS ActiveFrom,     
    isnull(convert(varchar(11),InactiveFrom),'-') AS InactiveFrom,     
    Introducer = isnull(CL5.Introducer,'-'),     
    Approver = isnull(CL5.Approver,'-'),     
    isnull(C1.L_Address1,'-') AS L_Address1,     
    isnull(C1.L_Address2,'-') AS L_Address2,     
    Isnull(CL41.CltDpID,'-') AS AccNo,     
    isnull(POBankcode,'-') AS pobankcode,     
    isnull(POBankName,'-') AS pobankname,     
    isnull(PayMode,'-') AS PayMode,     
    BankID = IsNull(CL4.bankID,'-'),     
    ClientDPID=IsNull(CL4.CltDpID,'-'),     
    isnull(C1.L_Address3,'-') AS l_address3,     
    isnull(C1.L_City,'-') AS l_city,     
    isnull(C1.L_State,'-') AS l_state,     
    isnull(C1.L_Nation,'-') AS l_nation,     
    isnull(C1.L_Zip,'-') AS l_zip,     
    isnull(C1.Fax,'-') AS fax,     
    isnull(C1.Mobile_Pager,'-') AS mobile_pager,     
    CLBankID=isnull(CL41.BankID,'-'),     
    BankName = IsNull(B.Bank_Name,'-')     
FROM CLIENT1 C1 (nolock),     
    ( select * from Client5 (nolock)  where case when @cltstatus = '%' then activefrom else case when @cltstatus = 'A' then activefrom else inactivefrom end end Between   
    @fromdate 
	 and @todate + ' 23:59'

	OR
 case when @cltstatus = '%' then inactivefrom else case when @cltstatus = 'A' then activefrom else inactivefrom end end Between   
    @fromdate 
	 and @todate + ' 23:59'
			 ) CL5 ,   
    client2 c2 (nolock)     
LEFT OUTER JOIN     
    Client4 CL4     
    ON     
    (     
        CL4.Party_Code = C2.party_Code     
        AND CL4.DefDP = 1     
        AND CL4.depository in ('CDSL','NSDL')    
    )     
LEFT OUTER JOIN     
    Client4 CL41     
    ON     
    (     
        CL41.Cl_Code = C2.Cl_Code     
        AND CL41.depository not in ('CDSL','NSDL')    
    )     
LEFT OUTER JOIN     
    POBank B     
    ON     
    (    
        Convert(Varchar,B.BankID)=CL41.Bankid    
    )    
    ,     
    branch c3 (nolock),     
    branches c4 (nolock),     
    subbrokers c5 (nolock),     
    account.dbo.acmast AM (nolock)    
WHERE c1.cl_code=c2.cl_code     
    AND c1.branch_cd=c3.branch_code     
    AND c1.trader=c4.short_name     
    AND c1.sub_broker=c5.sub_broker     
    AND c3.branch_code=c4.branch_cd     
    AND c2.party_code >= @FromParty     
    AND c2.party_code <= @ToParty  
    AND AM.CltCode = C2.Party_code     
    AND CL5.Cl_Code = C1.Cl_Code     
    AND CL5.SystumDate Between   
    CASE   
 When Len(@fromdate) > 1  
 Then @fromdate Else 'Jan  1 1900'   
 End  
    AND  
    CASE   
 When Len(@todate) > 1  
 Then @todate + ' 23:59' Else 'Dec 31 2049 23:59'   
        End  
    AND @STATUSNAME = (     
        CASE     
                WHEN @STATUSID = 'BRANCH'     
                THEN C1.BRANCH_CD     
                WHEN @STATUSID = 'SUBBROKER'     
                THEN C1.SUB_BROKER     
                WHEN @STATUSID = 'TRADER'     
                THEN C1.TRADER     
                WHEN @STATUSID = 'FAMILY'     
                THEN C1.FAMILY     
                WHEN @STATUSID = 'AREA'     
                THEN C1.AREA     
                WHEN @STATUSID = 'REGION'     
                THEN C1.REGION     
                WHEN @STATUSID = 'CLIENT'     
           THEN C2.PARTY_CODE     
                ELSE 'BROKER' END)   
 AND  C1.region between @RegionCodeFrom and @RegionCodeTo  
 AND  C1.Area between @AreaCodeFrom and @AreaCodeTo  
 AND  C1.branch_cd between @BranchFrom and @BranchTo  
 AND  C1.sub_broker between @SubBrokerFrom and @SubBrokerTo  
 AND  C1.Trader between @TraderFrom and @TraderTo  
 AND  C2.DUMMY8 Between @SBUFrom And @SBUTo  
 AND  1 = (Case   
	When upper(@FieldInput) = 'MAIL' Then (Case When C1.EMail = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'PAN' Then (Case When C1.Pan_Gir_No = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'BANKNAME' Then (Case When b.Bank_Name = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'BRANCH' Then (Case When b.Branch_Name = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'TELR' Then (Case When C1.res_Phone1 = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'TELO' Then (Case When C1.off_Phone1 = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'MOBILE' Then (Case When C1.Mobile_pager = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'FAX' Then (Case When C1.Fax = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'ACCNO' Then (Case When CL41.CltDpID = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'DDPID' Then (Case When CL4.CltDpID = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'BDPID' Then (Case When CL4.bankID = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'ADD1' Then (Case When C1.L_Address1 = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'ADD2' Then (Case When C1.L_Address2 = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'ADD3' Then (Case When C1.L_Address3 = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'CITY' Then (Case When C1.L_City = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'STATE' Then (Case When C1.L_State = '' Then 1 Else 2 End)
	When upper(@FieldInput) = 'ZIP' Then (Case When C1.L_zip = '' Then 1 Else 2 End)
   Else 1  
  End)  
  
Order By 1  

--select top 100 * from client1

GO
