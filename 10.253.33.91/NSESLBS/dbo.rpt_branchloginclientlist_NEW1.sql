-- Object: PROCEDURE dbo.rpt_branchloginclientlist_NEW1
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Procedure  rpt_branchloginclientlist_NEW1               
@fromdate as varchar(11),
@todate as varchar(11),
@order_by as varchar(80),
@statusid varchar(15),
@statusname varchar(25),
@FilterValue varchar(10),
@FromParty varchar(15),
@ToParty varchar(15)

AS

Declare @BranchCode varchar(15)                

if isnull(@filtervalue,'') = ''                 
begin                
 select @BranchCode = '%'                
end                
else                
begin                
 select @BranchCode = @FilterValue                
end                
                
If @FromParty = ''                
Begin                
 set @FromParty ='00000000'                
End                
                
If @ToParty = ''                
Begin                
 set @ToParty = 'ZZZZZZZZ'                
End                
                 
set transaction isolation level read uncommitted                
  
SELECT   
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
FROM CLIENT1 C1,   
    Client5 CL5,
    /*ON   
    (   
        CL5.Cl_Code = C1.Cl_Code   
	AND CL5.SystumDate Between 
	   Case 
	   When Len(@fromdate) > 1
	   Then @fromdate Else 'Jan  1 1900' 
	   End
	AND
	   Case 
	   When Len(@todate) > 1
	   Then @todate + ' 23:59' Else 'Dec 31 2049 23:59' 
           End
    )*/  
    client2 c2   
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
    branch c3,   
    branches c4,   
    subbrokers c5,   
    account.dbo.acmast AM   
WHERE c1.cl_code=c2.cl_code   
    AND c1.branch_cd=c3.branch_code   
    AND c1.trader=c4.short_name   
    AND c1.sub_broker=c5.sub_broker   
    AND c3.branch_code=c4.branch_cd   
    AND c3.branch_code like @BranchCode   
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
    AND C1.Branch_cd Like (  
    CASE   
        WHEN @StatusId = 'branch'   
        THEN @statusname   
        ELSE '%'   
    END  
    )   
    AND C1.Sub_broker Like (  
    CASE   
        WHEN @StatusId = 'subbroker'   
        THEN @statusname   
        ELSE '%'   
    END  
    )   
    AND Trader Like (  
    CASE   
        WHEN @StatusId = 'trader'   
        THEN @statusname   
        ELSE '%'   
    END  
    )   
    AND Family Like (  
    CASE   
        WHEN @StatusId = 'family'   
        THEN @statusname   
        ELSE '%'   
    END  
    )   
    AND C2.Party_Code Like (  
    CASE   
        WHEN @StatusId = 'client'   
        THEN @statusname   
        ELSE '%'   
    END  
    )                              
                
 ORDER BY (    
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
    )

GO
