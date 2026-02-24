-- Object: PROCEDURE dbo.aTrdLogUp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*Latest changed on 15 Oct 2001 to include the branch condition by Deepali S.Naidu*/
CREATE Procedure aTrdLogUp 
@statusid varchar(12),
@statusname varchar(12)
as
if @statusid <> 'broker'
begin
insert into TrdLog
select t.User_Id,Sauda_Date=left(convert(varchar,t.sauda_date,109),11), Time = convert(char,getdate(),108),
       PQty = ( select isnull(sum(tradeqty),0) from atrade where sell_buy = 1 and user_id = t.user_id ),
       SQty = ( select isnull(sum(tradeqty),0) from atrade where sell_buy = 2 and user_id = t.user_id ),
       PRate = ( select isnull(sum(tradeqty*marketrate),0) from atrade where sell_buy = 1 and user_id = t.user_id ),
       SRate = ( select isnull(sum(tradeqty*marketrate),0) from atrade where sell_buy = 2 and user_id = t.user_id ),0,''     
       from atrade t , branch b, branches b1 where 
       t.user_id = b1.terminal_id and b.BRANCH_CODE = b1.Branch_cd 
       and b.branch = @statusname
       group by user_id,left(convert(varchar,t.sauda_date,109),11)
end 
else
begin
insert into TrdLog
select t.User_Id,Sauda_Date=left(convert(varchar,t.sauda_date,109),11), Time = convert(char,getdate(),108),
       PQty = ( select isnull(sum(tradeqty),0) from atrade where sell_buy = 1 and user_id = t.user_id ),
       SQty = ( select isnull(sum(tradeqty),0) from atrade where sell_buy = 2 and user_id = t.user_id ),
       PRate = ( select isnull(sum(tradeqty*marketrate),0) from atrade where sell_buy = 1 and user_id = t.user_id ),
       SRate = ( select isnull(sum(tradeqty*marketrate),0) from atrade where sell_buy = 2 and user_id = t.user_id ),0,''     
       from atrade t , branch b, branches b1 where 
       t.user_id = b1.terminal_id and b.BRANCH_CODE = b1.Branch_cd 
       group by user_id,left(convert(varchar,t.sauda_date,109),11)
end

GO
