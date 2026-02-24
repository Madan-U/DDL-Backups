-- Object: PROCEDURE dbo.rpt_branchloginclinentlist
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure  rpt_branchloginclinentlist      
            
@order_by as varchar(9),            
@statusid varchar(15),            
@statusname varchar(25)            
as        
select c1.short_name,c1.long_name,c1.res_phone1,c1.off_phone1,c1.cl_code,c1.email,            
 c1.branch_cd,c1.family,c1.sub_broker,c1.trader,            
 c2.party_code,c2.turnover_tax,c2.sebi_turn_tax,insurance_chrg,brokernote,other_chrg,            
 c3.branch,c4.short_name as trader_name,c5.name,c5.com_perc,c1.pan_gir_no,            
 convert(varchar(11),ActiveFrom) as ActiveFrom ,          
 convert(varchar(11),InactiveFrom) as InactiveFrom,            
 CL5.Introducer,CL5.Approver,       
 ORDERBYFLAG = (CASE WHEN @order_by='Branch' THEN C1.BRANCH_CD      
      WHEN @order_by='SubBroker' THEN C1.SUB_BROKER      
      WHEN @order_by='Client' THEN C1.SHORT_NAME      
      WHEN @order_by='FAMILY' THEN C1.FAMILY            
      ELSE '1'      
    END),      
ORDERBYFLAG1 = (CASE WHEN @order_by='ACTIVE' THEN ActiveFrom       
      WHEN @order_by='InActive' THEN InactiveFrom      
      ELSE 'DEC 31 2049'      
    END)      
 from client1 c1 with( /* index(clcode), */ nolock), Client5 CL5 with( /* index(PK_Client5), */ nolock)       
 ,client2 c2 with(/* index(PK_Client2),*/ nolock) ,branch c3 with(/* Index(PK_BRANCH_CODE),*/ nolock) ,branches c4 (nolock) ,subbrokers c5 (nolock)             
 where c1.cl_code=c2.cl_code and            
 c1.branch_cd=c3.branch_code and            
 c1.trader=c4.short_name and            
 c1.sub_broker=c5.sub_broker and            
 c3.branch_code=c4.branch_cd      
 and CL5.Cl_Code = C1.Cl_Code      
 And @StatusName =                 
                  (case                 
                        when @StatusId = 'BRANCH' then c1.branch_cd                
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                
                        when @StatusId = 'Trader' then c1.Trader                
                        when @StatusId = 'Family' then c1.Family                
                        when @StatusId = 'Area' then c1.Area                
                        when @StatusId = 'Region' then c1.Region                
                        when @StatusId = 'Client' then c2.party_code                
                  else                 
                        'BROKER'                
                  End)                
 order by ORDERBYFLAG,ORDERBYFLAG1,c2.party_code

GO
