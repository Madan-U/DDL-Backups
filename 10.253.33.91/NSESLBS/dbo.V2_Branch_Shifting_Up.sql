-- Object: PROCEDURE dbo.V2_Branch_Shifting_Up
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


Create Procedure V2_Branch_Shifting_Up 
(
        @from_party_code varchar(10), 
        @to_party_code varchar(10), 
        @branch_cd varchar(10), 
        @new_branch_cd varchar(10), 
        @new_trader varchar(20), 
        @new_sub_broker varchar(10)
)

As

/*=================================================================================
        Exec V2_Branch_Shifting_Up 
                @from_party_code = '0', 
                @to_party_code = '0', 
                @branch_cd  = '0', 
                @new_branch_cd  = '0', 
                @new_trader  = '0', 
                @new_sub_broker  = '0'
=================================================================================*/

Set NoCount On

Declare 
        @@nsecmcostcode smallint, 
        @@bsecmcostcode smallint, 
        @@nsefocostcode smallint, 
        @@cnt int, 
        @@update_date datetime, 
        @@sno int 

/*=================================================================================
        Start Basic Validations of the Input Parameters
=================================================================================*/

set @@cnt = 0
set @@sno = 0
set @@update_date = getdate() 
set @@nsecmcostcode = 0
set @@bsecmcostcode = 0
set @@nsefocostcode = 0

        Select @@sno = isnull(max(sno),0) + 1 from pradnya..V2_Branch_Shifting_Summary_Log 

        Select @@nsecmcostcode = costcode from account..costmast where costname = @new_branch_cd

        if @@nsecmcostcode = 0
        begin
                Select Error_Message = 'Cost Code not created for New Branch Code in NSECM'
                Return
        end

        Select @@bsecmcostcode = costcode from accountbse..costmast where costname = @new_branch_cd

        if @@bsecmcostcode = 0
        begin
                Select Error_Message = 'Cost Code not created for New Branch Code in BSECM'
                Return
        end

        Select @@nsefocostcode = costcode from accountfo..costmast where costname = @new_branch_cd

        if @@nsefocostcode = 0
        begin
                Select Error_Message = 'Cost Code not created for New Branch Code in NSEFO'
                Return
        end

        Select C2.Party_Code, C1.Cl_Code, C1.Branch_Cd, C1.Trader, C1.Sub_Broker 
        Into #Client_List 
        From msajag..Client1 C1, msajag..Client2 C2 
        Where C1.Cl_Code = C2.Cl_Code
        And C2.Party_Code Between @from_party_code And @to_party_code
        And C1.Branch_Cd = @branch_cd

        Select @@cnt = count(1) 
        From #Client_List 

        if @@cnt = 0
        begin
                Select Error_Message = 'Party range does not exist'
                Return
        end


set @@cnt = 0

        Select @@cnt = count(1) 
        From msajag..Branch 
        where branch_code = @new_branch_cd 

        if @@cnt <> 1
        begin
                Select Error_Message = 'New Branch Code entered does not exist'
                Return
        end

set @@cnt = 0

        Select @@cnt = count(1) 
        From msajag..SubBrokers 
        where sub_broker = @new_sub_broker 
        and branch_code = @new_branch_cd 

        if @@cnt <> 1
        begin
                Select Error_Message = 'New Sub Broker Code entered is not mapped to the New Branch Code'
                Return
        end

set @@cnt = 0

        Select @@cnt = count(1) 
        From msajag..Branches 
        where short_name = @new_trader 
        and branch_cd = @new_branch_cd 

        if @@cnt <> 1
        begin
                Select Error_Message = 'New Trader Code entered is not mapped to the New Branch Code'
                Return
        end


/*=================================================================================
        Start Update for Client Master
=================================================================================*/
        Update 
                msajag..ClientMaster 
        Set 
                Branch_Cd = @new_branch_cd, 
                Sub_Broker = @new_sub_broker, 
                Trade = @new_trader 
        From 
                #Client_List C 
        Where msajag..ClientMaster.Party_Code = C.Party_Code

        Insert Into pradnya..V2_Branch_Shifting_Summary_Log 
        Select @@sno, @from_party_code, @to_party_code, @branch_cd, @new_branch_cd, @new_trader, @new_sub_broker, 
        'msajag..ClientMaster', @@rowcount, @@spid, system_user, @@update_date  

        Update 
                msajag..Client1 
        Set 
                Branch_Cd = @new_branch_cd, 
                Sub_Broker = @new_sub_broker, 
                Trade = @new_trader 
        From 
                #Client_List C 
        Where msajag..Client1.Cl_Code = C.Cl_Code

        Insert Into pradnya..V2_Branch_Shifting_Summary_Log 
        Select @@sno, @from_party_code, @to_party_code, @branch_cd, @new_branch_cd, @new_trader, @new_sub_broker, 
        'msajag..Client1', @@rowcount, @@spid, system_user, @@update_date  
        
        Update 
                bsedb..Client1 
        Set 
                Branch_Cd = @new_branch_cd, 
                Sub_Broker = @new_sub_broker, 
                Trade = @new_trader 
        From 
                #Client_List C 
        Where bsedb..Client1.Cl_Code = C.Cl_Code

        Insert Into pradnya..V2_Branch_Shifting_Summary_Log 
        Select @@sno, @from_party_code, @to_party_code, @branch_cd, @new_branch_cd, @new_trader, @new_sub_broker, 
        'bsedb..Client1', @@rowcount, @@spid, system_user, @@update_date  

        Update 
                nsefo..Client1 
        Set 
                Branch_Cd = @new_branch_cd, 
                Sub_Broker = @new_sub_broker, 
                Trade = @new_trader 
        From 
                #Client_List C 
        Where nsefo..Client1.Cl_Code = C.Cl_Code

        Insert Into pradnya..V2_Branch_Shifting_Summary_Log 
        Select @@sno, @from_party_code, @to_party_code, @branch_cd, @new_branch_cd, @new_trader, @new_sub_broker, 
        'nsefo..Client1', @@rowcount, @@spid, system_user, @@update_date  


/*=================================================================================
        Start Update for Reporting Table
=================================================================================*/
        Update 
                msajag..CMBillValan 
        Set 
                Branch_Cd = @new_branch_cd, 
                Sub_Broker = @new_sub_broker, 
                Trade = @new_trader 
        From 
                #Client_List C 
        Where msajag..CMBillValan.Party_Code = C.Party_Code

        Insert Into pradnya..V2_Branch_Shifting_Summary_Log 
        Select @@sno, @from_party_code, @to_party_code, @branch_cd, @new_branch_cd, @new_trader, @new_sub_broker, 
        'msajag..CMBillValan', @@rowcount, @@spid, system_user, @@update_date  


        Update 
                BSEDB..CMBillValan 
        Set 
                Branch_Cd = @new_branch_cd, 
                Sub_Broker = @new_sub_broker, 
                Trade = @new_trader 
        From 
                #Client_List C 
        Where BSEDB..CMBillValan.Party_Code = C.Party_Code

        Insert Into pradnya..V2_Branch_Shifting_Summary_Log 
        Select @@sno, @from_party_code, @to_party_code, @branch_cd, @new_branch_cd, @new_trader, @new_sub_broker, 
        'BSEDB..CMBillValan', @@rowcount, @@spid, system_user, @@update_date  

        Update 
                NSEFO..FOBillValan 
        Set 
                Branch_Cd = @new_branch_cd, 
                Sub_Broker = @new_sub_broker, 
                Trade = @new_trader 
        From 
                #Client_List C 
        Where NSEFO..FOBillValan.Party_Code = C.Party_Code

        Insert Into pradnya..V2_Branch_Shifting_Summary_Log 
        Select @@sno, @from_party_code, @to_party_code, @branch_cd, @new_branch_cd, @new_trader, @new_sub_broker, 
        'NSEFO..FOBillValan', @@rowcount, @@spid, system_user, @@update_date  

/*=================================================================================
        Start Update for Accounts Data Ledger2
=================================================================================*/

        Update 
                Account..Ledger2 
        Set 
                CostCode = @@nsecmcostcode
        From 
                #Client_List C 
        Where Account..Ledger2.CltCode = C.Party_Code

        Insert Into pradnya..V2_Branch_Shifting_Summary_Log 
        Select @@sno, @from_party_code, @to_party_code, @branch_cd, @new_branch_cd, @new_trader, @new_sub_broker, 
        'Account..Ledger2', @@rowcount, @@spid, system_user, @@update_date  


        Update 
                Accountbse..Ledger2 
        Set 
                CostCode = @@bsecmcostcode
        From 
                #Client_List C 
        Where Accountbse..Ledger2.CltCode = C.Party_Code

        Insert Into pradnya..V2_Branch_Shifting_Summary_Log 
        Select @@sno, @from_party_code, @to_party_code, @branch_cd, @new_branch_cd, @new_trader, @new_sub_broker, 
        'Accountbse..Ledger2', @@rowcount, @@spid, system_user, @@update_date  

        Update 
                Accountfo..Ledger2 
        Set 
                CostCode = @@nsefocostcode
        From 
                #Client_List C 
        Where Accountfo..Ledger2.CltCode = C.Party_Code

        Insert Into pradnya..V2_Branch_Shifting_Summary_Log 
        Select @@sno, @from_party_code, @to_party_code, @branch_cd, @new_branch_cd, @new_trader, @new_sub_broker, 
        'Accountfo..Ledger2', @@rowcount, @@spid, system_user, @@update_date  


        Insert Into pradnya..V2_Branch_Shifting_Detail_Log 
        Select @@sno, Party_Code, Cl_Code, Branch_Cd, Trader, Sub_Broker, @new_branch_cd, @new_trader, @new_sub_broker, 
        @@spid, system_user, @@update_date  
        From #Client_List 

Return

GO
