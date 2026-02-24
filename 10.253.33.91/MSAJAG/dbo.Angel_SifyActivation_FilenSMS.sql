-- Object: PROCEDURE dbo.Angel_SifyActivation_FilenSMS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc Angel_SifyActivation_FilenSMS            
as      
begin          
Set Nocount On            
select party_code,SifyActStatus,remarks into #ff from intranet.misc.dbo.sifyclient --where SifyActStatus='A'           
            
select branch_Cd,Sub_broker,PArty_Code=ltrim(rtrim(party_Code)),            
PArty_name=long_name,            
DateOfBirth=replace(convert(varchar(10),DOB,104),'.',''),ECN_RegnNo=repatriat_bank_ac_no,            
FirstName=ltrim(rtrim(substring(long_name,1,charindex(' ',long_name)))),            
LastName=ltrim(rtrim(reverse(substring(reverse(long_name),0,charindex(' ',reverse(long_name)))))),            
remarks='New ECN Clients',SifyActLetterDt=getdate(),SifyActDt=getdate(),SifyActStatus='P',            
SifyDeActDt='Dec 31 2049',    
MblNum=mobile_Pager,     
SMS='Your SIFY mailbox details are -Login: '+ltrim(rtrim(party_Code))+'@ecn.sify.com password: '+ replace(convert(varchar(10),DOB,104),'.','')+' For further details please logon to http://mail.ecn.sify.com'          
into #bb       
from client_details a(nolock)            
join            
(            
 select cl_code,ldate=max(inactive_from) from client_brok_details (nolock) group by cl_code            
) b            
on a.party_code=b.cl_code             
where repatriat_bank_ac_no like 'ECN%'    
and party_code not like 'ZR%'     
and party_code not like '98%'             
and ldate>Getdate()            
            
select * into #bb1 from #bb where party_code not in (select party_code from #ff where SifyActStatus='A')            
and party_code not like 'ZR%'      
            
update #bb1 set             
firstname = ltrim(rtrim(substring(party_name,1,charindex('.',party_name)))),            
lastname=ltrim(rtrim(reverse(substring(reverse(party_name),0,charindex('.',reverse(party_name))))))            
where charindex('.',party_name) > 0 and firstname='' and lastname=''            
            
update #bb1 set             
firstname = party_name          
where firstname=''         
        
update #bb1 set   lastname=substring(party_name,1,20) where lastname=''        
            
update #bb1 set firstname=replace(firstname,'.',''),lastname=replace(lastname,'.','')            
update #bb1 set firstname=replace(firstname,',',''),lastname=replace(lastname,',','')            
update #bb1 set firstname=replace(firstname,'~',''),lastname=replace(lastname,'~','')            
update #bb1 set firstname=replace(firstname,'@',''),lastname=replace(lastname,'@','')            
update #bb1 set firstname=replace(firstname,'#',''),lastname=replace(lastname,'#','')            
update #bb1 set firstname=replace(firstname,'$',''),lastname=replace(lastname,'$','')            
update #bb1 set firstname=replace(firstname,'^',''),lastname=replace(lastname,'^','')            
update #bb1 set firstname=replace(firstname,'&',''),lastname=replace(lastname,'&','')            
update #bb1 set firstname=replace(firstname,'*',''),lastname=replace(lastname,'*','')            
update #bb1 set firstname=replace(firstname,'(',''),lastname=replace(lastname,'(','')            
update #bb1 set firstname=replace(firstname,')',''),lastname=replace(lastname,')','')            
update #bb1 set firstname=replace(firstname,'-',''),lastname=replace(lastname,'-','')            
update #bb1 set firstname=replace(firstname,'[',''),lastname=replace(lastname,'[','')            
update #bb1 set firstname=replace(firstname,']',''),lastname=replace(lastname,']','')            
update #bb1 set firstname=replace(firstname,'\',''),lastname=replace(lastname,'\','')            
update #bb1 set firstname=replace(firstname,'/',''),lastname=replace(lastname,'/','')            
update #bb1 set firstname=replace(firstname,'?',''),lastname=replace(lastname,'?','')            
update #bb1 set firstname=replace(firstname,'<',''),lastname=replace(lastname,'<','')            
update #bb1 set firstname=replace(firstname,'>',''),lastname=replace(lastname,'>','')            
update #bb1 set firstname=replace(firstname,' ',''),lastname=replace(lastname,' ','')            
           
insert into intranet.misc.dbo.sifyclient             
(Branch_cd,sub_Broker,Party_Code,PArty_name,DateOfBirth,ECN_RegnNo,FirstName,LastName,Remarks,            
SifyActStatus,SifyDeActDt)            
select branch_Cd,Sub_broker,PArty_Code,PArty_name,DateOfBirth,ECN_RegnNo,FirstName,LastName,remarks,SifyActStatus,SifyDeActDt            
from   #bb1            
where party_code not in (select party_code from #ff)           
        
select party_code,fname=firstName,lname=lastName,DOb=dateofBirth,    
	MblNum=(case when len(MblNum)>=10 then '+91'+ reverse(left(reverse(MblNum),10)) else MblNum end),
	SMS  from #bb1            
            
Set Nocount Off            
end

GO
